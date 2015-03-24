# Reading a MySQL View
class ContractContainer < ActiveRecord::Base
  include Delegation::ContractContainer

  def readonly?
    true
  end

  self.primary_key = :id # needed for json serialization

  def id
    r = read_attribute(:id)
    if r.nil? # it is not persisted
      "#{status}_#{user_id}_#{inventory_pool_id}"
    elsif r.include?('_')
      r
    else
      r.to_i
    end
  end

  belongs_to :inventory_pool
  belongs_to :user
  belongs_to :delegated_user

  belongs_to :document, class_name: "Contract", foreign_key: :id
  delegate :note, to: :document

  has_many :contract_lines, -> (r){ where("(contract_lines.status IN ('#{:signed}', '#{:closed}') AND contract_lines.contract_id = ?)
                                            OR (contract_lines.status NOT IN ('#{:signed}', '#{:closed}') AND contract_lines.user_id = ? AND contract_lines.status = ?)",
                                            r.id, r.user_id, r.status) }, foreign_key: :inventory_pool_id, primary_key: :inventory_pool_id
  alias :lines :contract_lines
  has_many :item_lines, -> (r){ where("(contract_lines.status IN ('#{:signed}', '#{:closed}') AND contract_lines.contract_id = ?)
                                        OR (contract_lines.status NOT IN ('#{:signed}', '#{:closed}') AND contract_lines.user_id = ? AND contract_lines.status = ?)",
                                        r.id, r.user_id, r.status) }, foreign_key: :inventory_pool_id, primary_key: :inventory_pool_id
  has_many :option_lines, -> (r){ where("(contract_lines.status IN ('#{:signed}', '#{:closed}') AND contract_lines.contract_id = ?)
                                          OR (contract_lines.status NOT IN ('#{:signed}', '#{:closed}') AND contract_lines.user_id = ? AND contract_lines.status = ?)",
                                          r.id, r.user_id, r.status) }, foreign_key: :inventory_pool_id, primary_key: :inventory_pool_id
  has_many :models, -> { order('models.product ASC').uniq }, :through => :item_lines
  has_many :items, :through => :item_lines
  has_many :options, -> { uniq }, :through => :option_lines

  #6628029# has_many :histories, -> { order(:created_at) }, as: :target, dependent: :delete_all

  #######################################################

  STATUSES = [:unsubmitted, :submitted, :rejected, :approved, :signed, :closed]

  def status
    read_attribute(:status).to_sym
  end

  STATUSES.each do |status|
    scope status, -> {where(status: status)}
  end

  #6628029# fetch directly contracts ??
  scope :signed_or_closed, -> {where(status: [:signed, :closed])}

  #######################################################

  scope :with_verifiable_user, -> { where(verifiable_user: true) }

  scope :with_verifiable_user_and_model, -> { where(verifiable_user_and_model: true) }

  scope :no_verification_required, -> { where.not(verifiable_user_and_model: true) }

  def is_to_be_verified
    verifiable_user_and_model
  end

  #######################################################

  scope :search, lambda { |query|
                 return all if query.blank?

                 sql = uniq.
                     joins("INNER JOIN contract_lines ON
                            contract_containers.user_id = contract_lines.user_id
                            AND contract_containers.inventory_pool_id = contract_lines.inventory_pool_id
                            AND (
                                (contract_containers.status IN ('#{:signed}', '#{:closed}') AND contract_containers.id = contract_lines.contract_id)
                              OR
                                (contract_containers.status NOT IN ('#{:signed}', '#{:closed}') AND contract_containers.status = contract_lines.status)
                            )").
                     # joins("INNER JOIN contract_lines ON contract_lines.id IN contract_containers.contract_line_ids").
                     joins("INNER JOIN users ON users.id = contract_containers.user_id").
                     joins("LEFT JOIN contracts ON contract_containers.id = contracts.id AND contract_containers.status IN ('#{:signed}', '#{:closed}')").
                     joins("LEFT JOIN options ON options.id = contract_lines.option_id").
                     joins("LEFT JOIN models ON models.id = contract_lines.model_id").
                     joins("LEFT JOIN items ON items.id = contract_lines.item_id")

                 query.split.each { |q|
                   qq = "%#{q}%"
                   sql = sql.where(
                       # "contract_lines.id = '#{q}' OR
                       #  CONCAT_WS(' ', contracts.note, users.login, users.firstname, users.lastname, users.badge_id,
                       #                 models.manufacturer, models.product, models.version, options.product,
                       #                 options.version, items.inventory_code, items.properties) LIKE '%#{qq}%'"

                       ##arel_table[:id].eq(q.numeric? ? q : 0) # NOTE we cannot use eq(q) because alphanumeric string is truncated and casted to integer, causing wrong matches (contracts.id)
                       arel_table[:id].eq(q)
                           .or(Contract.arel_table[:note].matches(qq))
                           .or(User.arel_table[:login].matches(qq))
                           .or(User.arel_table[:firstname].matches(qq))
                           .or(User.arel_table[:lastname].matches(qq))
                           .or(User.arel_table[:badge_id].matches(qq))
                           .or(Model.arel_table[:manufacturer].matches(qq))
                           .or(Model.arel_table[:product].matches(qq))
                           .or(Model.arel_table[:version].matches(qq))
                           .or(Option.arel_table[:product].matches(qq))
                           .or(Option.arel_table[:version].matches(qq))
                           .or(Item.arel_table[:inventory_code].matches(qq))
                           .or(Item.arel_table[:properties].matches(qq))
                   )
                 }
                 sql
               }

  ############################################

  def min_date
    unless lines.blank?
      lines.min { |x| x.start_date }[:start_date]
    else
      nil
    end
  end

  def max_date
    unless lines.blank?
      lines.max { |x| x.end_date }[:end_date]
    else
      nil
    end
  end

  def max_range
    return nil if lines.blank?
    line = lines.max_by { |x| (x.end_date - x.start_date).to_i }
    (line.end_date - line.start_date).to_i + 1
  end

  ############################################

  def time_window_min
    lines.minimum(:start_date) || Date.today
  end

  def time_window_max
    lines.maximum(:end_date) || Date.today
  end

  def next_open_date(x)
    x ||= Date.today
    if inventory_pool
      inventory_pool.next_open_date(x)
    else
      x
    end
  end

  ############################################

  def add_lines(quantity, model, current_user, start_date = nil, end_date = nil)
    if end_date and start_date and end_date < start_date
      end_date = start_date
    end

    attrs = { inventory_pool: inventory_pool,
              status: status,
              quantity: 1,
              model: model,
              start_date: start_date || time_window_min,
              end_date: end_date || next_open_date(time_window_max),
              delegated_user_id: delegated_user_id}

    new_lines = quantity.to_i.times.map do
      line = user.item_lines.create(attrs) #6628029# do |l|
      #6628029# l.purpose = lines.first.purpose if submitted_with_purpose?
      #6628029# end

      #6628029#
      # unless line.new_record?
      #   log_change(_("Added") + " #{attrs[:quantity]} #{attrs[:model].name} #{attrs[:start_date]} #{attrs[:end_date]}", current_user.try(:id))
      # end

      line
    end

    new_lines
  end

  ################################################################

  def swap_line(line_id, model_id, user_id)
    line = lines.find(line_id.to_i)
    if (line.model.id != model_id.to_i)
      model = Model.find(model_id.to_i)
      change = _("Swapped %{from} for %{to}") % {:from => line.model.name, :to => model.name}
      line.item = nil if line.is_a?(ItemLine)
      line.model = model
      #6628029# log_change(change, user_id)
      line.save
    end
  end

  ################################################################

  def remove_line(line, user_id)
    if [:unsubmitted, :submitted, :approved].include?(status)
      if lines.include? line and line.destroy
        #6628029# log_change _("Removed %{q} %{m}") % {:q => line.quantity, :m => line.model.name}, user_id
        true
      else
        false
      end
    else
      false
    end
  end

  ############################################

  def purpose
    if [:unsubmitted, :submitted, :rejected].include? status
      # NOTE all lines should have the same purpose
      # find or build purpose
      lines.detect { |l| l.purpose_id and l.purpose }.try(:purpose) || Purpose.new(:contract_lines => lines, :description => read_attribute(:purpose))
    else
      # join purposes
      lines.sort.map { |x| x.purpose.to_s }.uniq.delete_if { |x| x.blank? }.join("; ")
    end
  end

  def purpose=(description)
    if [:unsubmitted, :submitted, :rejected].include? status
      purpose.change_description(description, lines)
    else
      Purpose.create(description: description, contract_lines: lines.where(purpose_id: nil))
    end
  end

  def change_purpose(new_purpose, user_id)
    change = _("Purpose changed '%s' for '%s'") % [self.purpose.try(:description), new_purpose]
    log_change(change, user_id)
    self.purpose = new_purpose
  end

  ############################################

  # TODO dry with ContractLine
  def target_user
    if user.is_delegation and delegated_user
      delegated_user
    else
      user
    end
  end

  def submit(purpose_description = nil)
    # TODO relate to Application Settings (required_purpose)
    if purpose_description
      purpose = Purpose.create :description => purpose_description
      contract_lines.each { |cl| cl.purpose = purpose }
    end

    if approvable?
      contract_lines.each { |cl| cl.update_attributes(status: :submitted) }

      Notification.order_submitted(self, purpose_description, false)
      Notification.order_received(self, purpose_description, true)
      true
    else
      false
    end
  end

  ############################################

  def approvable?
    contract_lines.all? &:approvable?
  end

  def approve(comment, send_mail = true, current_user = nil, force = false)
    if approvable? or (force and current_user.has_role?(:lending_manager, inventory_pool))
      contract_lines.each { |cl| cl.update_attributes(status: :approved) }
      begin
        Notification.order_approved(self, comment, send_mail, current_user)
      rescue Exception => exception
        # archive problem in the log, so the admin/developper
        # can look up what happened
        logger.error "#{exception}\n    #{exception.backtrace.join("\n    ")}"
        self.errors.add(:base,
                        _("The following error happened while sending a notification email to %{email}:\n") % {:email => target_user.email} +
                            "#{exception}.\n" +
                            _("That means that the user probably did not get the approval mail and you need to contact him/her in a different way."))
      end
      true
    else
      false
    end
  end

  def reject(comment, current_user)
    lines.all? {|line| line.update_attributes(status: :rejected) } and Notification.order_rejected(self, comment, true, current_user)
  end

  def sign(current_user, selected_lines, note = nil, delegated_user_id = nil)
    transaction do
      contract = Contract.create do |contract|
        contract.note = note

        selected_lines.each do |cl|
          attrs = {
              contract: contract,
              status: :signed,
              handed_over_by_user_id: current_user.id
          }

          attrs[:delegated_user] = user.delegated_users.find(delegated_user_id) if delegated_user_id

          # Forces handover date to be today.
          attrs[:start_date] = Date.today if cl.start_date != Date.today

          cl.update_attributes(attrs)

          contract.contract_lines << cl
        end
      end
      #6628029#
      # if contract.valid?
      #   contract.log_history(_("Contract %d has been signed by %s") % [contract.id, contract.contract_lines.first.user.name], current_user.id)
      # end
      contract
    end
  end

  def handed_over_by_user
    if [:signed, :closed].include? status
      lines.first.handed_over_by_user
    else
      nil
    end
  end

  ################################################################

  def total_quantity
    lines.sum(:quantity)
  end

  def total_price
    lines.to_a.sum(&:price)
  end

  #######################
  #

  #6628029#
  # def log_change(text, user_id)
  #   user_id = user_id.id if user_id.is_a? User
  #   histories.create(:text => text, :user_id => user_id, :type_const => History::CHANGE) unless (user and user_id == user.id)
  # end

  #6628029#
  # def log_history(text, user_id)
  #   user_id = user_id.id if user_id.is_a? User
  #   histories.create(:text => text, :user_id => user_id, :type_const => History::ACTION)
  # end

  #6628029#
  # def has_changes?
  #   history = histories.order('created_at DESC, id DESC').first
  #   history.nil? ? false : history.type_const == History::CHANGE
  # end

  #
  #######################

  def submitted_with_purpose?
    status == :submitted and !lines.empty? and lines.first.purpose
  end

end

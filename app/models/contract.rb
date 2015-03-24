class Contract < ActiveRecord::Base
  include LineModules::GroupedAndMergedLines
  include DefaultPagination

  has_many :contract_lines, -> { order('contract_lines.start_date ASC, contract_lines.end_date ASC, contract_lines.created_at ASC') }, :dependent => :destroy #Rails3.1# TODO ContractLin#default_scope
  has_many :item_lines, -> { order('contract_lines.start_date ASC, contract_lines.end_date ASC, contract_lines.created_at ASC') }, :dependent => :destroy
  has_many :option_lines, -> { order('contract_lines.start_date ASC, contract_lines.end_date ASC, contract_lines.created_at ASC') }, :dependent => :destroy
  has_many :models, -> { order('contract_lines.start_date ASC, contract_lines.end_date ASC, models.product ASC').uniq }, :through => :item_lines
  has_many :items, :through => :item_lines
  has_many :options, -> { uniq }, :through => :option_lines

  #########################################################################

  validate do
    if contract_lines.empty?
      errors.add(:base, _("This contract is not signable because it doesn't have any contract lines."))
    end
    if contract_lines.any? { |line| not [:signed, :closed].include?(line.status) }
      errors.add(:base, _("The assigned contract lines have to be marked either as signed or as closed"))
    end
    if contract_lines.map(&:start_date).uniq.size != 1
      errors.add(:base, _("The start_date is not unique"))
    end
    unless ContractLine.any_with_purpose? contract_lines
      errors.add(:base, _("This contract is not signable because none of the lines have a purpose."))
    end
    unless ContractLine.all_with_assigned_item? contract_lines
      errors.add(:base, _("This contract is not signable because some lines are not assigned."))
    end
    unless ContractLine.all_with_end_date_after_start_date contract_lines
      errors.add(:base, _("Start Date must be before End Date"))
    end
  end
  #########################################################################

  # alias
  def lines(reload = false)
    contract_lines(reload)
  end

  # compares two objects in order to sort them
  def <=>(other)
    self.created_at <=> other.created_at
  end

  def to_s
    "#{id}"
  end

  TIMEOUT_MINUTES = 30

  #########################################################################

  def self.filter(params, user = nil, inventory_pool = nil)
    #6628029#  TODO params[:status] should be required ??
    # if [:signed, :closed].include? Array(params[:status]).first.to_sym
    #   contracts = if user
    #                 user.contracts
    #               elsif inventory_pool
    #                 inventory_pool.contracts
    #               else
    #                 all
    #               end
    #   klass = Contract
    #   contracts = contracts.where(contract_lines: {status: params[:status]}) #if params[:status]
    # else
      contracts = if user
                    user.contracts #user.contract_containers
                  elsif inventory_pool
                    inventory_pool.contracts #inventory_pool.contract_containers
                  else
                    ContractContainer.all
                  end
      klass = ContractContainer
      contracts = contracts.where(status: params[:status]) if params[:status]
    # end

    contracts = contracts.search(params[:search_term]) unless params[:search_term].blank?

    contracts = if params[:no_verification_required]
                  contracts.no_verification_required
                elsif params[:to_be_verified]
                  contracts.with_verifiable_user_and_model
                elsif params[:from_verifiable_users]
                  contracts.with_verifiable_user
                else
                  contracts
                end

    contracts = contracts.where(id: params[:ids]) if params[:ids]

    if r = params[:range]
      created_at_date = Arel::Nodes::NamedFunction.new "CAST", [klass.arel_table[:created_at].as("DATE")]
      contracts = contracts.where(created_at_date.gteq(r[:start_date])) if r[:start_date]
      contracts = contracts.where(created_at_date.lteq(r[:end_date])) if r[:end_date]
    end

    contracts = contracts.order(klass.arel_table[:created_at].desc)

    # computing total_entries with count(distinct: true) explicitly, because default contracts.count used by paginate plugin seems to override the DISTINCT option and thus returns wrong result. See https://stackoverflow.com/questions/7939719/will-paginate-generates-wrong-number-of-page-links
    contracts = contracts.default_paginate(params, total_entries: contracts.count) unless params[:paginate] == "false"
    contracts
  end

  #########################################################################

  def action
    if status == :submitted
      :acknowledge
    elsif status == :approved
      :hand_over
    elsif status == :signed
      :take_back
    else
      nil
    end
  end

end

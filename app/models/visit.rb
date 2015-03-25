# A Visit is an event on a particular date, on which a specific
# customer should come to pick up or return items - or from the other perspective:
# when an inventory pool manager should hand over some items to or get them back from the customer.
#
# 'action' says if we want to have hand_overs or take_backs. action can be either of those two:
# * "hand_over"
# * "take_back"
#
# Reading a MySQL View
class Visit < ContractLinesBundle
  include LineModules::GroupedAndMergedLines
  include DefaultPagination

  self.table_name = "contract_lines_bundles"

  default_scope { where.not(visit_date: nil) }

  scope :hand_over, lambda { where(status: :approved) }
  scope :take_back, lambda { where(status: :signed) }
  scope :take_back_overdue, lambda { take_back.where("visit_date < ?", Date.today) }

  #######################################################

  scope :search, lambda { |query|
    sql = all
    return sql if query.blank?

    # TODO search on contract_lines' models and items
    query.split.each{|q|
      q = "%#{q}%"
      sql = sql.where(User.arel_table[:login].matches(q).
                      or(User.arel_table[:firstname].matches(q)).
                      or(User.arel_table[:lastname].matches(q)).
                      or(User.arel_table[:badge_id].matches(q)))
    }
    sql.joins(:user)
  }

  def self.filter(params, inventory_pool = nil)
    visits = inventory_pool.nil? ? all : inventory_pool.visits
    visits = visits.where(status: params[:status]) if params[:status]
    if params[:actions]
      actions = []
      actions << :approved if params[:actions].include? "hand_over"
      actions << :signed if params[:actions].include? "take_back"
      visits = visits.where(action: actions)
    end
    visits = visits.search(params[:search_term]) unless params[:search_term].blank?
    visits = visits.where Visit.arel_table[:visit_date].lteq(params[:date]) if params[:date] and params[:date_comparison] == "lteq"
    visits = visits.where Visit.arel_table[:visit_date].eq(params[:date]) if params[:date] and params[:date_comparison] == "eq"

    if r = params[:range]
      visits = visits.where(Visit.arel_table[:visit_date].gteq(r[:start_date])) if r[:start_date]
      visits = visits.where(Visit.arel_table[:visit_date].lteq(r[:end_date])) if r[:end_date]
    end

    visits = visits.default_paginate params unless params[:paginate] == "false"
    visits
  end

  def action
    if status == :approved
      :hand_over
    elsif status == :signed
      :take_back
    # elsif status == :submitted
    #   :acknowledge
    # else
    #   nil
    end
  end

  def date
    visit_date
  end

end

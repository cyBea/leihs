module Availability

  ETERNITY = Date.parse("3000-01-01")

  class Changes < Hash

    def between(start_date, end_date)
      # start from most recent entry we have, which is the last before start_date
      start_date = most_recent_before_or_equal(start_date) || start_date

      keys_between = keys & (start_date..end_date).to_a
      #tmp# select {|k,v| keys_between.include?(k) }
      Hash[keys_between.map{|x| [x, self[x]]}]
    end

    def end_date_of(date)
      first_after(date).try(:yesterday) || Availability::ETERNITY
    end

    # If there isn't a change on "new_date" then a new change will be added with the given "new_date".
    #   The newly created change will have the same quantities associated as the change preceding it.
    def insert_changes_and_get_inner(start_date, end_date)
      [start_date, end_date.tomorrow].each do |new_date|
        self[new_date] ||= begin
          change = self[most_recent_before_or_equal(new_date)]
          Marshal.load( Marshal.dump(change) ) # NOTE we copy values (we don't want references with .dup)
        end
      end
      between(start_date, end_date)
    end

    private

    # returns a change, the last before the date argument
    def most_recent_before_or_equal(date) # TODO ?? rename to last_before_or_equal(date)
      #tmp# k = keys.sort.reverse.detect {|x| x <= date}
      keys.select {|x| x <= date}.max
    end

    # returns a change, the first after the date argument
    def first_after(date)
      #tmp# k = keys.sort.detect {|x| x > date}
      keys.select {|x| x > date}.min
    end

  end

#########################################################

  class Main
    attr_reader :document_lines, :partitions, :changes, :inventory_pool_and_model_group_ids

    def initialize(attr)
      @model          = attr[:model]
      @inventory_pool = attr[:inventory_pool]
      # we use array select instead of sql where condition to fetch once all document_lines during the same request, instead of hit the db multiple times
      @document_lines = @inventory_pool.running_lines.select {|line| line.model_id == @model.id}
      @partitions     = @inventory_pool.partitions_with_generals.hash_for_model_and_groups(@model)
      @inventory_pool_and_model_group_ids = (@inventory_pool.loaded_group_ids ||= @inventory_pool.group_ids) & @partitions.keys

      initial_change = {}
      @partitions.each_pair do |group_id, quantity|
        initial_change[group_id] = {:in_quantity => quantity, :out_document_lines => {}}
      end
      @changes = Changes[Date.today => initial_change]

      @document_lines.each do |document_line|
        document_line_group_ids = document_line.concat_group_ids.to_s.split(',').map(&:to_i) # read from the running_line
        document_line.is_late = document_line.is_late > 0 if document_line.is_late.is_a? Fixnum # read from the running_line 

        # if overdue, extend end_date to today
        # given a reservation is running until the 24th and maintenance period is 0 days:
        # - if today is the 15th, thus the item is available again from the 25th
        # - if today is the 27th, thus the item is available again from the 28th
        # the replacement_interval is 1 month 
        unavailable_until = [(document_line.is_late ? Date.today + 1.month : document_line.end_date), Date.today].max + @model.maintenance_period.day

        # we don't recalculate the past
        inner_changes = @changes.insert_changes_and_get_inner(document_line.unavailable_from, unavailable_until)

        # this is the order on the groups we check on:   
        # 1. groups that this particular document_line can be possibly assigned to, TODO sort groups by quantity desc ??
        # 2. general group
        # 3. groups which the user is not even member
        groups_to_check = (document_line_group_ids & @inventory_pool_and_model_group_ids) + [Group::GENERAL_GROUP_ID] + (@inventory_pool_and_model_group_ids - document_line_group_ids)
        maximum = available_quantities_for_groups(groups_to_check, inner_changes)
        # if still no group has enough available quantity, we allocate to general as fallback
        document_line.allocated_group_id = groups_to_check.detect(proc {Group::GENERAL_GROUP_ID}) {|group_id| maximum[group_id] >= document_line.quantity }

        inner_changes.each_pair do |key, ic|
          qty = ic[document_line.allocated_group_id]
          qty[:in_quantity]  -= document_line.quantity
          qty[:out_document_lines]["ItemLine"] ||= []
          qty[:out_document_lines]["ItemLine"] << document_line.id
        end
      end
    end

    def maximum_available_in_period_for_groups(start_date, end_date, group_ids)
      quantities_for_groups_with_general_in_date_range(start_date, end_date, group_ids).max
    end

    def maximum_available_in_period_summed_for_groups(start_date, end_date, group_ids = nil)
      group_ids ||= @inventory_pool_and_model_group_ids
      quantities_for_groups_with_general_in_date_range(start_date, end_date, group_ids).sum
    end

    def available_total_quantities
      # sort by date !!!
      Hash[@changes.sort].map do |date, change|
        total = change.values.sum{|x| x[:in_quantity]}
        groups = change.map do |g, q|
          q.merge({:group_id => g})
        end
        [date, total, groups]
      end
    end

    private

    def quantities_for_groups_with_general_in_date_range(start_date, end_date, group_ids)
      available_quantities_for_groups([Group::GENERAL_GROUP_ID] + (group_ids & @inventory_pool_and_model_group_ids), @changes.between(start_date, end_date)).values
    end

    # returns a Hash {group_id => quantity}
    def available_quantities_for_groups(group_ids, inner_changes = nil)
      inner_changes ||= @changes
      h = {}
      group_ids.each do |group_id|
        h[group_id] = inner_changes.values.map{|c| c[group_id].try(:fetch, :in_quantity).to_i }.min.to_i
      end
      h
    end

  end
end

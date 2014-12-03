When /^I pick a closed day for beeing the "(.*?)"$/ do |date_target|
  next_closed_day = nil
  date = Date.today
  expect(has_selector?("td[data-date]")).to be true
  if all("td[data-date='#{date}']").empty? then
    date = Date.new(date.year, date.month + 1)
  end

  while next_closed_day.nil?
    next_date = @current_inventory_pool.next_open_date date+1.day
    next_closed_day = (next_date - 1.day) if (next_date-date).to_i > 1
    date = date+1.day
  end
  @date_el = get_fullcalendar_day_element(next_closed_day)
  @date_el.click
  find("#set-start-date", :text => _("Start Date")).click if date_target == "start date"
  find("#set-end-date", :text => _("End Date")).click if date_target == "end date"
end

Then /^the "(.*)" date becomes red and I see a closed day warning$/ do |arg1|
  expect(@date_el[:class][/closed/]).not_to be_nil
  s = case arg1
        when "start date"
          _("Inventory pool is closed on start date")
        when "end date"
          _("Inventory pool is closed on end date")
        else
          raise
      end
  find(".red", text: s)
end

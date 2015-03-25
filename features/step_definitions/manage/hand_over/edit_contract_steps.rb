When /^I select all lines$/ do
  all(".line").each do |line|
    cb = line.find("input[type=checkbox][data-select-line]")
    cb.click unless cb.checked?
  end
  expect(all(".line input[type=checkbox][data-select-line]").all? {|x| x.checked? }).to be true
end

When /^I change the time range for all contract lines, envolving option and item lines$/ do
  step 'I add an option to the hand over by providing an inventory code and a date range'
  step 'I select all lines'
  step 'I edit the timerange of the selection'
  @line = @hand_over.lines.first
  @old_start_date = @line.start_date
  @new_start_date = if @line.start_date + 1.day < Date.today
      Date.today
    else
      @line.start_date + 1.day
  end
  get_fullcalendar_day_element(@new_start_date).click
  find("#set-start-date", :text => _("Start date")).click
  step 'I save the booking calendar'
  step 'the booking calendar is closed'
end

Then /^the time range for all contract lines is changed$/ do
  @customer.visits.where(inventory_pool_id: @current_inventory_pool).hand_over.detect{|x| x.lines.size > 1}.lines.each do |line|
    expect(line.start_date).to eq @new_start_date
  end
end

When /^I change the time range for that option$/ do
  find(".line[data-line-type='option_line'][data-id='#{@option_line.id}']", text: @option_line.option.name).find(".button", :text => _("Change entry")).click
  @new_start_date = change_line_start_date(@option_line, 2)
end

Then /^the time range for that option line is changed$/ do
  expect(@option_line.reload.start_date).to eq @new_start_date
end

When(/^I add an option$/) do
  @option = @current_inventory_pool.options.sample
  field_value = @option.name
  find("[data-add-contract-line]").set field_value
  find(".ui-autocomplete a[title='#{field_value}']", match: :prefer_exact, text: field_value).click
  @option_line = OptionLine.find find(".line[data-line-type='option_line']", match: :prefer_exact, text: @option.name)["data-id"]
  @line_css = ".line[data-id='#{@option_line.id}']"
end

# Which implementation is better?
#When(/^I add an option$/) do
#  @option = @current_inventory_pool.options.first
#  find("input#assign-or-add-input").set @option.inventory_code
#  find("form#assign-or-add .ui-menu-item a", match: :first).click
#  find("#flash")
#  @option_line = @hand_over.user.contracts.approved.flat_map(&:lines).find{|l| l.item == @option}
#  @line_css = ".line[data-id='#{@option_line.id}']"
#end


When(/^I change the quantity right on the line$/) do
  @quantity = rand(2..9)
  within(".line[data-line-type='option_line'][data-id='#{@option_line.id}']") do
    find("input[data-line-quantity]").set @quantity
    find("input[data-line-quantity][value='#{@quantity}']")
  end
end

When(/^I decrease the quantity again$/) do
  @quantity -= 1
  step 'I change the quantity right on the line'
end

Then(/^the quantity for that option line is changed$/) do
  visit current_path
  expect(@option_line.reload.quantity).to eq @quantity
end

When(/^I change the quantity through the edit dialog$/) do
  find(".line[data-id='#{@option_line.id}'] button").click
  @quantity = @option_line.quantity > 1 ? 1 : rand(2..9)
  find("#booking-calendar-quantity").set @quantity
  step "I save the booking calendar"
  expect(find(".line[data-id='#{@option_line.id}'] input[data-line-quantity]").value.to_i).to eq @quantity
end

When /^I manually assign an inventory code to an item$/ do
  step 'I click an inventory code input field of an item line'
  step 'I select one of those'
end

Then /^the item is selected and the box is checked$/ do
  find("#flash")
  within(".line[data-id='#{@item_line.id}']") do
    find("input[data-assign-item][value='#{@selected_inventory_code}']")
    find("input[type='checkbox'][data-select-line]:checked")
    expect(@item_line.reload.item.inventory_code).to eq @selected_inventory_code
  end
  step 'the count matches the amount of selected lines'
end

When /^I try to complete a hand over that contains a model with unborrowable items$/ do
  @contract_line = nil
  @contract = @current_inventory_pool.contracts.approved.detect do |c|
    @contract_line = c.lines.where(item_id: nil).detect do |l|
      l.model.items.unborrowable.where(inventory_pool_id: @current_inventory_pool).first
    end
  end
  @model = @contract_line.model
  @customer = @contract.user
  step "I open a hand over for this customer"
  expect(has_selector?("#hand-over-view", :visible => true)).to be true
end

Wenn /^I try to assign an inventory code to this model$/ do
  @item_line_element = find(".line[data-id='#{@contract_line.id}']", :visible => true)
  @item_line_element.find("[data-assign-item]").click
end

Then /^the system suggests a list of items$/ do
  find(".ui-autocomplete .ui-menu-item", match: :first)
end

Then /^unborrowable items are highlighted$/ do
  @model.items.unborrowable.in_stock.each do |item|
    find(".ui-autocomplete .ui-menu-item a.light-red", text: item.inventory_code)
  end
end

Given /^I open the daily view$/ do
  @current_inventory_pool = @current_user.managed_inventory_pools.select{|ip| ip.contracts.submitted.exists? }.sample
  raise "contract not found" unless @current_inventory_pool
  visit manage_daily_view_path(@current_inventory_pool)
  find("#daily-view")
end

When /^I return to the daily view$/ do
  step 'I open the daily view'
end

When(/^I edit an order$/) do
  @contract = @current_inventory_pool.contracts.submitted.sample
  @user = @contract.user
  step "I edit the order"
end

When(/^I edit the order$/) do
  visit manage_edit_contract_path(@current_inventory_pool, @contract)
end

Then(/^the user appears under last visitors$/) do
  visit manage_daily_view_path @current_inventory_pool
  find("#last-visitors a", :text => @user.name)
end

When /^the chosen items contain some from a future hand over$/ do
  find("#add-start-date").set (Date.today+2.days).strftime("%d.%m.%Y")
  step 'I add an item to the hand over by providing an inventory code'
end

Then /^I see an error message$/ do
  find("#flash .error")
end

Then /^I cannot hand over the items$/ do
  expect(has_no_selector?(".hand_over .summary")).to be true
end


Given /^the customer is in multiple groups$/ do
  @customer = @current_inventory_pool.users.detect{|u| u.groups.size > 0}
  expect(@customer).not_to be_nil
end


When /^I open a hand over to this customer$/ do
  visit manage_hand_over_path(@current_inventory_pool, @customer)
  expect(has_selector?("#hand-over-view")).to be true
  step "the availability is loaded"
end


When /^I edit a line containing group partitions$/ do
  @inventory_code = @current_inventory_pool.models.detect {|m| m.partitions.size > 1}.items.in_stock.borrowable.first.inventory_code
  @model = Item.find_by_inventory_code(@inventory_code).model
  step 'I assign an item to the hand over by providing an inventory code and a date range'
  find(:xpath, "//*[contains(@class, 'line') and descendant::input[@data-assign-item and @value='#{@inventory_code}']]", match: :first).find("button[data-edit-lines]").click
end


When /^I expand the group selector$/ do
  find("#booking-calendar-partitions")
end


Then /^I see which groups the customer is a member of$/ do
  @customer_group_ids = @customer.groups.map(&:id)
  @model.partitions.each do |partition|
    next if partition.group_id.nil?
    if @customer_group_ids.include? partition.group_id
      expect(find("#booking-calendar-partitions optgroup[label='#{_("Groups of this customer")}']").has_content? partition.group.name).to be true
    end
  end
end

Then /^I see which groups the customer is not a member of$/ do
  @model.partitions.each do |partition|
    next if partition.group_id.nil?
    unless @customer_group_ids.include?(partition.group_id)
      expect(find("#booking-calendar-partitions optgroup[label='#{_("Other Groups")}']").has_content? partition.group.name).to be true
    end
  end
end


When /^I open a hand over for a customer that has things to pick up today as well as in the future$/ do
  @customer = @current_inventory_pool.users.detect{|u| u.visits.hand_over.size > 1}
  step "I open a hand over to this customer"
end

When /^I scan something \(assign it using its inventory code\) and it is already assigned to a future contract$/ do
  begin
    @model = @customer.get_approved_contract(@current_inventory_pool).models.sample
    @item = @model.items.borrowable.in_stock.where(inventory_pool: @current_inventory_pool).sample
  end while @item.nil?
  find("[data-add-contract-line]").set @item.inventory_code
  find("[data-add-contract-line] + .addon").click
  @assigned_line = find("[data-assign-item][disabled][value='#{@item.inventory_code}']")
end


Then /^it is assigned \(whether it is selected or not\)$/ do
  @assigned_line.find(:xpath, "./../../..").find("input[type='checkbox'][data-select-line]:checked")
end

When /^it doesn't exist in any future contracts$/ do
  @model_not_in_contract = (@current_inventory_pool.items.borrowable.in_stock.map(&:model).uniq -
                              @customer.get_approved_contract(@current_inventory_pool).models).sample
  @item = @model_not_in_contract.items.borrowable.in_stock.sample
  find("#add-start-date").set (Date.today+7.days).strftime("%d.%m.%Y")
  find("#add-end-date").set (Date.today+8.days).strftime("%d.%m.%Y")
  find("[data-add-contract-line]").set @item.inventory_code
  @amount_lines_before = all(".line").size
  find("[data-add-contract-line] + .addon").click
end

Then /^it is added for the selected time span$/ do
  find("#flash")
  find(".line", match: :first, text: @model)
  expect(@amount_lines_before).to be < all(".line").size
end


Given /^I am doing a hand over$/ do
  @event = "hand_over"
  step 'I open a hand over'
end

When(/^I click on "(.*?)"$/) do |arg1|
  case arg1
    when "Continue this order"
      find(".button", text: _("Continue this order")).click
    when "Continue with available models only"
      find(".dropdown-item", text: _("Continue with available models only")).click
    when "Delegations"
      find(".dropdown-item", text: _("Delegations")).click
    else
      step %Q(I press "#{arg1}")
  end
end

When /^I open a hand over for this customer$/ do
  visit manage_hand_over_path(@current_inventory_pool, @customer)
  expect(has_selector?("#hand-over-view")).to be true
  step "the availability is loaded"
end

When(/^I fill in all the necessary information in hand over dialog$/) do
  if has_css?("#contact-person")
    contact_field = find("#contact-person").all("input#user-id").first
    contact_field.click
    find(".ui-menu-item", match: :first).click
  end
  fill_in "purpose", with: Faker::Lorem.sentence
end

Then(/^there are inventory codes for item and license in the contract$/) do
  # Sleeps are not sexy, but for some reason on busy systems, the contract
  # window opens very slowly and then this test is reliably red.
  if page.driver.browser.window_handles.count < 2
    sleep 2
  end
  page.driver.browser.switch_to.window(page.driver.browser.window_handles.last)
  @inventory_codes.each {|inv_code|
    expect(has_content?(inv_code)).to be true
  }
end

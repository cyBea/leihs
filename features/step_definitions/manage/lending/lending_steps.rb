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
  step "ich eine Aushändigung an diesen Kunden mache"
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

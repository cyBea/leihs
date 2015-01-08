# encoding: utf-8

#Dann(/^wird festgehalten, dass ich diesen Gegenstand zurückgenommen habe$/) do
Then(/^a note is made that it was me who took back the item$/) do
  expect(@contract_lines_to_take_back.map(&:returned_to_user_id).uniq.first).to eq @current_user.id
  step 'sieht man bei den betroffenen Linien die rücknehmende Person im Format "V. Nachname"'
end

#Angenommen(/^es existiert ein Benutzer mit mindestens 2 Rückgaben an 2 verschiedenen Tagen$/) do
Given(/^there is a user with at least 2 take back s on 2 different days$/) do
  @user = User.find {|u| u.visits.take_back.select{|v| v.inventory_pool == @current_inventory_pool}.count >= 2}
end

#Wenn(/^man die Rücknahmenansicht für den Benutzer öffnet|ich öffne die Rücknahmeansicht für diesen Benutzer$/) do
When(/^I open a take back for this user$/) do
  visit manage_take_back_path(@current_inventory_pool, @user)
end

#Dann(/^sind die Rücknahmen aufsteigend nach Datum sortiert$/) do
Then(/^the take backs are ordered by date in ascending order$/) do
  expect(has_selector?(".line[data-line-type]")).to be true

  take_backs = @user.visits.take_back.select{|v| v.inventory_pool == @current_inventory_pool}.sort {|d1, d2| d1.date <=> d2.date }
  lines = take_backs.flat_map &:lines

  all(".line[data-line-type='item_line']").each_with_index do |line, i|
    ar_line = lines[i]

    if ar_line.is_a? ItemLine
      line.text.instance_eval do
        include? ar_line.item.inventory_code
        include? ar_line.item.model.name
      end
    elsif ar_line.is_a? OptionLine
      line.text.include? ar_line.option.name
    end

  end

end

When(/^I open a take back for a suspended user$/) do
  step 'I open a take back'
  ensure_suspended_user(@customer, @current_inventory_pool)
  visit manage_take_back_path(@current_inventory_pool, @customer)
end

#Angenommen(/^ich befinde mich in einer Rücknahme$/) do
Given(/^I am taking something back$/) do
  @take_back = @current_inventory_pool.visits.take_back.select{|v| v.lines.any? {|l| l.is_a? ItemLine}}.sample
  @user = @take_back.user
  step "man die Rücknahmenansicht für den Benutzer öffnet"
end

#Dann(/^ich erhalte eine Meldung$/) do
#Dann(/^ich erhalte eine Bestätitungsmeldung$/) do
Then(/^I receive a notification$/) do
  find("#flash .notice")
end


#Dann(/^ich erhalte eine Erfolgsmeldung$/) do
Then(/^I receive a notification of success$/) do
  find("#flash .success")
end

#Wenn(/^ich einen Gegenstand über das Zuweisenfeld zurücknehme$/) do
When(/^I take back an item using the assignment field$/) do
  @contract_line = @take_back.lines.select{|l| l.is_a? ItemLine}.sample
  within "form#assign" do
    find("input#assign-input").set @contract_line.item.inventory_code
    find("button .icon-ok-sign").click
  end
  @line_css = ".line[data-id='#{@contract_line.id}']"
end

#Angenommen(/^ich befinde mich in einer Rücknahme mit mindestens einem verspäteten Gegenstand$/) do
Given(/^I am taking back at least one overdue item$/) do
  @take_back = @current_inventory_pool.visits.take_back.find {|v| v.lines.any? {|l| l.end_date.past? }}
  @user = @take_back.user
  step "man die Rücknahmenansicht für den Benutzer öffnet"
end

#Wenn(/^ich einen verspäteten Gegenstand über das Zuweisenfeld zurücknehme$/) do
When(/^I take back an overdue item using the assignment field$/) do
  @contract_line = @take_back.lines.find{|l| l.end_date.past?}
  within "form#assign" do
    find("input#assign-input").set @contract_line.item.inventory_code
    find("button .icon-ok-sign").click
  end
  @line_css = ".line[data-id='#{@contract_line.id}']"
end

#Dann(/^das Problemfeld für die Linie wird angezeigt$/) do
Then(/^the problem indicator for the line is displayed$/) do
  expect(has_selector?("#{@line_css} .line-info.red")).to be true
  expect(has_selector?("#{@line_css} .red.tooltip")).to be true
end

#Angenommen(/^ich befinde mich in einer Rücknahme mit mindestens zwei gleichen Optionen$/) do
Given(/^I am on a take back with at least two of the same options$/) do
  @take_back = @current_inventory_pool.visits.take_back.find {|v| v.lines.any? {|l| l.quantity >= 2 }}
  @user = @take_back.user
  step "man die Rücknahmenansicht für den Benutzer öffnet"
end

#Wenn(/^ich eine Option über das Zuweisenfeld zurücknehme$/) do
When(/^I take back an option using the assignment field$/) do
  @contract_line = @take_back.lines.find {|l| l.quantity >= 2 }
  within "form#assign" do
    find("input#assign-input").set @contract_line.item.inventory_code
    find("button .icon-ok-sign").click
  end
  @line_css = ".line[data-id='#{@contract_line.id}']"
end

#Dann(/^die Zeile ist nicht grün markiert$/) do
Then(/^the line is not highlighted in green$/) do
  expect(find(@line_css).native.attribute("class")).not_to include "green"
end

#Wenn(/^ich alle Optionen der gleichen Zeile zurücknehme$/) do
When(/^I take back all options of the same line$/) do
  (@contract_line.quantity - find(@line_css).find("input[data-quantity-returned]").value.to_i).times do
    within "form#assign" do
      find("input#assign-input").set @contract_line.item.inventory_code
      find("button .icon-ok-sign").click
    end
  end
end

Angenommen(/^es existiert ein Benutzer mit einer zurückzugebender Option in zwei verschiedenen Zeitfenstern$/) do
  @user = User.find do |u|
    option_lines = u.visits.take_back.select{|v| v.inventory_pool == @current_inventory_pool}.flat_map(&:lines).select {|l| l.is_a? OptionLine}
    option_lines.uniq(&:option).size < option_lines.size
  end
  expect(@user).not_to be_nil
end

Wenn(/^ich diese Option zurücknehme$/) do
  @option = Option.find {|o| o.option_lines.select{|l| l.contract.status == :signed and l.contract.user == @user}.count >= 2}
  within "form#assign" do
    find("input#assign-input").set @option.inventory_code
    find("button .icon-ok-sign").click
  end
end

Dann(/^wird die Option dem ersten Zeitfenster hinzugefügt$/) do
  @option_lines = @option.option_lines.select{|l| l.contract.status == :signed and l.contract.user == @user}
  @option_line = @option_lines.sort{|a, b| a.end_date <=> b.end_date}.first
  expect(find("[data-selected-lines-container]", match: :first, text: @option.inventory_code).find(".line[data-id='#{@option_line.id}'] [data-quantity-returned]").value.to_i).to be > 0
end

Wenn(/^ich dieselbe Option nochmals hinzufüge$/) do
  within "form#assign" do
    find("input#assign-input").set @option.inventory_code
    find("button .icon-ok-sign").click
  end
end

Wenn(/^im ersten Zeitfenster bereits die maximale Anzahl dieser Option erreicht ist$/) do
  until find("[data-selected-lines-container]", match: :first, text: @option.inventory_code).find(".line[data-id='#{@option_line.id}'] [data-quantity-returned]").value.to_i == @option_line.quantity
    within "form#assign" do
      find("input#assign-input").set @option.inventory_code
      find("button .icon-ok-sign").click
    end
  end
end

Dann(/^wird die Option dem zweiten Zeitfenster hinzugefügt$/) do
  @option_line = @option_lines.sort{|a, b| a.end_date <=> b.end_date}.second
  expect(all("[data-selected-lines-container]", text: @option.inventory_code).to_a.second.find(".line[data-id='#{@option_line.id}'] [data-quantity-returned]").value.to_i).to be > 0
end

Given(/^I open a take back with at least one item and one option$/) do
  @take_back = @current_inventory_pool.visits.take_back.find {|v| v.lines.any? {|l| l.is_a? OptionLine} and v.lines.any? {|l| l.is_a? ItemLine}}
  expect(@take_back).not_to be_nil
  visit manage_take_back_path(@current_inventory_pool, @take_back.user)
end

When(/^I set a quantity of (\d+) for the option line$/) do |quantity|
  option_line = find("[data-line-type='option_line']", match: :first)
  @line_id = option_line["data-id"]
  option_line.find("input[data-quantity-returned]").set (@quantity = quantity)
end

When(/^I set "(.*?)" to "(.*?)"$/) do |arg1, arg2|
  select _(arg2), from: _(arg1)
end

Then(/^the option line has still the same quantity$/) do
  expect(find(".line[data-id='#{@line_id}'] [data-quantity-returned]").value).to eq @quantity
end

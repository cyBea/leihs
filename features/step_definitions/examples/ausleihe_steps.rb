# -*- encoding : utf-8 -*-


Wenn /^ich öffne eine Bestellung von "(.*?)"$/ do |arg1|
  find("[data-collapsed-toggle='#open-orders']").click unless all("[data-collapsed-toggle='#open-orders']").empty?
  @contract = @current_inventory_pool.contracts.find find("#daily-view #open-orders .line", match: :prefer_exact, :text => arg1)["data-id"]
  @user = @contract.user
  within("#daily-view #open-orders .line", match: :prefer_exact, :text => arg1) do
    find(".line-actions .multibutton .dropdown-holder").click
    find(".dropdown-item", :text => _("Edit")).click
  end
  find("h1", text: _("Edit %s") % _("Order"))
  find("h2", text: arg1)
end

Wenn /^ich öffne eine Bestellung$/ do
  step 'ich öffne eine Bestellung von ""'
end

Dann /^sehe ich die letzten Besucher$/ do
  find("#daily-view strong", :text => _("Last Visitors:"))
end

Dann /^ich sehe "(.*?)" als letzten Besucher$/ do |arg1|
  find("#daily-view #last-visitors", :text => arg1)
end

Wenn /^ich auf "(.*?)" klicke$/ do |arg1|
  find("#daily-view #last-visitors a", :text => arg1).click
end

Dann /^wird mir ich ein Suchresultat nach "(.*?)" angezeigt/ do |arg1|
  find("#search-overview h1", text: _("Search Results for \"%s\"") % arg1)
end

Wenn /^etwas in das Feld "(.*?)" schreibe$/ do |field_label|
  if field_label == "Inventarcode/Name"
    find("[data-add-contract-line]").set " "
  end
end

Dann /^werden mir diejenigen Gegenstände vorgeschlagen, die in den dargestellten Rücknahmen vorkommen$/ do
  @customer.visits.where(inventory_pool_id: @current_inventory_pool).take_back.first.lines.all do |line|
    expect(find(".ui-autocomplete", match: :first).has_content? line.item.inventory_code).to be true
  end
end

Wenn /^ich etwas zuweise, das nicht in den Rücknahmen vorkommt$/ do
  find("[data-add-contract-line]").set "_for_sure_this_is_not_part_of_the_take_back"
  find("[data-add-contract-line] + .addon").click
end


Wenn /^ich eine Rücknahme mache die Optionen beinhaltet$/ do
  @customer = @current_inventory_pool.users.all.select {|x| x.contracts.signed.size > 0 and !x.contracts.signed.detect{|c| c.options.size > 0}.nil? }.first
  visit manage_take_back_path(@current_inventory_pool, @customer)
  expect(has_selector?("#take-back-view")).to be true
end

Wenn /^die Anzahl einer zurückzugebenden Option manuell ändere$/ do
  @option_line = find(".line[data-line-type='option_line']", match: :first)
  @option_line.find("[data-quantity-returned]").set 1
end

Dann /^wird die Option ausgewählt und der Haken gesetzt$/ do
  @option_line.find("input[data-select-line]:checked")
  step 'the count matches the amount of selected lines'
end



Wenn /^die Gruppenauswahl aufklappe$/ do
  find("#booking-calendar-partitions")
end

Dann /^erkenne ich, in welchen Gruppen der Kunde ist$/ do
  @customer_group_ids = @customer.groups.map(&:id)
  @model.partitions.each do |partition|
    next if partition.group_id.nil?
    if @customer_group_ids.include? partition.group_id
      expect(find("#booking-calendar-partitions optgroup[label='#{_("Groups of this customer")}']").has_content? partition.group.name).to be true
    end
  end
end

Dann /^dann erkennen ich, in welchen Gruppen der Kunde nicht ist$/ do
  @model.partitions.each do |partition|
    next if partition.group_id.nil?
    unless @customer_group_ids.include?(partition.group_id)
      expect(find("#booking-calendar-partitions optgroup[label='#{_("Other Groups")}']").has_content? partition.group.name).to be true
    end
  end
end



Dann /^habe ich für jeden Gegenstand die Möglichkeit, eine Inspektion auszulösen$/ do
  find(".line[data-line-type='item_line']", match: :first)
  line_ids = all(".line[data-line-type='item_line']").map {|l| l["data-id"]}
  line_ids.each do |id|
    within find(".line[data-id='#{id}'] .multibutton") do
      find(".dropdown-toggle").click
      find(".dropdown-holder .dropdown-item", text: _("Inspect"))
    end
  end
end

Wenn /^ich bei einem Gegenstand eine Inspektion durchführen$/ do
  find(".line[data-line-type='item_line']", match: :first)
  within all(".line[data-line-type='item_line']").to_a.sample.find(".multibutton") do
    @item = ContractLine.find(JSON.parse(find("[data-ids]")["data-ids"]).first).item
    find(".dropdown-toggle").click
    find(".dropdown-holder .dropdown-item", text: _("Inspect")).click
  end
  find(".modal")
end

Dann /^die Inspektion erlaubt es, den Status von "(.*?)" auf "(.*?)" oder "(.*?)" zu setzen$/ do |arg1, arg2, arg3|
  within(".col1of3", :text => arg1) do
    find("option", :text => arg2)
    find("option", :text => arg3)
  end
end

Wenn /^ich Werte der Inspektion ändere$/ do
  @is_borrowable = true
  find("select[name='is_borrowable'] option[value='true']").select_option
  @is_broken = true
  find("select[name='is_broken'] option[value='true']").select_option
  @is_incomplete = true
  find("select[name='is_incomplete'] option[value='true']").select_option
end

Dann /^wenn ich die Inspektion speichere$/ do
  find(".modal button[type='submit']").click
end

Dann /^wird der Gegenstand mit den aktuell gesetzten Status gespeichert$/ do
  visit current_path
  @item.reload
  expect(@item.is_borrowable).to eq @is_borrowable
  expect(@item.is_broken).to eq @is_broken
  expect(@item.is_incomplete).to eq @is_incomplete
end

Angenommen /^man fährt über die Anzahl von Gegenständen in einer Zeile$/ do
  find(".line [data-type='lines-cell']", match: :first).hover
  @lines = all(".line [data-type='lines-cell']")
end

Dann /^werden alle diese Gegenstände aufgelistet$/ do
  all("button[data-collapsed-toggle]").each(&:click)
  hover_for_tooltip @lines.to_a.sample
end

Dann /^man sieht pro Modell eine Zeile$/ do
  step 'werden alle diese Gegenstände aufgelistet'
  within(".tooltipster-default", match: :first, :visible => true) do
    find(".exclude-last-child", match: :first)
    all(".exclude-last-child").each do |div|
      model_names = div.all(".row .col7of8:nth-child(2) strong", text: /.+/).map &:text
      expect(model_names.size).to eq model_names.uniq.size
    end
  end
end

Dann /^man sieht auf jeder Zeile die Summe der Gegenstände des jeweiligen Modells$/ do
  step 'werden alle diese Gegenstände aufgelistet'
  within(".tooltipster-default", match: :first, :visible => true) do
    find(".row .col1of8:nth-child(1)", match: :first)
    quantities = all(".row .col1of8:nth-child(1)", text: /.+/).map{|x| x.text.to_i}
    expect(quantities.sum).to be >= quantities.size
  end
end

Angenommen /^(?:I search|ich suche) '(.*)'$/ do |arg1|
  @search_term = arg1
  find("#search_term").set(@search_term)
  find("#search_term").native.send_key :enter
end

Dann /^erhalte ich Suchresultate in den Kategorien:$/ do |table|
  table.hashes.each do |t|
    case t[:category]
      when "Benutzer"
        find("#users .list-of-lines .line", match: :first)
      when "Modelle"
        find("#models .list-of-lines .line", match: :first)
      when "Gegenstände"
        find("#items .list-of-lines .line", match: :first)
      when "Verträge"
        find("#contracts .list-of-lines .line", match: :first)
      when "Bestellungen"
        find("#orders .list-of-lines .line", match: :first)
      when "Optionen"
        find("#options .list-of-lines .line", match: :first)
    end
  end
end

Dann /^ich sehe aus jeder Kategorie maximal die (\d+) ersten Resultate$/ do |amount|
  amount = (amount.to_i+2)
  expect(all(".user .list .line:not(.toggle)", :visible => true).size).to be <= amount
  expect(all(".model .list .line:not(.toggle)", :visible => true).size).to be <= amount
  expect(all(".item .list .line:not(.toggle)", :visible => true).size).to be <= amount
  expect(all(".contract .list .line:not(.toggle)", :visible => true).size).to be <= amount
  expect(all(".order .list .line:not(.toggle)", :visible => true).size).to be <= amount
end

Wenn /^eine Kategorie mehr als (\d+) Resultate bringt$/ do |amount|
  @lists = []
  all(".list").each do |list|
    @lists.push(list) unless list.all(".hidden .line:not(.show-all)").empty?
  end
end

Dann /^kann ich wählen, ob ich aus einer Kategorie mehr Resultate sehen will$/ do
  @lists.each do |list|
    list.find(".toggle", match: :first)
  end
end

Wenn /^ich mehr Resultate wähle$/ do
  @lists.each do |list|
    list.find(".toggle .text", match: :first).click
  end
end

Dann /^sehe ich die ersten (\d+) Resultate$/ do |amount|
  amount = amount.to_i + 2
  @lists.each do |list|
    if list.all(".show-all").size > 0
      expect(list.all(".line").size).to eq amount
    end
  end
end

Wenn /^die Kategorie mehr als (\d+) Resultate bringt$/ do |amount|
  amount = amount.to_i
  @list_with_more_matches = all(".inlinetabs .badge").map do |badge|
    badge.first(:xpath, "../../..").find(".list", match: :first) if badge.text.to_i > amount
  end.compact
end

Dann /^kann ich wählen, ob ich alle Resultate sehen will$/ do
  @links_of_more_results = @list_with_more_matches.map do |list|
    list.find(".line.show-all a", visible: false)[:href]
  end
end

Wenn /^ich alle Resultate wähle erhalte ich eine separate Liste aller Resultate dieser Kategorie$/ do
  @links_of_more_results.each do |link|
    visit link
    find("#search_results.focused")
  end
end

#Angenommen /^ich sehe Probleme auf einer Zeile, die durch die Verfügbarkeit bedingt sind$/ do
#  step 'I open a hand over'
#  step 'I add so many lines that I break the maximal quantity of a model'
#  @line_el = find(".line.error", match: :first)
#  page.evaluate_script %Q{ $(".line.error:first-child").tmplItem().data.id; }
#  @line = ContractLine.find page.evaluate_script %Q{ $(".line.error:first-child").tmplItem().data.id; }
#end

Angenommen /^ich fahre über das Problem$/ do
  hover_for_tooltip find(".line .problems", match: first)
end

Dann /^wird automatisch der Druck\-Dialog geöffnet$/ do
  step 'I select an item line and assign an inventory code'
  step 'I click hand over'
  find(".modal .button", match: :first, :text => _("Hand Over")).click
  check_printed_contract(page.driver.browser.window_handles, @current_inventory_pool, @item_line.contract)
end

def check_printed_contract(window_handles, ip = nil, contract = nil)
  while (page.driver.browser.window_handles - window_handles).empty? do end
  new_window = page.windows.find {|window|
    window if window.handle == (page.driver.browser.window_handles - window_handles).first
  }
  within_window new_window do
    find(".contract")
    expect(current_path).to eq manage_contract_path(ip, contract) if ip and contract
    expect(page.evaluate_script("window.printed")).to eq 1
  end
end


Dann(/^erscheint der Benutzer unter den letzten Besuchern$/) do
  visit manage_daily_view_path @current_inventory_pool
  find("#last-visitors a", :text => @user.name)
end

When(/^ist das Start- und Enddatum gemäss dem ersten Zeitfenster der Aushändigung gesetzt$/) do
  first_dates = find("#hand-over-view #lines [data-selected-lines-container]", match: :first).find(".row .col1of2 p.paragraph-s", match: :first).text
  start_date, end_date = first_dates.split('-').map{|x| Date.parse x}
  expect(Date.parse(find("input#add-start-date").value)).to eq [start_date, Date.today].max
  expect(Date.parse(find("input#add-end-date").value)).to eq [end_date, Date.today].max
end

Dann(/^ich sehe den Benutzer der vorher geöffneten Bestellung als letzten Besucher$/) do
  find("#daily-view #last-visitors", :text => @user.name)
end

Wenn(/^ich auf den Namen des letzten Benutzers klicke$/) do
  find("#daily-view #last-visitors a", :text => @user.name).click
end

Dann(/^wird mir ich ein Suchresultat nach dem Namen des letzten Benutzers angezeigt$/) do
  find("#search-overview h1", text: _("Search Results for \"%s\"") % @user.name)
end


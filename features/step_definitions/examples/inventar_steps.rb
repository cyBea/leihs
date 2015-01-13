# encoding: utf-8

Angenommen /^man öffnet die Liste des Inventars$/ do
  #really needed?# @current_inventory_pool = @current_user.managed_inventory_pools.select { |ip| ip.models.exists? and ip.options.exists? }.sample
  step "I open the inventory"
  find("#inventory")
end

Dann /^sieht man Modelle$/ do
  find("#inventory .line[data-type='model']", match: :first)
end

Dann /^man sieht Software$/ do
  step %Q(I search for "%s") % ""
  step "I scroll to the bottom of the page"
  find("#inventory .line[data-type='software']", match: :first)
end

Dann /^man sieht Optionen$/ do
  step "I scroll to the bottom of the page"
  find("#inventory .line[data-type='option']", match: :first)
end

Dann /^man sieht Pakete$/ do
  package = @current_inventory_pool.items.packages.sample
  step 'I search for "%s"' % package.inventory_code
  find(".line[data-is_package='true']", match: :prefer_exact, text: package.name)
end

########################################################################

def check_existing_inventory_codes(items)
  inventory = find "#inventory"
  # clicking on all togglers via javascript is significantly faster than doing it with capybara in this case
  page.execute_script %Q( $(".button[data-type='inventory-expander']").click() )
  inventory_text = inventory.text
  items.each do |i|
    expect(inventory_text).to match /#{i.inventory_code}/
  end
end

def check_amount_of_lines(amount)
  within "#inventory" do
    expect(all(".line").count).to eq amount
  end
end

#Dann /^kann man auf ein der folgenden Tabs klicken und dabei die entsprechende Inventargruppe sehen:$/ do |table|
Then(/^I can click one of the following tabs to filter inventory by:$/) do |table|
  items = Item.by_owner_or_responsible(@current_inventory_pool)
  options = @current_inventory_pool.options
  section_tabs = find("#list-tabs")
  section_tabs.find(".active")
  retired_unretired_option = find(:select, "retired").first("option")

  table.hashes.each do |row|
    tab = nil
    case row["Choice"]
      when "All"
        tab = section_tabs.find("a", match: :first)
        expect(tab.text).to eq _("All")
        inventory = items + options
        amount = Model.owned_or_responsible_by_inventory_pool(@current_inventory_pool).count + Model.unused_for_inventory_pool(@current_inventory_pool).count + options.count
        retired_unretired_option.select_option
      when "Models"
        tab = section_tabs.find("a[data-type='item']", match: :first)
        expect(tab.text).to eq _("Models")
        inventory = items.items
        models = Model.where(type: :Model)
        amount = models.owned_or_responsible_by_inventory_pool(@current_inventory_pool).count + models.unused_for_inventory_pool(@current_inventory_pool).count
        retired_unretired_option.select_option
      when "Options"
        tab = section_tabs.find("a[data-type='option']", match: :first)
        expect(tab.text).to eq _("Options")
        inventory = options
        amount = inventory.count
      when "Software"
        tab = section_tabs.find("a[data-type='license']")
        expect(tab.text).to eq _("Software")
        inventory = items.licenses
        models = Model.where(type: :Software)
        amount = models.owned_or_responsible_by_inventory_pool(@current_inventory_pool).count + models.unused_for_inventory_pool(@current_inventory_pool).count
        retired_unretired_option.select_option
    end

    tab.click
    expect(tab.reload[:class].split.include?("active")).to be true
    step "I fetch all pages of the list"

    check_amount_of_lines(amount)

    check_existing_inventory_codes(inventory)
  end
end

########################################################################

Dann /^hat man folgende Filtermöglichkeiten$/ do |table|
  items = Item.by_owner_or_responsible(@current_inventory_pool)

  section_filter = find("#list-filters")

  table.hashes.each do |row|
    section_filter.all("input[type='checkbox']").select { |x| x.checked? }.map(&:click)
    expect(section_filter.all("input[type='checkbox']").select { |x| x.checked? }.empty?).to be true
    case row["filtermöglichkeit"]
      when "An Lager"
        section_filter.find("input#in_stock[type='checkbox']").click
        check_existing_inventory_codes(items.in_stock)
      when "Besitzer bin ich"
        section_filter.find("input#owned[type='checkbox']").click
        check_existing_inventory_codes(items.where(:owner_id => @current_inventory_pool))
      when "Defekt"
        section_filter.find("input#broken[type='checkbox']").click
        check_existing_inventory_codes(items.broken)
      when "Unvollständig"
        section_filter.find("input#incomplete[type='checkbox']").click
        check_existing_inventory_codes(items.incomplete)
      when "Verantwortliche Abteilung"
        o = section_filter.find("select#responsibles").all("option[value]").to_a.sample
        o.select_option
        check_existing_inventory_codes(items.where(inventory_pool_id: o[:value]))
        o = section_filter.find("select#responsibles").all("option").first
        o.select_option
    end
  end
end

Dann /^die Filter können kombiniert werden$/ do
  section_filter = find("#list-filters")
  section_filter.all("input[type='checkbox']").select { |x| not x.checked? }.map(&:click)
  expect(section_filter.all("input[type='checkbox']").select { |x| x.checked? }.size).to be > 1
end

########################################################################

#Dann /^ist die Auswahl "(.*?)" aktiviert$/ do |arg1|
Then(/^the tab "(.*?)" is active$/) do |arg1|
  case arg1
    when "Active Inventory"
      find("#list-tabs a.active", text: _("Active Inventory"))
    when "All"
      find("#list-tabs a.active", text: _("All"))
  end
end

Dann /^es sind keine Filtermöglichkeiten aktiviert$/ do
  find("#list-filters").all("input[type='checkbox']").each do |filter|
    expect(filter.checked?).to be false
  end
end

########################################################################

#Wenn /^man eine Modell\-Zeile eines Modells, das weder ein Paket-Modell oder ein Bestandteil eines Paket-Modells ist, sieht$/ do
When(/^I see a model line for a model that is neither a package model nor part of a package model$/) do
  expect(has_selector?("#inventory > .line[data-type='model']")).to be true
  within "#inventory" do
    all(".line[data-type='model']").each do |model_line|
      @model = Model.find_by_name(model_line.find(".col2of5 strong").text)
      next if @model.is_package? or @model.items.all? { |i| i.parent }
      @model_line = model_line and break
    end
  end
end

#Wenn /^man eine Modell\-Zeile sieht$/ do
When /^I see a model line$/ do
  @model_line = find("#inventory .line[data-type='model']", match: :first)
  @model = Model.find_by_name(@model_line.find(".col2of5 strong").text)
end

#Dann /^enthält die Modell\-Zeile folgende Informationen:$/ do |table|
Then /^the model line contains the following information:$/ do |table|
  table.hashes.each do |row|
    case row["information"]
      when "Image"
        @model_line.find "img[src*='image_thumb']"
      when "Model name"
        @model_line.find ".col2of5 strong"
      when "Number available (now)"
        @model_line.find ".col1of5:nth-child(3)", :text => /#{@model.borrowable_items.in_stock.where(inventory_pool_id: @current_inventory_pool).count}.*?\//
      when "Number available (total)"
        @model_line.find ".col1of5:nth-child(3)", :text => /\/.*?#{@model.borrowable_items.where(inventory_pool_id: @current_inventory_pool).count}/
    end
  end
end

########################################################################

Wenn /^man eine Gegenstands\-Zeile sieht$/ do
  all(".tab").detect { |x| x["data-tab"] == '{"borrowable":true}' }.click
  find(".filter input#in_stock").click unless find(".filter input#in_stock").checked?
end

#Dann /^enthält die (?:Gegenstands|Software\-Lizenz)\-Zeile folgende Informationen:$/ do |table|
Then /^the (?:item|software license) line contains the following information:$/ do |table|
  table.hashes.each do |row|
    case row["information"]
      when "Inventory code"
        step 'the item line contains the inventory code'
      when "Location"
        step 'the item line contains the location'
      when "Code of the building"
        step 'the item line contains the code of the building'
      when "Room"
        step 'the item line contains the room'
      when "Shelf"
        step 'the item line contains the shelf'
      when "Current borrower"
        step 'the item line contains the name of the current borrower'
      when "End date of contract"
        step 'the item line contains the end date of the current contract'
      when "Responsible department"
        step 'the item line contains the responsible department'
      when "Operating system"
        step %Q(the license line contains the 'operating system' information)
      when "License type"
        step %Q(the license line contains the 'license type' information)
      when "Quantity"
        step %Q(the license line contains the 'quantity' information)
      else
        raise 'step not found'
    end
  end
end

#Dann /^enthält die Gegenstands\-Zeile den Inventarcode$/ do
Then /^the item line contains the inventory code$/ do
  expect((@item_line.is_a?(String) ? find(@item_line, match: :first) : @item_line).has_content?(@item.inventory_code)).to be true
end

#Dann /^enthält die Gegenstands\-Zeile den Ort des Gegenstands$/ do
Then /^the item line contains the location of the item$/ do
  expect((@item_line.is_a?(String) ? find(@item_line, match: :first) : @item_line).has_content?(@item.location.to_s)).to be true
end

#Dann /^enthält die Gegenstands\-Zeile die Gebäudeabkürzung$/ do
Then(/^the item line contains the code of the building$/) do
  expect((@item_line.is_a?(String) ? find(@item_line, match: :first) : @item_line).has_content?(@item.location.building.code)).to be true
end

#Dann /^enthält die Gegenstands\-Zeile den Raum$/ do
Then(/^the item line contains the room$/) do
  expect((@item_line.is_a?(String) ? find(@item_line, match: :first) : @item_line).has_content?(@item.location.room)).to be true
end

#Dann /^enthält die Gegenstands\-Zeile das Gestell$/ do
Then(/^the item line contains the shelf$/) do
  expect((@item_line.is_a?(String) ? find(@item_line, match: :first) : @item_line).has_content?(@item.location.shelf)).to be true
end

#Dann /^enthält die Gegenstands\-Zeile den aktuell Ausleihenden$/ do
Then(/^the item line contains the name of the current borrower$/) do
  expect((@item_line.is_a?(String) ? find(@item_line, match: :first) : @item_line).has_content?(@item.current_borrower.to_s)).to be true
end

#Dann /^enthält die Gegenstands\-Zeile das Enddatum der Ausleihe$/ do
Then(/^the item line contains the end date of the current contract$/) do
  expect((@item_line.is_a?(String) ? find(@item_line, match: :first) : @item_line).has_content?(@item.current_return_date.year)).to be true
  expect((@item_line.is_a?(String) ? find(@item_line, match: :first) : @item_line).has_content?(@item.current_return_date.month)).to be true
  expect((@item_line.is_a?(String) ? find(@item_line, match: :first) : @item_line).has_content?(@item.current_return_date.day)).to be true
end

#Dann /^enthält die Gegenstands\-Zeile die Verantwortliche Abteilung$/ do
Then(/^the item line contains the responsible department$/) do
  expect((@item_line.is_a?(String) ? find(@item_line, match: :first) : @item_line).has_content?(@item.inventory_pool.to_s)).to be true
  #step 'ich nach "%s" suche' % " "
end

# not needed -> is a problem for capybara: "element not found in cache" error
#def get_item_by_inventory_code(item_line)
#Item.find_by_inventory_code item_line.find(".col2of5.text-align-left:nth-child(2) .row:nth-child(1)").text
#end

def fetch_item_line_and_item
  r1 = ".group-of-lines .line[data-type='item']"
  r2 = within(r1, match: :first) do
    inventory_code = find(".col2of5.text-align-left:nth-child(2) .row:nth-child(1)").text
    Item.find_by_inventory_code(inventory_code)
  end
  [r1, r2]
end

#Wenn /^der Gegenstand an Lager ist und meine Abteilung für den Gegenstand verantwortlich ist$/ do
When /^the item is in stock and my department is responsible for it$/ do
  find("select[name='responsible_inventory_pool_id'] option[value='#{@current_inventory_pool.id}']").select_option
  find("input[name='in_stock']").click unless find("input[name='in_stock']").checked?
  find(".button[data-type='inventory-expander'] i.arrow.right", match: :first).click
  @item_line, @item = fetch_item_line_and_item
end

#Wenn /^der Gegenstand nicht an Lager ist und eine andere Abteilung für den Gegenstand verantwortlich ist$/ do
When /^the item is not in stock and another department is responsible for it$/ do
  all("select[name='responsible_inventory_pool_id'] option:not([selected])").detect{|o| o.value != @current_inventory_pool.id.to_s and o.value != ""}.select_option
  find("input[name='in_stock']").click if find("input[name='in_stock']").checked?
  item = @current_inventory_pool.own_items.items.detect{|i| not i.inventory_pool_id.nil? and i.inventory_pool != @current_inventory_pool and not i.in_stock?}
  step 'I search for "%s"' % item.inventory_code
  within ".line[data-type='model'][data-id='#{item.model.id}']" do
    if has_selector?(".button[data-type='inventory-expander'] i.arrow.right")
      find(".button[data-type='inventory-expander']").click
    end
  end
  @item_line, @item = fetch_item_line_and_item
end

#Wenn /^meine Abteilung Besitzer des Gegenstands ist die Verantwortung aber auf eine andere Abteilung abgetreten hat$/ do
When /^my department is the owner but has given responsibility for the item to another department$/ do
  all("select[name='responsible_inventory_pool_id'] option:not([selected])").detect{|o| o.value != @current_inventory_pool.id.to_s and o.value != ""}.select_option
  find(".line[data-type='model'] .button[data-type='inventory-expander'] i.arrow.right", match: :first).click
  @item_line = ".group-of-lines .line[data-type='item']"
  @item = Item.find_by_inventory_code(find(@item_line, match: :first).find(".col2of5.text-align-left:nth-child(2) .row:nth-child(1)").text)
end

#Dann /^enthält die Options\-Zeile folgende Informationen$/ do |table|
Then(/^the option line contains the following information:$/) do |table|
  @option_line = find(".line[data-type='option']", match: :first)
  @option = Option.find_by_inventory_code @option_line.find(".col1of5:nth-child(1)").text
  table.hashes.each do |row|
    case row["information"]
      when "Barcode"
        expect(@option_line.has_content? @option.inventory_code).to be true
      when "Name"
        expect(@option_line.has_content? @option.name).to be true
      when "Price"
        expect((@option.price * 100).to_i.to_s).to eq @option_line.find(".col1of5:nth-child(3)").text.gsub(/\D/, "")
      else
        raise "Can't find information called '#{row['information']}'"
    end
  end
end

#Dann /^kann man jedes Modell aufklappen$/ do
Then(/^I can expand each model line$/) do
  #step "man eine Modell-Zeile eines Modells, das weder ein Paket-Modell oder ein Bestandteil eines Paket-Modells ist, sieht"
  step "I see a model line for a model that is neither a package model nor part of a package model"
  within @model_line.find(".button[data-type='inventory-expander']") do
    find("i.arrow.right").click
    find("i.arrow.down")
  end
end

#Dann /^man sieht die Gegenstände, die zum Modell gehören$/ do
Then /^I see the items belonging to the model$/ do
  @items_element = @model_line.find(:xpath, "following-sibling::div[@class='group-of-lines']")
  items = @model.items.by_owner_or_responsible(@current_inventory_pool)
  expect(items).to exist
  items.each do |item|
    @items_element.find(".line", text: item.inventory_code)
  end
end

#Dann /^so eine Zeile sieht aus wie eine Gegenstands\-Zeile$/ do
Then(/^such a line looks like an item line$/) do
  @item_line ||= @items_element.find(".line", match: :first)
  @item ||= Item.find_by_inventory_code(@item_line.find(".col2of5.text-align-left:nth-child(2) .row:nth-child(1)").text)

  # this check is to cover the case where there is item assigned but the user has not signed yet
  if @item.in_stock? and @item.current_borrower and @item.inventory_pool == @current_inventory_pool
    step 'the item line contains the name of the current borrower'
    step 'the item line contains the end date of the contract'
  elsif @item.in_stock? and @item.inventory_pool == @current_inventory_pool
    step 'the item line contains the code of the building'
    step 'the item line contains the room'
    step 'the item line contains the shelf'
  elsif not @item.in_stock? and @item.inventory_pool == @current_inventory_pool
    step 'the item line contains the name of the current borrower'
    step 'the item line contains the end date of the contract'
  elsif @item.owner == @current_inventory_pool and @item.inventory_pool != @current_inventory_pool
    step 'the item line contains the responsible department '
    step 'the item line contains the code of the building'
    step 'the item line contains the room'
  else
    step 'the item line contains the code of the building'
    step 'the item line contains the room'
    step 'the item line contains the shelf'
  end

end

#Dann /^kann man jedes Paket\-Modell aufklappen$/ do
Then(/^I can expand each package model line$/) do
  @package = @current_inventory_pool.items.packages.last.model
  step 'I search for "%s"' % @package.name
  @package_line = find(".line[data-is_package='true']")
  within @package_line do
    find(".button[data-type='inventory-expander'] i.arrow.right").click
    find(".button[data-type='inventory-expander'] i.arrow.down")
  end
end

#Dann /^man sieht die Pakete dieses Paket\-Modells$/ do
Then(/^I see the packages contained in this package model$/) do
  @packages_element = @package_line.find(:xpath, "following-sibling::div[@class='group-of-lines']")
  @package.items.each do |package|
    expect(@packages_element.has_content? package.inventory_code).to be true
  end
  @item_line = @packages_element.all(".line[data-type='item']").to_a.sample
  @item = Item.find_by_inventory_code(@item_line.find(".col2of5.text-align-left:nth-child(2) .row:nth-child(1)").text)
end

#Dann /^man kann diese Paket\-Zeile aufklappen$/ do
Then(/^I can expand this package line$/) do
  within @item_line do
    find(".button[data-type='inventory-expander'] i.arrow.right").click
    find(".button[data-type='inventory-expander'] i.arrow.down")
  end
  @package_parts_element = @item_line.find(:xpath, "following-sibling::div[@class='group-of-lines']")
end

#Dann /^man sieht die Bestandteile, die zum Paket gehören$/ do
Then(/^I see the components of this package$/) do
  @item.children.each do |part|
    expect(@package_parts_element.has_content? part.inventory_code).to be true
  end
end

#Dann /^so eine Zeile zeigt nur noch Inventarcode und Modellname des Bestandteils$/ do
Then(/^such a line shows only inventory code and model name of the component$/) do
  @item.children.each do |part|
    expect(@package_parts_element.has_content? part.inventory_code).to be true
    expect(@package_parts_element.has_content? part.name).to be true
  end
end

#Dann /^kann man diese Daten als CSV\-Datei exportieren$/ do
Then /^I can export this data as a CSV file$/ do
  def parsed_query
    href = find("#csv-export")[:href]
    uri = URI.parse href
    expect(uri.path).to eq manage_inventory_csv_export_path(@current_inventory_pool)
    Rack::Utils.parse_nested_query uri.query
  end

  expect(parsed_query["retired"]).to eq "false"
  if [nil, "0"].include? parsed_query["in_stock"]
    find("input#in_stock").click
  end
  expect(parsed_query["in_stock"]).to eq "1"
  @params = ActionController::Parameters.new(parsed_query)
end

#Dann /^die Datei enthält die gleichen Zeilen, wie gerade angezeigt werden \(inkl\. Filter\)$/ do
Then /^the file contains the same lines as are shown right now, including any filtering$/ do
  # not really downloading the file, but invoking directly the model class method
  @csv = CSV.parse InventoryPool.csv_export(@current_inventory_pool, @params),
                   {col_sep: ";", quote_char: "\"", force_quotes: true, headers: :first_row}
  step "I fetch all pages of the list"
  within "#inventory" do
    ["model", "software"].each do |type|
      selector = ".line[data-type='#{type}'] .button[data-type='inventory-expander'] i.arrow.right"
      while has_selector?(selector) do
        all(selector).each &:click
      end
    end
      line_codes = (all(".line[data-type='item']").to_a + all(".line[data-type='license']").to_a).map { |l| l.find(".col2of5 .row", match: :first).text }
    csv_codes = @csv.map {|csv_row| csv_row["Inventory Code"] }
    expect(csv_codes.sort).to eq line_codes.sort
  end
end

#Dann(/^die Zeilen enthalten die folgenden Felder in aufgeführter Reihenfolge$/) do |table|
Then(/^the lines contain the following fields in order:$/) do |table|
  csv_headers = @csv.headers
  table.hashes.each do |row|
    expect(csv_headers).to include row["Fields"]
  end
  expect(csv_headers).to eq table.raw.flatten[1..-1]
end

#Wenn /^ich ein[en]* neue[srn]? (.+) hinzufüge$/ do |entity|
When(/^I add a new (.+)/) do |entity|
  find(".dropdown-holder", text: _("Add inventory")).click
  click_link entity
end

#Given(/^ich add a new (?:.+) or I change an existing (.+)$/) do |entity|
When(/^I add or edit a (.+)/) do |entity|
  klass = case _(entity)
          when "model" then Model
          when "software" then Software
          end
  @model = klass.all.first
  visit manage_edit_model_path(@current_inventory_pool, @model)
end

#Und /^ich (?:erfasse|ändere)? ?die folgenden Details ?(?:erfasse|ändere)?$/ do |table|
When /^I (?:enter|edit)? ?the following details$/ do |table|
  # table is a Cucumber::Ast::Table
  find(".button.green", text: _("Save %s") % _("#{get_rails_model_name_from_url.capitalize}"))
  @table_hashes = table.hashes
  @table_hashes.each do |row|
    find(".field .row", match: :prefer_exact, text: row["Field"]).find(:xpath, ".//input | .//textarea").set row["Value"]
  end
end

#Dann /^die Informationen sind gespeichert$/ do
Then /^the information is saved$/ do
  search_string = @table_hashes.detect {|h| h["Field"] == "Product"}["Value"]
  find(:select, "retired").first("option").select_option
  step 'I search for "%s"' % search_string
  find(".line", match: :prefer_exact, text: search_string)
  step 'I should see "%s"' % search_string
end

#Dann /^die Daten wurden entsprechend aktualisiert$/ do
Then /^the data has been updated$/ do
  search_string = @table_hashes.detect { |h| h["Field"] == "Product" }["Value"]
  step 'I search for "%s"' % search_string
  find(".line", :text => search_string).find("a", :text => Regexp.new(_("Edit"), "i")).click

  # check that the same model was modified
  # This step seems to be used starting from steps that define @model and
  # steps that don't, so we need to handle both here I guess.
  if @model && !@model_id
    @model_id = @model.id
  end
  expect((Rails.application.routes.recognize_path current_path)[:id].to_i).to eq @model_id

  @table_hashes.each do |row|
    field_name = row["Field"]
    field_value = row["Value"]

    f = find(".field .row", match: :prefer_exact, text: field_name)
    value_in_field = f.find(:xpath, ".//input | .//textarea").value

    if field_name == "Price"
      field_value = field_value.to_i
      value_in_field = value_in_field.to_i
    end

    expect(field_value).to eq value_in_field
  end

  click_link("%s" % _("Cancel"))
  find("#inventory-index-view h1", match: :prefer_exact, text: _("List of Inventory"))
  expect(current_path).to eq @page_to_return
end

#Wenn /^ich nach "(.+)" suche$/ do |search_term|
When(/^I search for "(.+)"$/) do |search_term|
  fill_in "list-search", with: search_term
  sleep(0.55) # NOTE this sleep is required waiting the search result
end

#Wenn /^ich eine?n? bestehende[s|n]? (.+) bearbeite$/ do |entity|
When /^I edit an existing (.+)$/ do |entity|

  if entity == 'Package'

    if @model
      @package = @model.items.packages.where(inventory_pool_id: @current_inventory_pool).sample
      find("#packages .line[data-id='#{@package.id}'] [data-edit-package]").click
    else
      find("#packages .line[data-new] [data-edit-package]", match: :first).click
    end
    within ".modal" do
      find("[data-type='field']", match: :first)
    end
  else

    @page_to_return = current_path
    object_name = case entity
                    when "Model"
                      @model = @current_inventory_pool.models.where(type: "Model").sample
                      @model.name
                    when "Option"
                      find(:select, "retired").first("option").select_option
                      @option = @current_inventory_pool.options.sample
                      @option.name
                  end
    step 'I search for "%s"' % object_name
    find(".line", match: :prefer_exact, :text => object_name).find(".button", :text => "Edit #{entity}").click
  end
end

#Wenn /^ich ein bestehendes, genutztes Modell bearbeite welches bereits( ein aktiviertes)? Zubehör hat$/ do |arg1|
When /^I edit a model that exists, is in use and already has( activated)? accessories$/ do |arg1|
  @model = @current_inventory_pool.models.to_a.detect do |m|
    if arg1
      m.accessories.count > 0 and m.accessories.any? { |a| a.inventory_pools.include? @current_inventory_pool }
    else
      m.accessories.count > 0
    end
  end
  visit manage_edit_model_path(@current_inventory_pool, @model)
end

#Dann /^(?:die|das|der) neue[sr]? (?:.+) ist erstellt$/ do
# use ->  step "the information is saved"

#Wenn /^ich einen Namen eines existierenden Modelles eingebe$/ do
When /^I enter the name of an existing model$/ do
  model = Model.all.first
  step %{I edit the following details}, table(%{
    | Field    | Value                   |
    | Product | #{model.product}       |
    | Version | #{model.version}       |})
end

#Dann /^wird das Modell nicht gespeichert, da es keinen (?:eindeutigen\s)?Namen hat$/ do
Then /^the model is not saved because it does not have a (?:unique )?name$/ do
  @model_name_from_url = get_rails_model_name_from_url
  step 'I should see "%s"' % (_("Save %s") % _("#{@model_name_from_url.capitalize}"))
end

#Dann /^habe ich die Möglichkeit, folgende Informationen zu erfassen:$/ do |table|
Then /^I can enter the following information:$/ do |table|
  table.raw.flatten.all? do |field_name|
    find(".field", text: field_name)
  end
end

#Dann /^ich sehe das gesamte Zubehöre für dieses Modell$/ do
Then /^I see all the accessories for this model$/ do
  within(".row.emboss", match: :prefer_exact, :text => _("Accessories")) do
    @model.accessories.each do |accessory|
      find(".list-of-lines .line", text: accessory.name)
    end
  end
end

#Dann /^ich sehe, welches Zubehör für meinen Pool aktiviert ist$/ do
Then /^I see which accessories are active for my pool$/ do
  within(".row.emboss", match: :prefer_exact, :text => _("Accessories")) do
    @model.accessories.each do |accessory|
      input = find(".list-of-lines .line", text: accessory.name).find("input")
      if @current_inventory_pool.accessories.where(:id => accessory.id).first
        expect(input.checked?).to be true
      else
        expect(input.checked?).to be false
      end
    end
  end
end

#Wenn /^ich Zubehör hinzufüge und falls notwendig die Anzahl des Zubehör ins Textfeld schreibe$/ do
When /^I add accessories and, if necessary, fill in the quantity in the text field$/ do
  within(".row.emboss", match: :prefer_exact, :text => _("Accessories")) do
    @new_accessory_name = "2x #{Faker::Name.name}"
    find("#accessory-name").set @new_accessory_name
    find("#add-accessory").click
  end
end

#Dann /^ist das Zubehör dem Modell hinzugefügt worden$/ do
Then /^accessories are added to the model$/ do
  find("#inventory-index-view h1", match: :prefer_exact, text: _("List of Inventory"))
  expect(@model.accessories.reload.where(:name => @new_accessory_name)).not_to be_nil
end

#Dann /^kann ich ein einzelnes Zubehör löschen, wenn es für keinen anderen Pool aktiviert ist$/ do
Then /^I can delete a single accessory if it is not active in any other pool$/ do
  accessory_to_delete = @model.accessories.detect { |x| x.inventory_pools.count <= 1 }
  within(".row.emboss", match: :prefer_exact, :text => _("Accessories")) do
    find(".list-of-lines .line", text: accessory_to_delete.name).find("button", text: _("Remove")).click
  end
  step 'I save'
  find("#inventory-index-view h1", match: :prefer_exact, text: _("List of Inventory"))
  expect { accessory_to_delete.reload }.to raise_error(ActiveRecord::RecordNotFound)
end

#Dann /^kann ich ein einzelnes Zubehör für meinen Pool deaktivieren$/ do
Then /^I can deactivate an accessory for my pool$/ do
  accessory_to_deactivate = @model.accessories.detect { |x| x.inventory_pools.where(id: @current_inventory_pool.id).first }
  within(".row.emboss", match: :prefer_exact, :text => _("Accessories")) do
    find(".list-of-lines .line", text: accessory_to_deactivate.name).find("input").click
  end
  step 'I save'
  find("#inventory-index-view h1", match: :prefer_exact, text: _("List of Inventory"))
  expect { @current_inventory_pool.accessories.reload.find(accessory_to_deactivate) }.to raise_error(ActiveRecord::RecordNotFound)
end

#Dann /^kann ich mehrere Bilder hinzufügen$/ do
When /^I add multiple images$/ do
  upload_images(["image1.jpg", "image2.jpg", "image3.png"])
end

#Dann /^ich kann Bilder auch wieder entfernen$/ do
Then /^I can also remove those images$/ do
  find(".row.emboss", match: :prefer_exact, :text => _('Images')).find("[data-type='inline-entry']", :text => "image1.jpg").find("button[data-remove]", match: :first).click
  @images_to_save = []
  find(".row.emboss", match: :prefer_exact, :text => _('Images')).all("[data-type='inline-entry']").each do |entry|
    @images_to_save << entry.text.split(" ")[0]
  end
end

#Dann /^zu grosse Bilder werden den erlaubten Grössen entsprechend verkleinert$/ do
Then /^the images are resized to their thumbnail size when I see them in lists$/ do
  step 'I search for "%s"' % @model.name
  find(".line[data-id='#{@model.id}']").find(".button", :text => "Edit Model").click
  @images_to_save.each do |image_name|
    find("a[href*='#{image_name}'] img[src*='#{image_name.split(".").first}_thumb.#{image_name.split(".").last}']")
  end
end

#Dann /^wurden die ausgewählten Bilder für dieses Modell gespeichert$/ do
Then /^the remaining images are saved for that model$/ do
  expect(@model.images.map(&:filename).sort).to eq @images_to_save.sort
end

#Und /^ich speichere das Modell mit Bilder$/ do
When /^I save the model and its images$/ do
  @model_name_from_url = get_rails_model_name_from_url
  step 'I press "%s"' % (_("Save %s") % _("#{@model_name_from_url.capitalize}"))
  find("#inventory-index-view h1", match: :prefer_exact, text: _("List of Inventory"))
end

#Dann /^füge ich eine oder mehrere Datein den Attachments hinzu$/ do
Then /^I add one or more attachments$/ do
  @attachment_filenames = ["image1.jpg", "image2.jpg"]
  within "#attachments" do
    upload_images(@attachment_filenames)
  end
end

#Dann /^kann Attachments auch wieder entfernen$/ do
Then /^I can also remove attachments again$/ do
  attachment_to_remove = @attachment_filenames.delete(@attachment_filenames.sample)
  find(".row.emboss", match: :prefer_exact, :text => _('Attachments')).find("[data-type='inline-entry']", text: attachment_to_remove).find("button[data-remove]", match: :first).click
end

#Dann /^sind die Attachments gespeichert$/ do
Then /^the attachments are saved$/ do
  find("#inventory-index-view h1", match: :prefer_exact, text: _("List of Inventory"))
  expect(@model.attachments.reload.where(filename: @attachment_filenames.sample).empty?).to be false
end

Dann /^sieht man keine Modelle, denen keine Gegenstänge zugewiesen unter keinem der vorhandenen Reiter$/ do
  within "#list-tabs" do
    all(".inline-tab-item").each do |tab|
      tab.click
      find("#inventory .line[data-type]", match: :first)
      if tab.text == _("Unused Models")
        expect(has_no_selector?(".line[data-type='model'] button[data-type='inventory-expander'] .arrow.right")).to be true
      else
        expect(has_no_selector?(".line[data-type='model'] button[data-type='inventory-expander']", text: "0")).to be true
      end
    end
  end
end

#Wenn(/^ich eine resultatlose Suche mache$/) do
When(/^I make a search without any results$/) do
  begin
    search_term = Faker::Lorem.words.join
  end while not @current_inventory_pool.inventory({search_term: search_term}).empty?
  step %Q(I search for "%s") % search_term
end

#Dann(/^sehe ich 'No entries found'$/) do |arg1|
Then(/^I see 'No entries found'$/) do
  find("#inventory", text: _("No entries found"))
end

#Angenommen(/^man öffnet die Liste der Geräteparks$/) do
Given(/^I open the list of inventory pools$/) do
  visit manage_inventory_pools_path if current_path != manage_inventory_pools_path
end

Given(/^I'am on the software inventory overview$/) do
  find("#list-tabs a[data-type='license']").click
end

When(/^I press CSV-Export$/) do
  find("#csv-export").click
end

When(/^I look at this license in the software list$/) do
  find("a[data-type='license']").click
  step 'I search for "%s"' % @license.inventory_code
  within ".line[data-type='software'][data-id='#{@license.model.id}']" do
    el = find(".button[data-type='inventory-expander']")
      if el.has_selector?("i.arrow.right")
      el.click
      el.find("i.arrow.down")
    end
  end
  @item_line = @license_line = ".group-of-lines .line[data-type='license'][data-id='#{@license.id}']"
end

Then(/^the license line contains the '(.*)' information$/) do |arg1|
  line = @license_line.is_a?(String) ? find(@license_line, match: :first) : @license_line
  case arg1
    when "operating system"
      @license.properties[:operating_system].map(&:titleize).each do |os|
        expect(line.has_content? _(os)).to be true
      end
    when "license type"
      expect(line.has_content? _(@license.properties[:license_type].titleize)).to be true
    when "quantity"
      expect(line.has_content? @license.properties[:total_quantity]).to be true
    else
      raise
  end
end

Given(/^there exists a software license$/) do
  @item = @license = Item.licenses.where(inventory_pool_id: @current_inventory_pool.id).select { |l| l.properties[:operating_system] and l.properties[:license_type] }.sample
  expect(@license).not_to be_nil
end

Given(/^there exists a software license of one of the following types$/) do |table|
  types = table.hashes.map { |h| h["technical"] }
  @item = @license = Item.licenses.where(inventory_pool_id: @current_inventory_pool.id).select { |l| types.include?(l.properties[:license_type]) and l.properties[:operating_system] }.sample
  expect(@license).not_to be_nil
end

Given(/^there exists a software license, owned by my inventory pool, but given responsibility to another inventory pool$/) do
  @item = @license = Item.licenses.where.not(inventory_pool_id: nil).where("owner_id = :ip_id AND inventory_pool_id != :ip_id", {ip_id: @current_inventory_pool.id}).select { |l| l.properties[:operating_system] and l.properties[:license_type] }.sample
  expect(@license).not_to be_nil
end

Given(/^there exists a software license, which is not in stock and another inventory pool is responsible for it$/) do
  @item = @license = Item.licenses.where.not(inventory_pool_id: nil).where("owner_id = :ip_id AND inventory_pool_id != :ip_id", {ip_id: @current_inventory_pool.id}).detect { |i| not i.in_stock? }
  expect(@license).not_to be_nil
end

When(/^I choose inside all inventory as "(.*?)" the option "(.*?)"$/) do |arg1, arg2|
  case arg1
  when "used & not used"
    filter = find(:select, "used")
  when "borrowable & not borrowable"
    filter = find(:select, "is_borrowable")
  when "retired & not retired"
    filter = find(:select, "retired")
  end

  filter.find(:option, arg2).select_option
  step "I fetch all pages of the list"
end

Then(/^only the "(.*?)" inventory is shown$/) do |arg1|
  if arg1 == "unused"
    models = Model.unused_for_inventory_pool(@current_inventory_pool)
  elsif arg1 == "In stock"
    items = Item.by_owner_or_responsible(@current_inventory_pool).in_stock
    models = items.map(&:model).uniq
  elsif arg1 == "Owner"
    models = Model.joins(:items).where(items: {owner_id: @current_inventory_pool.id}).uniq
  else
    models = Model.owned_or_responsible_by_inventory_pool(@current_inventory_pool)
    case arg1
    when "ausleihbar"
      models = models.where(items: {is_borrowable: true})
    when "nicht ausleihbar"
      models = models.where(items: {is_borrowable: false})
    when "ausgemustert"
      models = models.where.not(items: {retired: nil})
    when "nicht ausgemustert"
      models = models.where(items: {retired: nil})
    when "Defekt"
      models = models.where(items: {is_broken: true})
    when "Unvollständig"
      models = models.where(items: {is_incomplete: true})
    end
  end

  check_amount_of_lines(models.count)
end

Given(/^I see retired and not retired inventory$/) do
  find(:select, "retired").first("option").select_option
  expect(has_selector? "#inventory > .line").to be true
end

When(/^I set the option "(.*?)" inside of the full inventory$/) do |arg1|
  case arg1
  when "Owned"
    filter = find(:checkbox, "owned")
  when "In stock"
    filter = find(:checkbox, "in_stock")
  when "Incomplete"
    filter = find(:checkbox, "incomplete")
  when "Broken"
    filter = find(:checkbox, "broken")
  end

  filter.click
  step "I fetch all pages of the list"
end

Then(/^for the following inventory groups the filter "(.*?)" is set$/) do |arg1, table|
  table.raw.flatten.each do |tab|
    find("a", text: _(tab)).click
    expect(find(:select, "retired").find(:option, arg1)).to be_checked
  end
end

Given(/^one is on the list of the options$/) do
  find("a", text: _("Options")).click
end

When(/^I choose a certain responsible pool inside the whole inventory$/) do
  @responsible_pool = @current_inventory_pool.own_items.select(:inventory_pool_id).where.not(items: {inventory_pool_id: [@current_inventory_pool.id, nil]}).uniq.sample.inventory_pool
  find(:select, "responsible_inventory_pool_id").find(:option, @responsible_pool.name).select_option
end

Then(/^only the inventory is shown for which this pool is responsible$/) do
  inventory = @responsible_pool.items.where(items: {owner_id: @current_inventory_pool.id})
  step "I fetch all pages of the list"
  check_amount_of_lines inventory.joins(:model).select(:model_id).uniq.count
  check_existing_inventory_codes(inventory)
end

Then(/^the item corresponding to the model appears$/) do
  within "#inventory" do
    find(".line[data-type='model']", match: :prefer_exact, text: @item.model.name)
  end
end

Then(/^the item appears$/) do
  within "#inventory" do
    step "expand the corresponding model"
    find(".line[data-type='item'][data-id='#{@item.id}']", text: @item.inventory_code)
  end
end

When(/^expand the corresponding model$/) do
  within(".line[data-type='model']", match: :prefer_exact, text: @item.model.name) do
    find("[data-type='inventory-expander']").click
  end
end

Given(/^I see the list of "(.*?)" inventory$/) do |arg1|
  case arg1
  when "Broken"
    find("input#broken[type='checkbox']").click
  when "Retired"
    find(:select, "retired").find(:option, _("retired")).select_option
  when "Incomplete"
    find("input#incomplete[type='checkbox']").click
  when "Unborrowable"
    find(:select, "is_borrowable").find(:option, _("unborrowable")).select_option
  end
end

When(/^I open a model line$/) do
  find(".line[data-type='model'] [data-type='inventory-expander']", match: :first).click
end

Then(/^the item line ist marked as "(.*?)" in red$/) do |arg1|
  find(".line[data-type='item'] .darkred-text", match: :first, text: arg1)
end

Given(/^there exists an item with many problems$/) do
  Item.select("items.id", :retired, :is_incomplete, :is_broken, :is_borrowable).by_owner_or_responsible(@current_inventory_pool).items.find do |i|
    attrs = i.attributes
    item_id = attrs.delete("id")
    attrs["is_borrowable"] = !attrs["is_borrowable"]
    attrs.values.select{|v| v}.count >= 2 and (@item_id = item_id)
  end
  @item = Item.find @item_id
  expect(@item).not_to be_nil
end

When(/^I search after this item in the inventory list$/) do
  step 'I search for "%s"' % @item.inventory_code
end

When(/^I open the model line of this item$/) do
  find(".line[data-type='model']", text: @item.model.name).find("[data-type='inventory-expander']", match: :first).click
end

Then(/^the problems of this item are displayed separated by a comma$/) do
  find(".line[data-type='item'] .darkred-text", text: /.*, .*/)
end

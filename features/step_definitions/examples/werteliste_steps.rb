# -*- encoding : utf-8 -*-

#Angenommen /^man öffnet eine Werteliste$/ do
Given /^I open a value list$/ do
  #step 'man öffnet einen Vertrag bei der Aushändigung'
  step 'I open a contract during hand over'

  page.driver.browser.close
  new_window = page.driver.browser.window_handles.last
  page.driver.browser.switch_to.window new_window

  new_window = window_opened_by do
    find(".modal a", text: _("Value List")).click
  end
  page.driver.browser.switch_to.window new_window.handle

  @list_element = find(".value_list")
end

#Dann /^möchte ich die folgenden Bereiche in der (Werteliste|Rüstliste) sehen:$/ do |arg1, table|
Then /^I want to see the following sections in the (value list|picking list):$/ do |arg1, table|
  within @list_element do
    table.hashes.each do |area|
      case area["Section"]
        when "Date"
          within(".date") do
            expect(has_content? Date.today.year).to be true
            expect(has_content? Date.today.month).to be true
            expect(has_content? Date.today.day).to be true
          end
        when "Title"
          case arg1
            when "value list"
              expect(find("h1", text: _("Value List")).has_content? @contract.id).to be true
            when "picking list"
              find("h1", text: _("Picking List"))
          end
        when "Borrower"
          within(".customer") do
            expect(has_content? @contract.user.firstname).to be true
            expect(has_content? @contract.user.lastname).to be true
            expect(has_content? @contract.user.address).to be true if @contract.user.address
            expect(has_content? @contract.user.zip).to be true
            expect(has_content? @contract.user.city).to be true
          end
        when "Lender"
          find(".inventory_pool")
        when "List"
          case arg1
            when "value list"
              find(".list")
            when "picking list"
              find(".list", match: :first)
          end
      end
    end
  end
end

Dann /^the value list contains the following columns:$/ do |table|
  @list ||= @list_element.find(".list")
  within @list do
    table.hashes.each do |area|
      case area["Column"]
        when "Consecutive number"
          @contract.lines.each {|line| find("tr", text: line.item.inventory_code).find(".consecutive_number") }
        when "Inventory code"
          lines = if @list_element[:class] == "picking_list"
                    @selected_lines_by_date ? @selected_lines_by_date : @contract.lines
                  elsif @list_element[:class] == "value_list"
                    @contract.lines
                  else
                    raise
                  end
          lines.each do |line|
            next if line.item_id.nil?
            find("tr .inventory_code", text: line.item.inventory_code)
          end
        when "Model name"
          if @list_element[:class] == "picking_list"
            lines = @selected_lines_by_date ? @selected_lines_by_date : @contract.lines
            lines.group_by(&:model).each_pair do |model, lines|
              find("tr", match: :prefer_exact, text: model).find(".model_name", text: model.name)
            end
          elsif @list_element[:class] == "value_list"
            @contract.lines.each {|line| find("tr", text: line.item.inventory_code).find(".model_name", text: line.model.name) }
          else
            raise
          end
        when "End date"
          @contract.lines.each {|line|
            within find("tr", text: line.item.inventory_code).find(".end_date") do
              expect(has_content? line.end_date.year).to be true
              expect(has_content? line.end_date.month).to be true
              expect(has_content? line.end_date.day).to be true
            end
          }
        when "Quantity"
          if @list_element[:class] == "picking_list"
            picking_lines = @selected_lines_by_date ? @selected_lines_by_date : @contract.lines
            picking_lines.group_by(&:model).each_pair do |model, lines|
              find("tr", match: :prefer_exact, text: model).find(".quantity", text: lines.sum(&:quantity))
            end
          elsif @list_element[:class] == "value_list"
            @contract.lines.each {|line|
              find("tr", text: line.item.inventory_code).find(".quantity", text: line.quantity)
            }
          else
            raise
          end
        when "Price"
          @contract.lines.each {|line|
            expect(find("tbody tr", text: line.item.inventory_code).find(".item_price").text.gsub(/\D/, "")).to eq ("%.2f" % line.price).gsub(/\D/, "")
          }
        when "Raum / Gestell"
          find("table thead tr td.location", text: "%s / %s" % [_("Room"), _("Shelf")])
          @contract.lines.each {|line|
            find("tbody tr", text: line.item.inventory_code).find(".location", text:
                if line.model.is_a?(Option) or line.item.location.nil? or (line.item.location.room.blank? and line.item.location.shelf.blank?)
                  _("Location not defined")
                else
                  "%s / %s" % [line.item.location.room, line.item.location.shelf]
                end)
          }
        when "verfügbare Anzahl x Raum / Gestell"
          find("table thead tr td.location", text: "%s x %s / %s" % [_("available quantity"), _("Room"), _("Shelf")])
          lines = @selected_lines_by_date ? @selected_lines_by_date : @contract.lines
          lines.each do |line|
            within find("tr", match: :prefer_exact, text: line.model).find(".location") do
              locations = line.model.items.in_stock.where(inventory_pool_id: @current_inventory_pool).select("COUNT(items.location_id) AS count, locations.room AS room, locations.shelf AS shelf").joins(:location).group(:location_id).order("count DESC")
              locations.delete_if {|location| location.room.blank? and location.shelf.blank? }
              locations.each do |location|
                if line.item_id
                  find("tr", text: "%s / %s" % [location.room, location.shelf])
                else
                  find("tr", text: "%dx %s / %s" % [location.count, location.room, location.shelf])
                end
              end
            end
          end
        else
          raise
      end
    end
  end
end

Dann /^gibt es eine Zeile für die totalen Werte$/ do
  within @list_element.find(".list") do
    @total = find("tfoot.total")
  end
end

Dann /^diese summierte die Spalten:$/ do |table|
  table.hashes.each do |area|
    case area["Spaltenname"]
      when "Anzahl"
        expect(@total.find(".quantity", match: :first).has_content? @contract.quantity).to be true
      when "Wert"
        expect(@total.find(".value", match: :first).text.gsub(/\D/, "")).to eq ("%.2f" % @contract.lines.map(&:price).sum).gsub(/\D/, "")
    end
  end
end

#When(/^die Modelle in der Werteliste sind alphabetisch sortiert$/) do
When(/^the models in the value list are sorted alphabetically$/) do
  names = all(".value_list tbody .model_name").map{|name| name.text}
  expect(names.empty?).to be false
  expect(names.sort == names).to be true
end

Angenommen(/^es existiert eine Aushändigung mit mindestens zwei Modellen und einer Option, wo die Bestellmenge mindestens drei pro Modell ist$/) do
  @hand_over = @current_inventory_pool.visits.hand_over.detect do |ho|
    ho.contract_lines.where(type: "OptionLine").exists? and
      ho.contract_lines.where(type: "ItemLine").exists? and
        (g = ho.contract_lines.where(type: "ItemLine").group_by(&:model_id)) and
          g.keys.size >= 2 and
            g.values.detect {|x| x.size >= 3}
  end
  expect(@hand_over).not_to be_nil
  @lines = @hand_over.lines
end

Wenn(/^es ist pro Modell genau einer Linie ein Gegenstand zugewiesen$/) do
  @models = @lines.select{|l| l.is_a? ItemLine}.map(&:model)

  @models.uniq.each do |m|
    l = @lines.find{|l| l.model == m}
    l.update_attribute(:item, l.model.borrowable_items.where(inventory_pool_id: @current_inventory_pool).sample) unless l.is_a? OptionLine
  end
end

Wenn(/^ich mehrere Linien von der Aushändigung auswähle$/) do
  within "#lines" do
    expect(has_selector?(".line input[type='checkbox']")).to be true
    @number_of_selected_lines = all(".line input[type='checkbox']").size
    @lines.map(&:id).each {|id| find(".line[data-id='#{id}'] input[type='checkbox']").click }
  end
end

Wenn(/^ich mehrere Linien von der Bestellung auswähle$/) do
  within "#lines" do
    expect(has_selector?(".emboss .row input[type='checkbox']")).to be true
    @number_of_selected_lines = @order.lines.size
    all(".emboss .row input[type='checkbox']").each {|i| i.click unless i.checked? }
  end
end

Wenn(/^das Werteverzeichniss öffne$/) do
  find("[data-selection-enabled]").find(:xpath, "./following-sibling::*").click
  document_window = window_opened_by do
    click_button _("Print Selection")
  end
  page.driver.browser.switch_to.window(document_window.handle)
end

Dann(/^sehe ich das Werteverzeichniss für die ausgewählten Linien$/) do
  expect(has_content? _("Value list")).to be true
  find("tfoot.total .quantity").text == @number_of_selected_lines.to_s
end

Dann(/^für die nicht zugewiesenen Linien ist der Preis der höchste Preis eines Gegenstandes eines Models innerhalb des Geräteparks$/) do
  @models.each do |m|
    lines = @lines.select {|l| l.is_a? ItemLine and l.model == m and not l.item.try(:inventory_code)}
    quantity = lines.size
    line = all("tr", text: m.name).find {|line| line.find(".inventory_code").text == "" }
    if line
      expect(line.find(".item_price").text.delete("'")).to match /#{(@lines.reload.find{|l| not l.item and l.model == m}.price_or_max_price * quantity).to_s}/
    end
  end
end

Dann(/^für die zugewiesenen Linien ist der Preis der des Gegenstandes$/) do
  lines = @lines.select {|l| l.item.try(:inventory_code)}
  lines.each do |line|
    expect(find("tr", text: line.item.inventory_code).find(".item_price").text.delete("'")).to match /#{line.price_or_max_price.to_s}/
  end
end

Dann(/^die nicht zugewiesenen Linien sind zusammengefasst$/) do
  @models.each do |m|
    expect(all("tr", text: m.name).select{|line| line.find(".inventory_code").text == "" }.size).to be <= 1 # for models with quantity 1 and an assigned item size == 0, that's why <= 1
  end
end

Dann(/^der Preis einer Option ist der innerhalb des Geräteparks$/) do
  lines = @lines.select {|l| l.is_a? OptionLine }
  lines.each do |l|
    line = find("tr", text: l.model.name)
    expect(line.find(".item_price").text.delete("'")).to match /#{@current_inventory_pool.options.find(l.item.id).price * l.quantity}/
  end
end

Angenommen(/^es existiert eine Bestellung mit mindestens zwei Modellen, wo die Bestellmenge mindestens drei pro Modell ist$/) do
  @order = @current_inventory_pool.contracts.submitted.find do |o|
    o.contract_lines.map(&:model).instance_eval do
      uniq.count >= 2 and select{|m| o.contract_lines.select{|l| l.model == m}.count >= 3 }.uniq.count >= 2
    end
  end
  expect(@order).not_to be_nil
  @lines = @order.lines
  @models = @lines.select{|l| l.is_a? ItemLine}.map(&:model)
end

Wenn(/^ich eine Bestellung öffne$/) do
  @contract = @order
  step "I edit the order"
end

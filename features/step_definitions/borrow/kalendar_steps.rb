# -*- encoding : utf-8 -*-

Wenn(/^man auf einem Model "Zur Bestellung hinzufügen" wählt$/) do
  find("#model-list > a.line[data-id]", match: :first)
  line = all("#model-list > a.line[data-id]").sample
  @model = Model.find line["data-id"]
  line.find("button[data-create-order-line]").click
end

Wenn(/^man auf einem verfügbaren Model "Zur Bestellung hinzufügen" wählt$/) do
  step 'man ein Startdatum auswählt'
  find("#model-list > a.line[data-id]", match: :first)
  line = all("#model-list > a.line[data-id]:not(.grayed-out)").sample
  @model = Model.find line["data-id"]
  line.find("button[data-create-order-line]").click
end

Dann(/^öffnet sich der Kalender$/) do
  find("#booking-calendar .fc-day-content", match: :first)
end

Wenn(/^ich den Kalender schliesse$/) do
  find(".modal-close").click
end

Dann(/^schliesst das Dialogfenster$/) do
  expect(has_no_selector?("#booking-calendar")).to be true
end

Wenn(/^man versucht ein Modell zur Bestellung hinzufügen, welches nicht verfügbar ist$/) do
  start_date = Date.today
  end_date = Date.today + 14
  @quantity = 3
  inventory_pool = @current_user.inventory_pools.detect do |ip|
    @model = @current_user.models.borrowable.detect do |m|
      m.availability_in(ip).maximum_available_in_period_summed_for_groups(start_date, end_date, @current_user.group_ids) < @quantity and
      m.total_borrowable_items_for_user(@current_user, ip) >= @quantity
    end
  end
  visit borrow_model_path(@model)
  find("[data-create-order-line][data-model-id='#{@model.id}']").click
  step "I set the start date in the calendar to '%s'" % I18n.l(inventory_pool.next_open_date(start_date))
  step "ich setze das Enddatum im Kalendar auf '%s'" % I18n.l(inventory_pool.next_open_date(end_date))
  step "ich setze die Anzahl im Kalendar auf #{@quantity}"
  find("#submit-booking-calendar").click
end

Wenn(/^ich setze die Anzahl im Kalendar auf (\d+)$/) do |quantity|
  find("#booking-calendar-quantity")
  find(".fc-widget-content", match: :first)
  find("#booking-calendar-quantity").set quantity
end

#Wenn(/^ich setze das Startdatum im Kalendar auf '(.*?)'$/) do |date|
When(/^I set the start date in the calendar to '(.*?)'$/) do |date|
  find("#booking-calendar-start-date").set date
  find("#booking-calendar-controls").click # blur input in order to fire event listeners
end

#Wenn(/^ich setze das Enddatum im Kalendar auf '(.*?)'$/) do |date|
When(/^I set the end date in the calendar to '(.*?)'$/) do |date|
  find("#booking-calendar-end-date").set date
  find("#booking-calendar-controls").click # blur input in order to fire event listeners
end

Dann(/^schlägt der Versuch es hinzufügen fehl$/) do
  find("#booking-calendar")
  models = @current_user.contracts.unsubmitted.flat_map(&:lines).flat_map(&:model)
  expect(models.include? @model).to be false
end

Dann(/^ich sehe die Fehlermeldung, dass das ausgewählte Modell im ausgewählten Zeitraum nicht verfügbar ist$/) do
  within ".modal" do
    find("#booking-calendar-errors", text: _("Item is not available in that time range"))
  end
end

Wenn(/^man einen Gegenstand aus der Modellliste hinzufügt$/) do
  visit borrow_models_path(category_id: Category.find {|c| !c.models.active.blank?})
  @model_name = find(".line .line-col.col3of6", match: :first).text
  @model = Model.find {|m| [m.name, m.product].include? @model_name}
  find(".line .button", match: :first).click
end

Dann(/^der Kalender beinhaltet die folgenden Komponenten$/) do |table|
  within ".modal[role='dialog']" do
    find ".headline-m", text: @model_name
    find ".fc-header-title", text: I18n.l(Date.today, format: "%B %Y")
    find "#booking-calendar"
    find "#booking-calendar-inventory-pool"
    find "#booking-calendar-start-date"
    find "#booking-calendar-end-date"
    find "#booking-calendar-quantity"
    find "#submit-booking-calendar"
    find ".modal-close", text: _("Cancel")
  end
end

Wenn(/^alle Angaben die ich im Kalender mache gültig sind$/) do
  within "#booking-calendar-inventory-pool" do
    find("option", match: :first)
    @inventory_pool = InventoryPool.find all("option").detect{|o| o.selected?}["data-id"]
  end
  @quantity = 1 + @current_user.contracts.unsubmitted.flat_map(&:lines).select{|line| line.model == @model}.sum(&:quantity)
  step "ich setze die Anzahl im Kalendar auf #{1}"

  start_date = select_available_not_closed_date
  select_available_not_closed_date(:end, start_date)

  step "I save the booking calendar"
end

Dann(/^ist das Modell mit Start- und Enddatum, Anzahl und Gerätepark der Bestellung hinzugefügt worden$/) do
  within "#current-order-lines" do
    find(".line", match: :first)
    find(".line", :text => "#{@quantity}x #{@model.name}")
  end
  expect(@current_user.contracts.unsubmitted.flat_map(&:lines).detect{|line| line.model == @model}).not_to be_nil
end

Dann(/^lässt sich das Modell mit Start\- und Enddatum, Anzahl und Gerätepark der Bestellung hinzugefügen$/) do
  step 'ist das Modell mit Start- und Enddatum, Anzahl und Gerätepark der Bestellung hinzugefügt worden'
end

Dann(/^das aktuelle Startdatum ist heute$/) do
  within ".modal[role='dialog']" do
    expect(find("#booking-calendar-start-date").value).to eq I18n.l(Date.today)
  end
end

Dann(/^das Enddatum ist morgen$/) do
  within ".modal[role='dialog']" do
    expect(find("#booking-calendar-end-date").value).to eq I18n.l(Date.today + 1.day) # FIXME Date.tomorrow is returning same as Date.today
  end
end

Dann(/^die Anzahl ist 1$/) do
  within ".modal[role='dialog']" do
    find("#booking-calendar-quantity[value='1']")
  end
end

Dann(/^es sind alle Geräteparks angezeigt die Gegenstände von dem Modell haben$/) do
  within "#booking-calendar-inventory-pool" do
    ips = @current_user.inventory_pools.select do |ip|
      @model.total_borrowable_items_for_user(@current_user, ip)
    end

    ips_in_dropdown = all("option").map(&:text)

    ips.each do |ip|
      ips_in_dropdown.include?(ip.name + " (#{@model.total_borrowable_items_for_user(@current_user, ip)})")
    end
  end
end

Angenommen(/^man hat eine Zeitspanne ausgewählt$/) do
  find("#start-date").click
  find("#start-date").set I18n.l(Date.today + 1)
  find("#end-date").click
  find("#end-date").set I18n.l(Date.today + 2)
end

Wenn(/^man einen in der Zeitspanne verfügbaren Gegenstand aus der Modellliste hinzufügt$/) do
  @model_name = find(".line:not(.grayed-out) .line-col.col3of6", match: :first).text
  @model = Model.find {|m| [m.name, m.product].include? @model_name}
  find(".line .button", match: :first).click
end

Dann(/^das Startdatum entspricht dem vorausgewählten Startdatum$/) do
  expect(find("#booking-calendar-start-date").value).to eq I18n.l(Date.today + 1)
end

Dann(/^das Enddatum entspricht dem vorausgewählten Enddatum$/) do
  expect(find("#booking-calendar-end-date").value).to eq I18n.l(Date.today + 2)
end

Angenommen(/^es existiert ein Modell für das eine Bestellung vorhanden ist$/) do
  @current_user.inventory_pools.flat_map(&:contract_lines).shuffle.detect do |cl|
    @model = cl.model
    cl.is_a?(ItemLine) and cl.start_date.future? and cl.model.categories.exists?
  end
end

Wenn(/^man dieses Modell aus der Modellliste hinzufügt$/) do
  visit borrow_models_path(category_id: @model.categories.first)
  find("#model-list-search input").set @model.name
  within(".line", match: :prefer_exact, text: @model.name) do
    find(".button").click
  end
end

def get_selected_inventory_pool
  InventoryPool.find_by_name find("#booking-calendar-inventory-pool option").value.split(" ").first
end

Dann(/^wird die Verfügbarkeit des Modells im Kalendar angezeigt$/) do
  @current_inventory_pool = get_selected_inventory_pool
  av = @model.availability_in(@current_inventory_pool)
  changes = av.available_total_quantities

  changes.each_with_index do |change, i|
    current_calendar_date = Date.parse page.evaluate_script %Q{ $("#booking-calendar").fullCalendar("getDate").toDateString() }
    current_change_date = change[0]
    while current_calendar_date.month != current_change_date.month do
      find(".fc-button-next").click
      current_calendar_date = Date.parse page.evaluate_script %Q{ $("#booking-calendar").fullCalendar("getDate").toDateString() }
    end

    # iterate days between this change and the next one
    next_change = changes[i+1]
    if next_change
      days_between_changes = (next_change[0]-change[0]).to_i
      next_date = change[0]
      last_month = next_date.month
      days_between_changes.times do
        if next_date.month != last_month
          find(".fc-button-next").click
        end
        last_month = next_date.month
        change_date_el = find(".fc-widget-content:not(.fc-other-month) .fc-day-number", match: :prefer_exact, :text => /#{next_date.day}/).first(:xpath, "../..")
        next unless @current_inventory_pool.is_open_on? change_date_el[:"data-date"].to_date
        # check borrower availability
        quantity_for_borrower = av.maximum_available_in_period_summed_for_groups next_date, next_date, @current_user.group_ids
        change_date_el.find(".fc-day-content div", text: quantity_for_borrower)
        next_date += 1.day
      end
    end
  end
end

Angenommen(/^man hat den Buchungskalender geöffnet$/) do
  step 'man sich auf der Modellliste befindet'
  step 'man auf einem Model "Zur Bestellung hinzufügen" wählt'
  step 'öffnet sich der Kalender'
end

Wenn(/^man anhand der Sprungtaste zum aktuellen Startdatum springt$/) do
  find(".fc-button-next").click
  find("#jump-to-start-date").click
end

Dann(/^wird das Startdatum im Kalender angezeigt$/) do
  start_date = Date.parse(find("#booking-calendar-start-date").value).to_s(:db)
  find(".fc-widget-content.start-date[data-date='#{start_date}']")
end

Wenn(/^man anhand der Sprungtaste zum aktuellen Enddatum springt$/) do
  find(".fc-button-next").click
  find("#jump-to-end-date").click
end

Dann(/^wird das Enddatum im Kalender angezeigt$/) do
  end_date = Date.parse(find("#booking-calendar-end-date").value).to_s(:db)
  find(".fc-widget-content.end-date[data-date='#{end_date}']")
end

Wenn(/^man zwischen den Monaten hin und herspring$/) do
  find(".fc-button-next").click
end

Dann(/^wird der Kalender gemäss aktuell gewähltem Monat angezeigt$/) do
  find(".fc-header-title", text: I18n.l(Date.today.next_month, format: "%B %Y"))
end

Dann(/^werden die Schliesstage gemäss gewähltem Gerätepark angezeigt$/) do
  within "#booking-calendar-inventory-pool" do
    expect(has_selector?("option")).to be true
    @inventory_pool = InventoryPool.find all("option").detect{|o| o.selected?}["data-id"]
  end
  @holiday = @inventory_pool.holidays.first
  holiday_not_found = all(".fc-day-content", :text => @holiday.name).empty?
  while holiday_not_found do
    find(".fc-button-next").click
    holiday_not_found = all(".fc-day-content", :text => @holiday.name).empty?
  end
end

Wenn(/^man ein Start und Enddatum ändert$/) do
  ip = get_selected_inventory_pool
  @start = ip.next_open_date(Date.today)
  @end = ip.next_open_date(@start)
  step "I set the start date in the calendar to '#{I18n.l(@start)}'"
  step "ich setze das Enddatum im Kalendar auf '#{I18n.l(@end)}'"
end

Dann(/^wird die Verfügbarkeit des Gegenstandes aktualisiert$/) do
  (@start..@end).each do |date|
    date_el = get_fullcalendar_day_element date
    expect(date_el.native.attribute("class")).to include "available"
    expect(date_el.native.attribute("class")).to include "selected"
  end
end

Wenn(/^man die Anzahl ändert$/) do
  step 'ich setze die Anzahl im Kalendar auf 2'  
end

Dann(/^sind nur diejenigen Geräteparks auswählbar, welche über Kapizäteten für das ausgewählte Modell verfügen$/) do
  @inventory_pools = @model.inventory_pools.reject {|ip| @model.total_borrowable_items_for_user(@current_user, ip) <= 0 }
  within "#booking-calendar-inventory-pool" do
    all("option").each do |option|
      expect(@inventory_pools.include?(InventoryPool.find(option["data-id"]))).to be true
    end
  end
end

Dann(/^die Geräteparks sind alphabetisch sortiert$/) do
  within "#booking-calendar-inventory-pool" do
    expect(has_selector?("option")).to be true
    texts = all("option").map(&:text)
    expect(texts).to eq texts.sort
  end
end

Dann(/^wird die maximal ausleihbare Anzahl des ausgewählten Modells angezeigt$/) do
  within "#booking-calendar-inventory-pool" do
    all("option").each do |option|
      inventory_pool = InventoryPool.find(option["data-id"])
      expect(option.text[/#{@model.total_borrowable_items_for_user(@current_user, inventory_pool)}/]).to be
    end
  end
end

Dann(/^man kann maximal die maximal ausleihbare Anzahl eingeben$/) do
  max_quantity = 0
  within "#booking-calendar-inventory-pool" do
    expect(has_selector?("option")).to be true
    inventory_pool = InventoryPool.find(all("option").detect{|o| o.selected?}["data-id"])
    max_quantity = @model.total_borrowable_items_for_user(@current_user, inventory_pool)
  end
  find("#booking-calendar-quantity").set (max_quantity+1).to_s
  expect(find("#booking-calendar-quantity").value).to eq (max_quantity).to_s
end

Wenn(/^man den letzten Gerätepark in der Geräteparkauswahl auswählt$/) do
  @current_inventory_pool = @current_user.inventory_pools.sort.last
  step 'man ein bestimmten Gerätepark in der Geräteparkauswahl auswählt'
end

Wenn(/^man den zweiten Gerätepark in der Geräteparkauswahl auswählt$/) do
  @current_inventory_pool = @current_user.inventory_pools.sort[1]
  step 'man ein bestimmten Gerätepark in der Geräteparkauswahl auswählt'
end

Angenommen(/^man die Geräteparks begrenzt$/) do
  inventory_pool_ids = find("#ip-selector").all(".dropdown-item[data-id]", :visible => false).map{|i| i[:"data-id"]}
  find("#ip-selector").click
  find(:xpath, "(//*[@id='ip-selector']//input)[1]", :visible => true).click
  inventory_pool_ids.shift
  @inventory_pools = inventory_pool_ids.map{|id| InventoryPool.find id}
end

Angenommen(/^man ein Modell welches über alle Geräteparks der begrenzten Liste beziehbar ist zur Bestellung hinzufügt$/) do
  expect(has_selector?(".line[data-id]", :visible => true)).to be true
  all(".line[data-id]").each do |line|
    model = Model.find line["data-id"]
    if @inventory_pools.all?{|ip| ip.models.include?(model)}
      @model = model
    end
  end
  find(:xpath, "(//*[@id='ip-selector']//input)[2]", :visible => true).click
  expect(has_selector?(".line[data-id]", :visible => true)).to be true
  @inventory_pools.shift
  find(".line[data-id='#{@model.id}'] *[data-create-order-line]").click
end

Dann(/^es wird der alphabetisch erste Gerätepark ausgewählt der teil der begrenzten Geräteparks ist$/) do
  expect(find("#booking-calendar-inventory-pool").value.split(" ")[0]).to eq @inventory_pools.first.name
end

Wenn(/^ein Modell existiert, welches nur einer Gruppe vorbehalten ist$/) do
  @model = Model.all.detect{|m| m.partitions_with_generals.length > 1 and m.partitions_with_generals.find{|p| p.group_id == nil}.quantity == 0}
  expect(@model.blank?).to be false
  @partition = @model.partitions.sample
end

Dann(/^kann ich dieses Modell ausleihen, wenn ich in dieser Gruppe bin$/) do
  @current_user.groups << Group.find(@partition.group_id)
  visit borrow_model_path(@model)
  find("[data-create-order-line][data-model-id='#{@model.id}']").click
  date = @current_user.inventory_pools.first.next_open_date

  start_date = select_available_not_closed_date(:start, date)
  select_available_not_closed_date(:end, start_date)

  find(".fc-widget-content", :match => :first)
  step "I save the booking calendar"
  expect(find("#current-order-lines").has_content?(@model.name)).to be true
  expect(@current_user.contracts.unsubmitted.flat_map(&:lines).map(&:model).include?(@model)).to be true
end

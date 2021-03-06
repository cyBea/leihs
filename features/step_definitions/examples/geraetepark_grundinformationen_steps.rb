# encoding: utf-8

Wenn(/^ich den Admin\-Bereich betrete$/) do
  click_link _("Admin")
  click_link _("Inventory Pool")
end

Dann(/^kann ich die Gerätepark\-Grundinformationen eingeben$/) do |table|
  # table is a Cucumber::Ast::Table
  @table_raw = table.raw
  @table_raw.flatten.each do |field_name|
    within(".row.padding-inset-s", match: :prefer_exact, text: field_name) do
      if field_name == "Verträge drucken"
        find("input", match: :first).set false
      elsif field_name == "Automatischer Zugriff"
        find("input", match: :first).set true
      else
        find("input,textarea", match: :first).set (field_name == "E-Mail" ? "test@test.ch" : "test")
      end
    end
  end
end

Dann(/^ich kann die angegebenen Grundinformationen speichern$/) do
  @path_before_save = current_path
  click_button _("Save")
end

Dann(/^sind die Informationen aktualisiert$/) do
  @table_raw.flatten.each do |field_name|
    within(".row.padding-inset-s", match: :prefer_exact, text: field_name) do
      if field_name == "Verträge drucken"
        expect(find("input", match: :first).selected?).to be false
      elsif field_name == "Automatischer Zugriff"
        expect(find("input", match: :first).selected?).to be true
      else
        expect(find("input,textarea", match: :first).value).to eq (field_name == "E-Mail" ? "test@test.ch" : "test")
      end
    end
  end
end

Dann(/^ich bleibe auf derselben Ansicht$/) do
  expect(current_path).to eq @path_before_save
end

Dann(/^sehe eine Bestätigung$/) do
  find("#flash .notice", text: _("Inventory pool successfully updated"))
end

Wenn(/^ich die Grundinformationen des Geräteparks abfüllen möchte$/) do
  visit manage_edit_inventory_pool_path(@current_inventory_pool)
end

Dann(/^kann das Gerätepark nicht gespeichert werden$/) do
  click_button _("Save")
  step "ich sehe eine Fehlermeldung"
end

Angenommen(/^ich die folgenden Felder nicht befüllt habe$/) do |table|
  table.raw.flatten.each do |must_field_name|
    find(".row.emboss", match: :prefer_exact, text: must_field_name).find("input,textarea", match: :first).set ""
  end
end

Given(/^I edit my inventory pool settings$/) do
  visit manage_edit_inventory_pool_path(@current_inventory_pool)
end

Wenn(/^ich die Arbeitstage Montag, Dienstag, Mittwoch, Donnerstag, Freitag, Samstag, Sonntag ändere$/) do
  @workdays = {}
  [0,1,2,3,4,5,6].each do |day|
    select = find(".row.emboss", match: :prefer_exact, text: I18n.t('date.day_names')[day]).find("select", match: :first)
    @workdays[day] = rand > 0.5 ? _("Open") : _("Closed")
    select.find("option[label='#{@workdays[day]}']", match: :first).click
  end
end

Dann(/^sind die Arbeitstage gespeichert$/) do
  @workdays.each_pair do |day, status|
    if status == "closed"
      expect(@current_inventory_pool.workday.closed_days.include?(day)).to be true
    elsif status == "open"
      expect(@current_inventory_pool.workday.closed_days.include?(day)).to be false
    end
  end
end

Wenn(/^ich eine oder mehrere Zeitspannen und einen Namen für die Ausleihsschliessung angebe$/) do
  @holidays = []
  [1,5,8].each do |i|
    holiday = {start_date: (Date.today + i), end_date: (Date.today + i*i), name: "Test #{i}"}
    @holidays.push holiday
    fill_in "start_date", :with => I18n.l(holiday[:start_date])
    fill_in "end_date", :with => I18n.l(holiday[:end_date])
    fill_in "name", :with => holiday[:name]
    find(".button[data-add-holiday]").click
  end
end

Dann(/^werden die Ausleihschliessungszeiten gespeichert$/) do
  @holidays.each do |holiday|
    expect(@current_inventory_pool.holidays.where(:start_date => holiday[:start_date], :end_date => holiday[:end_date], :name => holiday[:name]).empty?).to be false
  end
end

Dann(/^ich kann die Ausleihschliessungszeiten wieder löschen$/) do
  holiday = @holidays.last
  find(".row[data-holidays-list] .line", :text => holiday[:name]).find(".button[data-remove-holiday]").click
  step 'ich speichere'
  expect(@current_inventory_pool.holidays.where(:start_date => holiday[:start_date], :end_date => holiday[:end_date], :name => holiday[:name]).empty?).to be true
end

Wenn(/^jedes Pflichtfeld des Geräteparks ist gesetzt$/) do |table|
  table.raw.flatten.each do |field_name|
    expect(find(".row.emboss", match: :prefer_exact, :text => field_name).find("input", match: :first).value.length).to be > 0
  end
end

Wenn(/^ich das gekennzeichnete "(.*?)" des Geräteparks leer lasse$/) do |field_name|
  find(".row.emboss", match: :prefer_exact, :text => field_name).find("input", match: :first).set ""
end

Wenn(/^ich für den Gerätepark die automatische Sperrung von Benutzern mit verspäteten Rückgaben einschalte$/) do
  step %Q(ich "Automatische Sperrung" aktiviere)
end

Dann(/^muss ich einen Sperrgrund angeben$/) do
  fill_in "inventory_pool[automatic_suspension_reason]", with: ""
  step 'ich speichere'
  step 'ich sehe eine Fehlermeldung'
  @reason = Faker::Lorem.sentence
  fill_in "inventory_pool[automatic_suspension_reason]", with: @reason
  step 'ich speichere'
end

Dann(/^ist diese Konfiguration gespeichert$/) do
  expect(has_selector?("#flash .notice")).to be true
  @current_inventory_pool.reload
  step %Q(ist "Automatische Sperrung" aktiviert)
  expect(@current_inventory_pool.automatic_suspension_reason).to eq @reason
end

Wenn(/^ein Benutzer wegen verspäteter Rückgaben automatisch gesperrt wird$/) do
  user_id = ContractLine.by_inventory_pool(@current_inventory_pool).to_take_back.where("end_date < ?", Date.today).pluck(:user_id).uniq.sample
  @user = User.find user_id
  @user.automatic_suspend(@current_inventory_pool)
end

Dann(/^wird er für diesen Gerätepark gesperrt bis zum '(\d+)\.(\d+)\.(\d+)'$/) do |day, month, year|
  @access_right = @user.access_right_for(@current_inventory_pool)
  expect(@access_right.suspended_until).to eq Date.new(year.to_i, month.to_i, day.to_i)
end

Dann(/^der Sperrgrund ist derjenige, der für diesen Park gespeichert ist$/) do
  expect(@access_right.suspended_reason).to eq @reason
end

Wenn(/^ich die aut\. Zuweisung deaktiviere$/) do
  within(".row.padding-inset-s", match: :prefer_exact, text: _("Automatic access")) do
    find("input", match: :first).set false
  end
end

Dann(/^ist die aut\. Zuweisung deaktiviert$/) do
  expect(@current_inventory_pool.reload.automatic_access).to be false
end

Angenommen(/^man ist ein Benutzer, der sich zum ersten Mal einloggt$/) do
  @username = Faker::Internet.user_name
  @password = Faker::Internet.password
  step %Q(ich einen Benutzer mit Login "#{@username}" und Passwort "#{@password}" erstellt habe)
end

Given(/^I edit an inventory pool( which has the automatic access enabled)?$/) do |arg1|
  if arg1
    @current_inventory_pool = @current_user.managed_inventory_pools.select{|ip| ip.automatic_access? }.sample
  end
  visit manage_edit_inventory_pool_path(@current_inventory_pool)
  @last_edited_inventory_pool = @current_inventory_pool
end

Angenommen(/^es ist bei mehreren Geräteparks aut. Zuweisung aktiviert$/) do
  InventoryPool.all.sample(rand(2..4)).each do |inventory_pool|
    inventory_pool.update_attributes automatic_access: true
  end
  if inventory_pool = @current_user.managed_inventory_pools.select{|ip| not ip.automatic_access? }.sample
    inventory_pool.update_attributes automatic_access: true
  end
  @inventory_pools_with_automatic_access = InventoryPool.where(automatic_access: true)
  expect(@inventory_pools_with_automatic_access.count).to be > 1
end

Angenommen(/^es ist bei meinem Gerätepark aut. Zuweisung aktiviert$/) do
  @current_inventory_pool.update_attributes automatic_access: true
  @inventory_pools_with_automatic_access = InventoryPool.where(automatic_access: true)
  expect(@inventory_pools_with_automatic_access.count).to be > 1
end

Dann(/^kriegt der neu erstellte Benutzer bei allen Geräteparks mit aut. Zuweisung die Rolle 'Kunde'$/) do
  expect(@user.access_rights.count).to eq @inventory_pools_with_automatic_access.count
  expect(@user.access_rights.pluck(:inventory_pool_id)).to eq @inventory_pools_with_automatic_access.pluck(:id)
  expect(@user.access_rights.all? {|ar| ar.role == :customer}).to be true
end

Wenn(/^ich in meinem Gerätepark einen neuen Benutzer mit Rolle 'Inventar\-Verwalter' erstelle$/) do
  steps %Q{
    Wenn man in der Benutzeransicht ist
    Und man einen Benutzer hinzufügt
    Und die folgenden Informationen eingibt
      | Nachname       |
      | Vorname        |
      | E-Mail         |
    Und man gibt die Login-Daten ein
    Und man gibt eine Badge-Id ein
    Und eine der folgenden Rollen auswählt
      | tab                | role              |
      | Inventar-Verwalter | inventory_manager   |
    Und ich speichere
  }
  @user = User.find_by_lastname "test"
end

Dann(/^kriegt der neu erstellte Benutzer bei allen Geräteparks mit aut\. Zuweisung ausser meinem die Rolle 'Kunde'$/) do
  expect(@user.access_rights.count).to eq @inventory_pools_with_automatic_access.count
  expect(@user.access_rights.pluck(:inventory_pool_id)).to eq @inventory_pools_with_automatic_access.pluck(:id)
  expect(@user.access_rights.where("inventory_pool_id != ?", @current_inventory_pool ).all? {|ar| ar.role == :customer}).to be true
end

Dann(/^in meinem Gerätepark hat er die Rolle 'Inventar\-Verwalter'$/) do
  expect(@user.access_right_for(@current_inventory_pool).role).to eq :inventory_manager
end

Dann(/^kriegt der neu erstellte Benutzer bei dem vorher editierten Gerätepark kein Zugriffsrecht$/) do
  expect(@user.access_right_for(@last_edited_inventory_pool)).to eq nil
end

When(/^on the inventory pool I enable the automatic suspension for users with overdue take backs$/) do
  @current_inventory_pool.update_attributes(automatic_suspension: true, automatic_suspension_reason: Faker::Lorem.paragraph)
end

When(/^a user is already suspended for this inventory pool$/) do
  @user = @current_inventory_pool.visits.take_back_overdue.sample.user
  @suspended_until = rand(1.years.from_now..3.years.from_now).to_date
  @suspended_reason = Faker::Lorem.paragraph

  ensure_suspended_user(@user, @current_inventory_pool, @suspended_until, @suspended_reason)
end

Then(/^the existing suspension motivation and the suspended time for this user are not overwritten$/) do
  def checks_suspension
    ar = @user.access_right_for(@current_inventory_pool)
    expect(ar.suspended_until).to eq @suspended_until
    expect(ar.suspended_reason).to eq @suspended_reason
    expect(ar.suspended_reason).not_to eq @current_inventory_pool.automatic_suspension_reason
  end

  checks_suspension
  step "the cronjob executes the rake task for reminding and suspending all late users"
  checks_suspension
end

When(/^I (enable|disable) "(.*)"$/) do |arg1, arg2|
  b = case arg1
        when "enable"
          true
        when "disable"
          false
        else
          raise
      end
  case arg2
    when "Verträge drucken"
      find("input[type='checkbox'][name='inventory_pool[print_contracts]']").set b
    when "Automatische Sperrung"
      find("input[type='checkbox'][name='inventory_pool[automatic_suspension]']").set b
    when "Automatischer Zugriff"
      find("input[type='checkbox'][name='inventory_pool[automatic_access]']").set b
    else
      raise
  end
end

Then(/^"(.*)" is (enabled|disabled)$/) do |arg1, arg2|
  b = case arg2
        when "enabled"
          true
        when "disabled"
          false
        else
          raise
      end
  case arg1
    when "Verträge drucken"
      expect(@current_inventory_pool.reload.print_contracts).to eq b
    when "Automatische Sperrung"
      expect(@current_inventory_pool.reload.automatic_suspension).to eq b
    when "Automatischer Zugriff"
      expect(@current_inventory_pool.reload.automatic_access).to eq b
    else
      raise
  end
end

Then(/^I can change the field "(.*?)"$/) do |arg1|
  case arg1
    when "Min. number of days between order and hand over"
      n = rand(0..14)
      find("input[type='number'][name='inventory_pool[workday_attributes][reservation_advance_days]']").set n
      step "ich speichere"
      find("input[type='number'][name='inventory_pool[workday_attributes][reservation_advance_days]'][value='#{n}']")
    else
      raise
  end
end

Then(/^I can enter the maximum visits per week day$/) do
  h = {}
  (0..6).each do |i|
    h[i] = rand(0..14)
    find("input[type='number'][name='inventory_pool[workday_attributes][workdays][#{i}][max_visits]']").set h[i]
  end
  step "ich speichere"
  (0..6).each do |i|
    find("input[type='number'][name='inventory_pool[workday_attributes][workdays][#{i}][max_visits]'][value='#{h[i]}']")
  end
end

When(/^I do not enter a maximum amount of visits on a week day$/) do
  (0..6).each do |i|
    find("input[type='number'][name='inventory_pool[workday_attributes][workdays][#{i}][max_visits]']").set ""
  end
  step "ich speichere"
end

Then(/^there is no limit of visits for this week day$/) do
  (0..6).each do |i|
    expect(find("input[type='number'][name='inventory_pool[workday_attributes][workdays][#{i}][max_visits]']").value).to be_blank
  end
end

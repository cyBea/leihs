# -*- encoding : utf-8 -*-

#Angenommen(/^man befindet sich auf der Bestellübersicht$/) do
When(/^I am listing my orders$/) do
  visit borrow_current_order_path
end

Dann(/^ich lande auf der Seite der Bestellübersicht$/) do
  expect(current_path).to eq borrow_current_order_path
end

# Dann(/^sehe ich kein Bestellfensterchen$/) do
Then(/^I do not see the order window$/) do
  expect(has_no_selector?(".col1of5 .navigation-tab-item", text: _("Order"))).to be true
end

#Then(/^sehe ich das Bestellfensterchen$/) do
Then(/^I see the order window$/) do
  expect(has_selector?(".col1of5 .navigation-tab-item", text: _("Order"))).to be true
end

#Dann(/^erscheint es im Bestellfensterchen$/) do
Then(/^it appears in the order window$/) do
  visit borrow_root_path
  find("#current-order-basket", match: :first)
end

#Dann(/^die Modelle im Bestellfensterchen sind alphabetisch sortiert$/) do
Then(/^the models in the order window are sorted alphabetically$/) do
  within "#current-order-basket #current-order-lines" do
    @names = all(".line").map{|l| l[:title] }
    expect(@names.sort == @names).to be true
  end
end

#Dann(/^gleiche Modelle werden zusammengefasst$/) do
Then(/^identical models are collapsed$/) do
  expect(@names.uniq == @names).to be true
end

#Wenn(/^das gleiche Modell nochmals hinzugefügt wird$/) do
When(/^I add the same model one more time$/) do
  FactoryGirl.create(:contract_line,
                     :contract => @current_user.get_unsubmitted_contract(@inventory_pool),
                     :model => @new_contract_line.model)
  #step "erscheint es im Bestellfensterchen"
  step "it appears in the order window"
end

#Dann(/^wird die Anzahl dieses Modells erhöht$/) do
Then(/^its quantity is increased$/) do
  within "#current-order-basket #current-order-lines" do
    line = find(".line[title='#{@new_contract_line.model.name}']", match: :first)
    line.find("span", match: :first, text: "2x #{@new_contract_line.model.name}")
  end
end

#Dann(/^ich kann zur detaillierten Bestellübersicht gelangen$/) do
Then(/^I can go to the detailed order overview$/) do
  find("#current-order-basket .button.green", text: _("Complete order"))
end

#Wenn(/^ich mit dem Kalender ein Modell der Bestellung hinzufüge$/) do
When(/^I add a model to the order using the calendar$/) do
  #step 'man sich auf der Modellliste befindet'
  step 'I am listing models'
  #step 'man ein Startdatum auswählt'
  # choosing a start date is already implied in the step below
  #step 'I choose a start date'
  #step 'man auf einem verfügbaren Model "Zur Bestellung hinzufügen" wählt'
  step 'I add an existing model to the order'
  #step 'öffnet sich der Kalender'
  step 'the calendar opens'
  step 'everything I input into the calendar is valid'
end

#Dann(/^wird das Bestellfensterchen aktualisiert$/) do
Then(/^the order window is updated$/) do
  #step 'ist das Modell mit Start- und Enddatum, Anzahl und Gerätepark der Bestellung hinzugefügt worden'
  step 'the model has been added to the order with the respective start and end date, quantity and inventory pool'
  #step "erscheint es im Bestellfensterchen"
  step 'it appears in the order window'
  find("#current-order-basket #current-order-lines .line[title='#{@model.name}']", match: :first, text: "#{@quantity}x #{@model.name}")
end

Angenommen(/^meine Bestellung ist leer$/) do
  # NOTE removing contracts already generated on the dataset
  @current_user.contracts.unsubmitted.map(&:destroy)

  expect(@current_user.contracts.unsubmitted.flat_map(&:lines).empty?).to be true
end

Dann(/^sehe ich keine Zeitanzeige$/) do
  expect(has_no_selector?("#current-order-basket #timeout-countdown")).to be true
end

#Dann(/^sehe ich die Zeitanzeige$/) do
Then(/^I see a timer$/) do
  step "I visit the homepage"
  expect(has_selector?("#current-order-basket #timeout-countdown", :visible => true)).to be true
  @timeoutStart = if @current_user.contracts.unsubmitted.empty?
                    Time.now
                  else
                    @current_user.contracts.unsubmitted.sample.updated_at
                  end
  @countdown = find("#timeout-countdown-time", match: :first).text
end

Dann(/^die Zeitanzeige ist in einer Schaltfläche im Reiter "Bestellung" auf der rechten Seite$/) do
  find("#current-order-basket .navigation-tab-item #timeout-countdown #timeout-countdown-time", match: :first)
end

Dann(/^die Zeitanzeige zählt von (\d+) Minuten herunter$/) do |timeout_minutes|
  @countdown = find("#timeout-countdown-time", match: :first).text
  minutes = @countdown.split(":")[0].to_i
  seconds = @countdown.split(":")[1].to_i
  sleep(1) # NOTE this sleep is required in order to test the countdown
  expect(Contract::TIMEOUT_MINUTES - 1).to be <= minutes
  expect(find("#timeout-countdown-time", match: :first).reload.text.split(":")[1].to_i).to be < seconds
end

Angenommen(/^die Bestellung ist nicht leer$/) do
  step 'ich ein Modell der Bestellung hinzufüge'
end

Wenn(/^ich den Time-Out zurücksetze$/) do
  @countdown = find("#timeout-countdown-time", match: :first).text
  find("#timeout-countdown-refresh", match: :first).click
end

Dann(/^wird die Zeit zurückgesetzt$/) do
  seconds = @countdown.split(":")[1].to_i
  secondsNow = find("#timeout-countdown-time", match: :first).reload.text.split(":")[1].to_i
  expect(secondsNow).to be >= seconds
end

Wenn(/^die Zeit abgelaufen ist$/) do
  Contract::TIMEOUT_MINUTES = 1
  step 'ich ein Modell der Bestellung hinzufüge'
  step 'sehe ich die Zeitanzeige'
  sleep(70) # NOTE this sleep is required to test the timeout
end

Dann(/^werde ich auf die Timeout Page weitergeleitet$/) do
  step "ich sehe eine Information, dass die Geräte nicht mehr reserviert sind"
  expect(current_path).to eq borrow_order_timed_out_path
end

#Wenn(/^die Zeit überschritten ist$/) do
When(/^time has run out$/) do
  past_date = Time.now - (Contract::TIMEOUT_MINUTES + 1).minutes
  @current_user.contracts.unsubmitted.each do |contract|
    contract.update_attribute :updated_at, past_date
  end
  page.execute_script %Q{ localStorage.currentTimeout = moment("#{past_date.to_s}").toDate() }
end

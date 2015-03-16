# -*- encoding : utf-8 -*-

#Angenommen(/^ich habe eine offene Bestellung mit Modellen$/) do
Given(/^I have an unsubmitted order with models$/) do
  expect(@current_user.contracts.unsubmitted.count).to eq 1
end

#Angenommen(/^die Bestellung Timeout ist (\d+) Minuten$/) do |arg1|
Given(/^the contract timeout is set to (\d+) minutes$/) do |arg1|
  expect(Contract::TIMEOUT_MINUTES).to eq arg1.to_i
end

#######################################################################

#Wenn(/^ich ein Modell der Bestellung hinzufüge$/) do
When(/^I add a model to an order$/) do
  @inventory_pool = @current_user.inventory_pools.first # OPTIMIZE
  contract = @current_user.get_unsubmitted_contract(@inventory_pool)
  @new_contract_line = FactoryGirl.create(:contract_line, :contract => contract)
  contract.contract_lines << @new_contract_line
  expect(@new_contract_line.reload.available?).to be true
end

#Wenn(/^ich dasselbe Modell einer Bestellung hinzufüge$/) do
When(/^I add the same model to an order$/) do
  contract = @inventory_pool.contracts.submitted.order("RAND()").first
  (@new_contract_line.maximum_available_quantity + 1).times do
    contract.contract_lines << FactoryGirl.create(:contract_line,
                                                  :contract => contract,
                                                  :start_date => @new_contract_line.start_date,
                                                  :end_date => @new_contract_line.end_date,
                                                  :model_id => @new_contract_line.model_id)
  end
end

#Wenn(/^die maximale Anzahl der Gegenstände überschritten ist$/) do
When(/^the maximum quantity of items is exhausted$/) do
  expect(@new_contract_line.reload.available?).to be false
end

#Dann(/^wird die Bestellung nicht abgeschlossen$/) do
Then(/^the order is not submitted$/) do
  @current_user.contracts.unsubmitted.each do |contract|
    expect(contract.status).to eq :unsubmitted
  end
end

#Dann(/^ich erhalte eine Fehlermeldung$/) do
#  step "I see an error message"
#end

#######################################################################

#Wenn(/^ich länger als (\d+) Minuten keine Aktivität ausgeführt habe$/) do |arg1|
When(/^I have performed no activity for more than (\d+) minutes$/) do |arg1|
  @current_user.contracts.unsubmitted.each do |contract|
    contract.update_attributes updated_at: Time.now - (arg1.to_i + 1).minutes if (Time.now - contract.updated_at) <= arg1.to_i.minutes
  end
end

#Angenommen(/^(ein|\d+) Modelle? (?:ist|sind) nicht verfügbar$/) do |n|
Given(/^(a|\d+) model(?:s)? (?:is|are) not available$/) do |n|
  n = case n
        when "a"
          1
        else
          n.to_i
      end

  lines = @current_user.contracts.unsubmitted.flat_map(&:lines)
  available_lines, unavailable_lines = lines.partition {|line| line.available? }

  available_lines.take(n - unavailable_lines.size).each do |line|
    (line.maximum_available_quantity + 1).times do
      c = FactoryGirl.create(:contract,
                             :status => :submitted,
                             :inventory_pool => line.inventory_pool)
      FactoryGirl.create(:item_line,
                         :contract => c,
                         :model => line.model,
                         :start_date => line.start_date,
                         :end_date => line.end_date)
    end
  end
  expect(@current_user.contracts.unsubmitted.flat_map(&:lines).select{|line| not line.available?}.size).to eq n
end

#Wenn(/^ich eine Aktivität ausführe$/) do
When(/^I perform some activity$/) do
  visit borrow_root_path
end

#Dann(/^werde ich auf die Timeout Page geleitet$/) do
Then(/^I am redirected to the timeout page$/) do
  expect(current_path).to eq borrow_order_timed_out_path
end

#######################################################################

#Dann(/^werden die Modelle meiner Bestellung freigegeben$/) do
#Dann(/^bleiben die Modelle in der Bestellung blockiert$/) do
Then(/^the models in my order (are released|remain blocked)$/) do |arg1|
  expect(@current_user.contracts.unsubmitted.flat_map(&:lines).all? { |line|
           case arg1
             when "are released"
               line.inventory_pool.running_lines.detect { |l| l.id == line.id }
             when "remain blocked"
               not line.inventory_pool.running_lines.detect { |l| l.id == line.id }
           end
         }).to be true
end

#######################################################################

#Angenommen(/^alle Modelle verfügbar sind$/) do
Given(/^all models are available$/) do
  expect(@current_user.contracts.unsubmitted.flat_map(&:lines).all? {|line| line.available? }).to be true
end

#Dann(/^kann man sein Prozess fortsetzen$/) do
Then(/^I can continue my order process$/) do
  expect(current_path).to eq borrow_root_path
end

#Dann(/^die Modelle werden blockiert$/) do
#  step "bleiben die Modelle in der Bestellung blockiert"
#end

#Wenn(/^eine Rücknahme nur Optionen enthält$/) do
When(/^a take back contains only options$/) do
  @current_inventory_pool = @current_user.inventory_pools.where("access_rights.suspended_until IS NULL OR access_rights.suspended_until < ?", Date.today).first
  expect(@customer = @current_inventory_pool.users.find{|u| u.visits.take_back.count == 0}).to be
  step "I open a hand over for this customer"
  step 'I add an option to the hand over by providing an inventory code and a date range'
  step 'the option is added to the hand over'
  step 'I click hand over'
  find('#purpose').set 'text'
  step 'I click hand over inside the dialog'
  visit manage_take_back_path @current_inventory_pool, @customer
end

#Dann(/^wird für diese Optionen keine Verfügbarkeit berechnet$/) do
Then(/^no availability will be computed for these options$/) do
  expect(find('#status').has_content? _('Availability loaded')).to be true
end

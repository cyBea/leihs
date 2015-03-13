# -*- encoding : utf-8 -*-

Given(/^I am ([a-zA-Z]*)$/) do |persona_name|
  step 'I am logged in as "%s"' % persona_name
  case persona_name
    when "Andi"
      step "I am in an inventory pool with verifiable orders"
    else
      @current_inventory_pool = @current_user.inventory_pools.managed.first
  end
end

# Angenommen(/^man ist ein Kunde$/) do
#   user = AccessRight.where(role: :customer).map(&:user).uniq.sample
#   step "I am %s" % user.firstname
# end

#Angenommen(/^man ist ein Kunde mit Verträge$/) do
Given(/^I am a customer with contracts$/) do
  user = Contract.where(status: [:signed, :closed]).order("RAND()").select{|c| c.lines.any? &:returned_to_user}.map(&:user).select{|u| not u.access_rights.active.blank?}.uniq.first
  step %Q(I am logged in as '#{user.login}' with password 'password')
end

When(/^I am in an inventory pool with verifiable orders$/) do
  @current_inventory_pool = @current_user.inventory_pools.managed.find {|ip| not ip.contracts.with_verifiable_user_and_model.empty? }
end

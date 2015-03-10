# encoding: utf-8

#Wenn(/^ich ein ergänzendes Modell mittel Autocomplete Feld hinzufüge$/) do
When(/^I use the autocomplete field to add a compatible model$/) do
  @comp1 = Model.find_by_name("Sharp Beamer 123")
  @comp2 = Model.find_by_name("Kamera Stativ 123")
  fill_in_autocomplete_field _("Compatibles"), @comp1.name
  fill_in_autocomplete_field _("Compatibles"), @comp2.name
end

#Dann(/^ist dem Modell das ergänzende Modell hinzugefügt worden$/) do
Then(/^a compatible model has been added to the model I am editing$/) do
  find("#flash")
  expect(@model.compatibles.size).to be 2
  expect(@model.compatibles.any? {|m| m.name == @comp1.name}).to be true
  expect(@model.compatibles.any? {|m| m.name == @comp2.name}).to be true
end

#Wenn(/^ich ein Modell öffne, das bereits ergänzende Modelle hat$/) do
When(/^I open a model that already has compatible models$/) do
  @model = @current_inventory_pool.models.select {|m| m.compatibles.exists? }.sample

  @model ||= begin
    @current_inventory_pool = @current_user.managed_inventory_pools.select {|ip| not ip.models.empty? and ip.models.any? {|m| m.compatibles.exists?} }.sample
    step "I open the inventory"
    @current_inventory_pool.models.select {|m| m.compatibles.exists? }.sample
  end

  step 'I search for "%s"' % @model.name
  find(".line", match: :first, text: @model.name).find(".button", text: _("Edit Model")).click
end

#Wenn(/^ich ein ergänzendes Modell entferne$/) do
When(/^I remove a compatible model$/) do
  find(".field", match: :first, text: _("Compatibles")).all("[data-remove]").each {|comp| comp.click}
end

#Dann(/^ist das Modell ohne das gelöschte ergänzende Modell gespeichert$/) do
Then(/^the model is saved without the compatible model that I removed$/) do
  find("#flash")
  expect(@model.reload.compatibles.empty?).to be true
end

#Wenn(/^ich ein bereits bestehendes ergänzende Modell mittel Autocomplete Feld hinzufüge$/) do
When(/^I add an already existing compatible model using the autocomplete field$/) do
  @comp = @model.compatibles.first
  fill_in_autocomplete_field _("Compatibles"), @comp.name
end

#Dann(/^wurde das redundante Modell nicht hizugefügt$/) do
Then(/^the redundant model was not added$/) do
  within(".row.emboss", match: :first, text: _("Compatibles")) do
    find("[data-type='inline-entry']", text: @comp.name)
  end
end

#Dann(/^wurde das redundante ergänzende Modell nicht gespeichert$/) do
Then(/^the redundant compatible model was not added to this one$/) do
  find("#flash")
  comp_before = @model.compatibles
  expect(comp_before.count).to eq @model.reload.compatibles.count
end

#Angenommen(/^es existiert eine? (.+) mit folgenden Konditionen:$/) do |entity, table|
Given(/^there is a? (.+) with the following conditions:$/) do |entity, table|
  conditions = table.raw.flatten.map do |condition|
    case condition
      when "not in any contract", "not in any order"
        lambda {|m| m.contract_lines.empty?}
      when "no items assigned"
        lambda {|m| m.items.items.empty?}
      when "has no licenses"
        lambda {|m| m.items.licenses.empty?}
      when "has group capacities"
        lambda {|m| Partition.find_by_model_id(m.id)}
      when "has properties"
        lambda {|m| not m.properties.empty?}
      when "has accessories"
        lambda {|m| not m.accessories.empty?}
      when "has images"
        lambda {|m| not m.images.empty?}
      when "has attachments"
        lambda {|m| not m.attachments.empty?}
      when "is assigned to categories"
        lambda {|m| not m.categories.empty?}
      when "has compatible models"
        lambda {|m| not m.compatibles.empty?}
      else
        false
    end
  end
  klass = case entity
          when "model" then Model
          when "software" then Software
          end
  @model = klass.find {|m| conditions.map{|c| c.class == Proc ? c.call(m) : c}.all?}
  expect(@model).not_to be_nil
end

#Und /^das Modell hat (.+) zugewiesen$/ do |assoc|
Given /^the model has an assigned (.+)$/ do |assoc|
  @model = @current_inventory_pool.models.find do |m|
    case assoc
      when "contract", "order"
        not m.contract_lines.empty?
      when "item"
        not m.items.empty?
    end
  end
end

#Dann(/^kann ich das Modell aus der Liste nicht löschen$/) do
Then(/^I cannot delete the model from the list$/) do
  fill_in 'list-search', with: @model.name
  within(".line[data-id='#{@model.id}']") do
    find(".dropdown-holder").click
    expect(has_no_selector?("[data-method='delete']")).to be true
  end
  @model.reload # is still there
end

Und /^ich sehe eine Dialog-Fehlermeldung$/ do
  expect(find(".flash_message").text.empty?).to be false
end

#Dann(/^es wurden auch alle Anhängsel gelöscht$/) do
Then(/^all associations have been deleted as well$/) do
  expect(Partition.find_by_model_id(@model.id)).to eq nil
  expect(Property.where(model_id: @model.id).empty?).to be true
  expect(Accessory.where(model_id: @model.id).empty?).to be true
  expect(Image.where(target_id: @model.id).empty?).to be true
  expect(Attachment.where(model_id: @model.id).empty?).to be true
  expect(ModelLink.where(model_id: @model.id).empty?).to be true
  expect(Model.all {|n| n.compatibles.include? Model.find_by_name("Windows Laptop")}.include?(@model)).to be false
end

#Dann(/^(?:die|das) (?:.+) wurde aus der Liste gelöscht$/) do
Then(/^the (?:.+) was deleted from the list$/) do
  [@model, @group, @template].compact.each {|entity|
    expect(has_no_content?(entity.name)).to be true
  }
end

#Angenommen(/^ich editieren ein bestehndes Modell mit bereits zugeteilten Kapazitäten$/) do
Given(/^I edit a model that exists and has group capacities allocated to it$/) do
  @model = @current_inventory_pool.models.find{|m| m.partitions.count > 0}
  visit manage_edit_model_path(@current_inventory_pool, @model)
end

#Wenn(/^ich bestehende Zuteilungen entfernen$/) do
When(/^I remove existing allocations$/) do
  find(".field", match: :first, text: _("Allocations")).all("[data-remove]").each {|comp| comp.click}
end

#Wenn(/^neue Zuteilungen hinzufügen$/) do
When(/^I add new allocations$/) do
  @groups = @current_inventory_pool.groups - @model.partitions.map(&:group)

  @groups.each do |group|
    fill_in_autocomplete_field _("Allocations"), group.name
  end
end

#Dann(/^sind die geänderten Gruppenzuteilungen gespeichert$/) do
Then(/^the changed allocations are saved$/) do
  find("#flash")
  model_group_ids = @model.reload.partitions.map(&:group_id)
  expect(model_group_ids.sort).to eq @groups.map(&:id)
end

#Dann /^ist das neue Modell erstellt und unter ungenutzen Modellen auffindbar$/ do
Then /^the new model is created and can be found in the list of unused models$/ do
  find(:select, "retired").first("option").select_option
  select _("not used"), from: "used"
  step "the information is saved"
end

#Wenn(/^ich ein bestehendes, genutztes Modell bearbeite$/) do
When(/^I edit a model that exists and is in use$/) do
  @page_to_return = current_path
  @model = @current_inventory_pool.items.items.unretired.where(parent_id: nil).order("RAND()").first.model
  visit manage_edit_model_path @current_inventory_pool, @model
end

When(/^I delete this (.+) from the list$/) do |entity|
  step "I open the inventory"
  step "I see retired and not retired inventory"

  fill_in 'list-search', with: @model.name

  case entity
  when "model"
    find("[data-type='item']", text: _("Models")).click
  when "software"
    find("[data-type='license']", text: _("Software")).click
    find(:select, "retired").first("option").select_option
  end

  within(".line[data-id='#{@model.id}']") do
    find(".dropdown-holder").click
    find("[data-method='delete']").click
  end
end

Then(/^the (.+) is deleted$/) do |entity|
  find("#flash")
  klass = case entity
          when "model" then Model
          when "software" then Software
          end
  expect(klass.find_by_id(@model.id)).to eq nil
end


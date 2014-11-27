# -*- encoding : utf-8 -*-

Wenn /^einem Gegenstand einen Inventarcode manuell zuweise$/ do
  step 'I click an inventory code input field of an item line'
  step 'I select one of those'
end


Wenn(/^ich einen Gegenstand zurücknehme$/) do
  step 'I open a take back'
  step 'I select all lines of an open contract'
  step 'I click take back'
  step 'I see a summary of the things I selected for take back'
  step 'I click take back inside the dialog'
  step 'the contract is closed and all items are returned'
end

Given /^I open a contract during take back$/ do
  step 'I open a take back'
  step 'I select all lines of an open contract'
  step 'I click take back'
  step 'I click take back inside the dialog'
end


Angenommen /^man öffnet einen Vertrag bei der Rücknahme/ do
  step 'I open a take back'
  step 'I select all lines of an open contract'
  step 'I click take back'
  step 'I click take back inside the dialog'
end

Wenn /^einige der ausgewählten Gegenstände hat keinen Zweck angegeben$/ do
  step 'I click an inventory code input field of an item line'
  step 'I select one of those'
  step 'I add an item to the hand over by providing an inventory code'
  step 'I add an option to the hand over by providing an inventory code and a date range'
end

Dann(/^kann man als "(.+)" keine, eine oder mehrere der folgenden Möglichkeiten in Form einer Checkbox auswählen:$/) do |arg, table|
  step %Q(one is able to choose for "#{arg}" none, one or more of the following options if form of a checkbox:), table
end

Dann(/^kann man als "(.*?)" einen der folgenden Möglichkeiten anhand eines Radio\-Buttons wählen:$/) do |arg1, table|
  step %Q(for "#{arg1}" one can select one of the following options with the help of radio button), table
end

Dann(/^kann man als "(.*?)" ein Datum auswählen$/) do |arg1|
  step %Q(for "#{arg1}" one can select a date)
end

Dann(/^kann man als "(.*?)" eine Zahl eingeben$/) do |arg1|
  step %Q(for "#{arg1}" one can enter a number)
end

Dann(/^kann man als "(.*?)" einen Text eingeben$/) do |arg1|
  step %Q(for "#{arg1}" one can enter some text)
end

Dann(/^kann man als "(.*?)" einen Lieferanten auswählen$/) do |arg1|
  step %Q(for "#{arg1}" one can select a supplier)
end

Dann(/^kann man als "(.*?)" einen Gerätepark auswählen$/) do |arg1|
  step %Q(for "#{arg1}" one can select an inventory pool)
end

Wenn(/^ich als Maintenance\-Vertrag "(.*?)" auswähle$/) do |arg1|
  step %Q(I choose "#{arg1}" for maintenance contract)
end

Wenn(/^ich als Bezug "(.*?)" wähle$/) do |arg1|
  step %Q(I choose "#{arg1}" as reference)
end

Angenommen(/^es existiert ein(e)? (.*) mit folgenden Eigenschaften:$/) do |arg0, arg1, table|
  s = case arg1
        when "Modell"
          "model"
        when "Gegenstand"
          "item"
        when "Software-Produkt"
          "software product"
        when "Software-Lizenz"
          "software license"
        else
          raise
      end
  step "there is a #{s} with the following properties:", table
end

Wenn(/^ich (im Inventarbereich )?nach einer dieser (.*)?Eigenschaften suche$/) do |arg1, arg2|
  s1 = "in inventory "
  s2 = case arg2
         when "Software-Produkt "
           "software product "
         when "Software-Lizenz "
           "software license "
         else
           ""
       end
  step "I search #{s1}after one of those #{s2}properties"
end

Wenn(/^ich (im Inventarbereich )?nach den folgenden Eigenschaften suche$/) do |arg1, table|
  s1 = "in inventory "
  step "I search #{s1}after following properties", table
end

Dann(/^es erscheinen alle zutreffenden (.*)$/) do |arg1|
  s = case arg1
        when "Modelle"
          "models"
        when "Gegenstände"
          "items"
        when "Paket-Modelle"
          "package models"
        when "Paket-Gegenstände"
          "package items"
        when "Software-Produkte"
          "software products"
        when "Software-Lizenzen"
          "software licenses"
        when "Verträge, in denen diese Software-Produkt vorkommt"
          "contracts, in which this software product is contained"
        else
          raise
      end
  step "they appear all matched %s" % s
end

Wenn(/^ich im Feld "(.*?)" den Wert "(.*?)" eingebe$/) do |field, value|
  step %Q(I fill in the field "#{field}" with the value "#{value}")
end

Dann(/^ist der "(.*?)" als "(.*?)" gespeichert$/) do |arg1, arg2|
  step %Q("#{arg1}" is saved as "#{arg2}")
end

Wenn(/^ich bei der Option eine Stückzahl von (\d+) eingebe$/) do |n|
  step "I set a quantity of #{n} for the option line"
end

Wenn(/^ich setze "(.*?)" auf "(.*?)"$/) do |arg1, arg2|
  step %Q(I set "#{arg1}" to "#{arg2}")
end

Wenn(/^ich die Anzahl "(.*?)" in das Mengenfeld schreibe$/) do |arg1|
  step "I change the quantity to \"%s\"" % arg1
end

Dann(/^wird die Menge mit dem Wert "(.*?)" gespeichert$/) do |arg1|
  step "the quantity will be stored to the value \"%s\"" % arg1
end

Angenommen /^ich erstelle eine? neues? (?:.+) oder ich ändere eine? bestehendes? (.+)$/ do |entity|
  step "ich add a new #{entity} or I change an existing #{entity}"
end

Wenn(/^ich dieses? "(.+)" aus der Liste lösche$/) do |entity|
  step %Q(I delete this #{entity} from the list)
end

Dann(/^(?:die|das) "(.+)" ist gelöscht$/) do |entity|
  step %Q(the "#{entity}" is deleted)
end

Angenommen(/^man editiert das Feld "(.*?)" eines ausgeliehenen Gegenstandes, wo man Besitzer ist$/) do |arg1|
  step %Q(one edits the field "#{arg1}" of an owned item not in stock)
end

#Angenommen(/^ich editiere eine Gerätepark( bei dem die aut. Zuweisung aktiviert ist)?$/) do |arg1|
#  step "I edit an inventory pool%s" % (arg1 ? " which has automatic access enabled" : nil)

Wenn(/^ich "(.*)" aktiviere$/) do |arg1|
  step %Q(I enable "%s") % arg1
end

Dann(/^ist "(.*)" aktiviert$/) do |arg1|
  step %Q("%s" is enabled) % arg1
end

Wenn(/^ich "(.*)" deaktiviere$/) do |arg1|
  step %Q(I disable "%s") % arg1
end

Dann(/^ist "(.*)" deaktiviert$/) do |arg1|
  step %Q("%s" is disabled) % arg1
end

Angenommen(/^eine Software\-Produkt mit mehr als (\d+) Zeilen Text im Feld "(.*?)" existiert$/) do |arg1, arg2|
  step %Q(a software product with more than %d text rows in field "%s" exists) % [arg1, arg2]
end

Wenn(/^man öffnet (eine|die) Rüstliste( für einen unterschriebenen Vertrag)?$/) do |arg1, arg2|
  s1 = case arg1
         when "eine"
           "a"
         when "die"
           "the"
       end
  s2 = arg2 ? " for a signed contract" : ""
  step "I open %s picking list%s" % [s1, s2]
end

Wenn(/^ich mich im Verleih im Reiter (aller|der offenen|der geschlossenen) Verträge befinde$/) do |arg1|
  s = case arg1
        when "aller"
          "all"
        when "der offenen"
          "open"
        when "der geschlossenen"
          "closed"
      end
  step "I visit the lending section on the list of %s contracts" % s
end

Wenn(/^ich sehe mindestens (eine Bestellung|einen Vertrag)$/) do |arg1|
  case arg1
    when "einen Vertrag"
      step "I see at least a contract"
    when "eine Bestellung"
      step "I see at least an order"
  end
end

Dann(/^kann ich die Rüstliste auf den jeweiligen (Bestell|Vertrags)\-Zeilen öffnen$/) do |arg1|
  s = case arg1
        when "Bestell"
          "order"
        when "Vertrags"
          "contract"
      end
  step "I can open the picking list of any %s line" % s
end

Dann(/^sind die Listen zuerst nach (Ausleihdatum|Rückgabedatum) sortiert$/) do |arg1|
  s = case arg1
        when "Ausleihdatum"
          "hand over"
        when "Rückgabedatum"
          "take back"
        else
          raise
      end
  step "the lists are sorted by %s date" % s
end

Dann(/^Gegenständen kein Raum oder Gestell zugeteilt sind, wird (die verfügbare Anzahl für den Kunden und )?"(.*?)" angezeigt$/) do |arg1, arg2|
  s1 = arg1 ? "the available quantity for this customer and " : nil
  s2 = case arg2
         when "x Ort nicht definiert"
           "x %s" % _("Location not defined")
         when "Ort nicht definiert"
           _("Location not defined")
         else
           raise
       end
  step %Q(the items without location, are displayed with #{s1}"#{s2}")
end

Dann(/^fehlende Rauminformationen bei Optionen werden als "(.*?)" angezeigt$/) do |arg1|
  s = case arg1
        when "Ort nicht definiert"
          _("Location not defined")
        else
          raise
      end
  step %Q(the missing location information for options, are displayed with "#{s}")
end

Dann(/^kann man auf ein der "(.*)" Tab klichen$/) do |arg1|
  s1 = case arg1
         when "Bestellungen"
           "Orders"
         when "Verträge"
           "Contracts"
         else
           raise
       end

  step %Q(I open the tab "#{s1}")
end

Angenommen(/^es existieren (Bestellungen|Verträge|Besuche)$/) do |arg1|
  s = case arg1
        when "Bestellungen"
          "orders"
        when "Verträge"
          "contracts"
        when "Besuche"
          "visits"
        else
          raise
      end
  step "%s exist" % s
end

Wenn(/^ich mich auf der Liste der (Bestellungen|Verträge|Besuche) befinde$/) do |arg1|
  s = case arg1
        when "Bestellungen"
          "orders"
        when "Verträge"
          "contracts"
        when "Besuche"
          "visits"
        else
          raise
      end
  step "I am listing the %s" % s

end

Wenn(/^ich nach (einer Bestellung|einem Vertrag|einem Besuch) suche$/) do |arg1|
  s = case arg1
        when "einer Bestellung"
          "an order"
        when "einem Vertrag"
          "a contract"
        when "einem Besuch"
          "a visit"
        else
          raise
      end
  step "I search for %s" % s
end

Dann(/^werden mir alle (Bestellungen|Verträge|Besuche) aufgeführt, die zu meinem Suchbegriff passen$/) do |arg1|
  s = case arg1
        when "Bestellungen"
          "orders"
        when "Verträge"
          "contracts"
        when "Besuche"
          "visits"
        else
          raise
      end
  step "all listed %s, are matched by the search term" % s
end

Dann(/^der (.*) heisst "(.*?)"$/) do |arg1, arg2|
  s = case arg1
        when "Titel"
          "title"
        when "Speichern-Button"
          "save button"
        else
          raise
      end
  step %Q(the #{s} is labeled as "#{arg2}")
end

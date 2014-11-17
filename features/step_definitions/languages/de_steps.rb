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

Angenommen(/^ich editiere eine Gerätepark( bei dem die aut. Zuweisung aktiviert ist)?$/) do |arg1|
  step "I edit an inventory pool%s" % (arg1 ? " which has the automatic access enabled" : nil)
end

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

Angenommen(/^ein Gegenstand zugeteilt ist und diese Zeile markiert ist$/) do
  step "ich dem nicht problematischen Modell einen Inventarcode zuweise"
  step "wird der Gegenstand der Zeile zugeteilt"
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

Wenn(/^ich die Gesamtanzahl "(.*?)" eingebe$/) do |arg1|
  step %Q(I fill in total quantity with value "#{arg1}")
end

Dann(/^wird mir die verbleibende Anzahl der Lizenzen wie folgt angezeigt "(.*?)"$/) do |arg1|
  step %Q(I see the remaining number of licenses shown as follows "#{arg1}")
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

Angenommen(/^es existiert ein Vertrag mit Status "(.*?)" für einen Benutzer mit sonst keinem anderen Verträgen$/) do |arg1|
  step %Q(there exists a contract with status "#{arg1}" for a user with otherwise no other contracts)
end

Dann(/^erhalte ich die Fehlermeldung "(.*?)"$/) do |arg1|
  step %Q(I see the error message "#{arg1}")
end

Wenn(/^ich innerhalb des gesamten Inventars als "(.*?)" die Option "(.*?)" wähle$/) do |arg1, arg2|
  step %Q(I choose inside all inventory as "#{arg1}" the option "#{arg2}")
end

Dann(/^wird nur das "(.*?)" Inventar angezeigt$/) do |arg1|
  step %Q(only the "#{arg1}" inventory is shown)
end

Wenn(/^ich innerhalb des gesamten Inventars die "(.*?)" setze$/) do |arg1|
  step %Q(I set the option "#{arg1}" inside of the full inventory)
end

Dann(/^ist bei folgenden Inventargruppen der Filter "(.*?)" per Default eingestellt:$/) do |arg1, table|
  step %Q(for the following inventory groups the filter "#{arg1}" is set), table
end

Wenn(/^ich(?: erneut)? auf die Geraetepark\-Auswahl klicke$/) do
  step %Q(I click on the inventory pool selection toggler again)
end

Dann(/^sehe ich alle Geraeteparks, zu denen ich Zugriff als Verwalter habe$/) do
  step %Q(I see all inventory pools for which I am a manager)
end

Wenn(/^ich auf einen Geraetepark klicke$/) do
  step %Q(I click on one of the inventory pools)
end

Dann(/^wechsle ich zu diesem Geraetepark$/) do
  step %Q(I switch to that inventory pool)
end

Wenn(/^ich ausserhalb der Geraetepark\-Auswahl klicke$/) do
  step %Q(I click somewhere outside of the inventory pool menu list)
end

Dann(/^schliesst sich die Geraetepark\-Auswahl$/) do
  step %Q(the inventory pool menu list closes)
end

Dann(/^sehe ich alle Geraeteparks$/) do
  step %Q(I see all the inventory pools)
end

Dann(/^erscheint das entsprechende Modell zum Gegenstand$/) do
  step %Q(appears the corresponding model to the item)
end

Dann(/^es erscheint der Gegenstand$/) do
  step %Q(appears the item)
end

Wenn(/^ich füge ein Bild hinzu$/) do
  step %Q(I add an image)
end

Dann(/^kann ich kein zweites Bild hinzufügen$/) do
  step %Q(I can not add a second image)
end

Angenommen(/^es existiert eine Kategorie mit Bild$/) do
  step %Q(there exists a category with an image)
end

Wenn(/^ich das Bild entferne$/) do
  step %Q(I remove the image)
end

Angenommen(/^man editiert diese Kategorie$/) do
  step %Q(one edits this category)
end

Wenn(/^ich ein neues Bild wähle$/) do
  step %Q(I add a new image)
end

Dann(/^ist die Kategorie mit dem neuen Bild gespeichert$/) do
  step %Q(the category was saved with the new image)
end

Dann(/^man sieht für jede Kategorie ihr Bild, oder falls nicht vorhanden, das erste Bild eines Modells dieser Kategorie$/) do
  step %Q(one sees for each category its image, or if not set, the first image of a model from this category)
end

Angenommen(/^es existiert eine Hauptkategorie mit eigenem Bild$/) do
  step %Q(there exists a main category with own image)
end

Angenommen(/^es existiert eine Hauptkategorie ohne eigenes Bild aber mit einem Modell mit Bild$/) do
  step %Q(there exists a main category without own image but with a model with image)
end

Dann(/^sehe ich nur diejenigen Pakete, für welche ich verantwortlich bin$/) do
  step "I only see packages which I am responsible for"
end

Angenommen(/^ich befinde mich auf der Liste eines "(.*?)"en Inventars$/) do |arg1|
  step %Q(I see the list of "#{arg1}" inventory)
end

Wenn(/^ich eine Modellzeile öffne$/) do
  step %Q(I open a model line)
end

Dann(/^ist die Gegenstandszeile mit "(.*?)" in rot ausgezeichnet$/) do |arg1|
  step %Q(the item line ist marked as "#{arg1}" in red)
end

Angenommen(/^es exisitert ein Gegenstand mit mehreren Problemen$/) do
  step %Q(there exists an item with many problems)
end

Wenn(/^ich nach diesem Gegenstand in der Inventarliste suche$/) do
  step %Q(I search after this item in the inventory list)
end

Wenn(/^ich öffne die Modellzeile von diesem Gegenstand$/) do
  step %Q(I open the model line of this item)
end

Dann(/^sind die Probleme des Gegestandes komma getrennt aneinander gereiht$/) do
  step %Q(the problems of this item are displayed separated by a comma)
end

Angenommen(/^es gibt in meinem Gerätepark einen "(.*?)"en Gegenstand$/) do |arg1|
  step %Q(there is a "#{arg1}" item in my inventory pool)
end

Wenn(/^ich anhand der Inventarnummer nach diesem Gegenstand global suche$/) do
  step %Q(I search globally after this item with its inventory code)
end

Dann(/^sehe ich diesen Gegenstand im Gegenstände\-Container$/) do
  step %Q(I see the item in the items container)
end

Dann(/^die Gegenstandszeile ist mit "(.*?)" in rot ausgezeichnet$/) do |arg1|
  step %Q(the item line ist marked as "#{arg1}" in red)
end

Angenommen(/^es gibt einen geschlossenen Vertrag mit ausgemustertem Gegenstand$/) do
  step %Q(there exists a closed contract with a retired item)
end

Dann(/^sehe ich ihn im Gegenstände\-Container$/) do
  step %Q(I see the item in the items container)
end

Dann(/^wenn ich über die Liste der Gegenstände auf der Vertragslinie hovere$/) do
  step %Q(I hover over the list of items on the contract line)
end

Dann(/^sehe ich im Tooltip das Modell dieses Gegenstandes$/) do
  step %Q(I see in the tooltip the model of this item)
end

Angenommen(/^es gibt einen geschlossenen Vertrag mit einem Gegenstand, wofür ein anderer Gerätepark verantwortlich und Besitzer ist$/) do
  step %Q(there exists a closed contract with an item, for which an other inventory pool is responsible and owner)
end

Dann(/^sehe ich keinen Gegenstände\-Container$/) do
  step %Q(I do not see the items container)
end

Angenommen(/^heute entspricht dem Startdatum der Bestellung$/) do
  step %Q(today corresponds to the start date of the order)
end

Dann(/^speichere die Einstellungen$/) do
  step "I save the booking calendar"
  step 'the booking calendar is closed'
end

Wenn /^man im Inventar Bereich ist$/ do
  step "I open the Inventory"
end

Dann(/^kann man das globale Inventar als CSV\-Datei exportieren$/) do
  step "I can export to a csv-file"
end

Wenn(/^ich befinde mich im Gerätepark mit visierpflichtigen Bestellungen$/) do
  step "I am in an inventory pool with verifiable orders"
end

Wenn(/^ich die Bestellung editiere$/) do
  step "I edit this submitted contract"
end

Dann /^(?:sehe ich|ich sehe) eine Fehlermeldung$/ do
  step "I see an error message"
end

Wenn /^ich öffne den Kalender$/ do
  step "I open the booking calendar"
end

Angenommen(/^ich verwalte die Gerätepark Grundinformationen$/) do
  step "I edit my inventory pool settings"
end

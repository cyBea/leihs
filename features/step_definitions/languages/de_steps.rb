# -*- encoding : utf-8 -*-

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

Angenommen(/^man editiert das Feld "(.*?)" eines ausgeliehenen Gegenstandes, wo man Besitzer ist$/) do |arg1|
  step %Q(one edits the field "#{arg1}" of an owned item not in stock)
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


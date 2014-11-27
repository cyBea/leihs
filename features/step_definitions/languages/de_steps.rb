# -*- encoding : utf-8 -*-

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



Feature: Inventory helper

  Background:
    Given I am Matti

  @personas
  Scenario: Wie man den Helferschirm erreicht
    When I open the inventory
    Then I see a tab where I can change to the inventory helper

  @javascript @personas
  Scenario: Changing the shelf when the location already exists
    Given I am on the inventory helper screen
    And there is an item that shares its location with another
    Then I select the field "Shelf"
    And I set some value for the field "Shelf"
    Then I enter the start of the inventory code of the specific item
    And I choose the item from the list of results
    Then I see all the values of the item in an overview with model name and the modified values are already saved
    And the changed values are highlighted
    And the location of the other item has remained the same

  @javascript @browser @personas
  Scenario: You can't change the responsible department while something is not in stock
    Given I am on the inventory helper screen
    And I edit the field "Responsible department" of an item that isn't in stock and belongs to the current inventory pool
    Then I see an error message that I can't change the responsible inventory pool for items that are not in stock

  @javascript @personas
  Scenario: You can't retire something that is not in stock
    Given I am on the inventory helper screen
    And I retire an item that is not in stock
    Then I see an error message that I can't retire the item because it's already handed over or assigned to a contract

  @javascript @personas
  Scenario: Geräte über den Helferschirm editieren, mittels vollständigem Inventarcode (Scanner)
    Given I am on the inventory helper screen
    Then wähle ich all die Felder über eine List oder per Namen aus
    And ich setze all ihre Initalisierungswerte
    Then scanne oder gebe ich den Inventarcode von einem Gegenstand ein, der am Lager und in keinem Vertrag vorhanden ist
    Then sehe ich alle Werte des Gegenstandes in der Übersicht mit Modellname, die geänderten Werte sind bereits gespeichert
    And die geänderten Werte sind hervorgehoben

  @javascript @personas
  Scenario: Pflichtfelder
    Given I am on the inventory helper screen
    When "Bezug" ausgewählt und auf "Investition" gesetzt wird, dann muss auch "Projektnummer" angegeben werden
    When "Inventarrelevant" ausgewählt und auf "Ja" gesetzt wird, dann muss auch "Anschaffungskategorie" angegeben werden
    When "Ausmusterung" ausgewählt und auf "Ja" gesetzt wird, dann muss auch "Grund der Ausmusterung" angegeben werden
    Then sind alle Pflichtfelder mit einem Stern gekenzeichnet
    When ein Pflichtfeld nicht ausgefüllt/ausgewählt ist, dann lässt sich der Inventarhelfer nicht nutzen
    And I see an error message
    And die nicht ausgefüllten/ausgewählten Pflichtfelder sind rot markiert

  @javascript @personas
  Scenario: Geräte über den Helferschirm editieren, mittels Inventarcode konnte nicht gefunden wurde
    Given I am on the inventory helper screen
    Then wähle ich die Felder über eine List oder per Namen aus
    And ich setze ihre Initalisierungswerte
    Then scanne oder gebe ich den Inventarcode eines Gegenstandes ein der nicht gefunden wird
    Then erhählt man eine Fehlermeldung

  @javascript @personas
  Scenario: Geräte über den Helferschirm editieren mittels Inventarcode über Autovervollständigung
    Given I am on the inventory helper screen
    Then wähle ich die Felder über eine List oder per Namen aus
    And ich setze ihre Initalisierungswerte
    Then gebe ich den Anfang des Inventarcodes eines Gegenstand ein
    And wähle den Gegenstand über die mir vorgeschlagenen Suchtreffer
    Then sehe ich alle Werte des Gegenstandes in der Übersicht mit Modellname, die geänderten Werte sind bereits gespeichert
    And die geänderten Werte sind hervorgehoben

  @javascript @browser @personas
  Scenario: Editeren nach automatischen speichern
    Given man editiert ein Gerät über den Helferschirm mittels Inventarcode
    When man die Editierfunktion nutzt
    Then kann man an Ort und Stelle alle Werte des Gegenstandes editieren
    When man die Änderungen speichert
    Then sind sie gespeichert

  @javascript @personas
  Scenario: Editeren nach automatischen speichern abbrechen
    Given man editiert ein Gerät über den Helferschirm mittels Inventarcode
    When man die Editierfunktion nutzt
    Then kann man an Ort und Stelle alle Werte des Gegenstandes editieren
    When man seine Änderungen widerruft
    Then sind die Änderungen widerrufen
    And man sieht alle ursprünglichen Werte des Gegenstandes in der Übersicht

  @javascript @personas
  Scenario: Bei Gegenständen, die in Verträgen vorhanden sind, können gewisse Felder nicht editiert werden
    Given I am on the inventory helper screen
    And man editiert das Feld "Modell" eines Gegenstandes, der im irgendeinen Vertrag vorhanden ist
    Then erhält man eine Fehlermeldung, dass man diese Eigenschaft nicht editieren kann, da das Gerät in einem Vortrag vorhanden ist

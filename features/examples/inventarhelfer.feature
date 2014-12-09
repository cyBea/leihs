
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
  Scenario: Editing items on the helper screen using a complete inventory code (barcode scanner)
    Given I am on the inventory helper screen
    When I choose all fields through a list or by name
    And I set all their initial values
    Then I scan or enter the inventory code of an item that is in stock and not in any contract
    Then I see all the values of the item in an overview with model name and the modified values are already saved
    And the changed values are highlighted

  @javascript @personas
  Scenario: Pflichtfelder
    Given I am on the inventory helper screen
    When "Reference" is selected and set to "Investment", then "Project Number" must also be filled in
    When "Relevant for inventory" is selected and set to "Yes", then "Supply Category" must also be filled in
    When "Retirement" is selected and set to "Yes", then "Reason for Retirement" must also be filled in
    Then all required fields are marked with an asterisk
    When a required field is blank, the inventory helper cannot be used
    And I see an error message
    And the required fields are highlighted in red

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

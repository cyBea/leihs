
Feature: Viewing my orders

  Background:
    Given I am Normin
    And I have added items to an order
    When I open my list of orders

  @personas
  Scenario: Listing items in an order
    Then I see entries grouped by start date and inventory pool
    And the models are ordered alphabetically
    And each entry has the following information
    |Image|
    |Quantity|
    |Model name|
    |Manufacturer|
    |Number of days|
    |End date|
    |the various actions|

  @javascript @browser @personas
  Scenario: Deleting things in my order overview
    When I delete an entry
    Then the items are available for borrowing again
     And the entry is removed from the order

  @javascript @personas
  Scenario: Timeout
    When I add a model to an order
    Then I see a timer
    When I am listing my orders
    And time has run out
    Then I am redirected to the timeout page

  @javascript @personas @browser
  Scenario: Changing one of my orders
    When I change the entry
    Then the calendar opens
    When I change the date
    And I save the booking calendar
    Then the entry's date is changed accordingly
    And the entry is grouped based on its current start date and inventory pool

  @javascript @personas
  Scenario: Zeitentität, Ablauf der erlaubten Zeit anzeigen
    Then sehe ich die Zeitinformationen in folgendem Format "mm:ss"
    And die Zeitanzeige zählt von 30 Minuten herunter

  @personas
  Scenario: Zeit zurücksetzen
    Given die Bestellung ist nicht leer
    Then sehe ich die Zeitanzeige
    When ich den Time-Out zurücksetze
    Then wird die Zeit zurückgesetzt

  @javascript @personas
  Scenario: Zeit abgelaufen
    When die Zeit abgelaufen ist
    Then werde ich auf die Timeout Page weitergeleitet

  @javascript @browser @personas
  Scenario: Bestellübersicht Bestellung löschen
    When ich die Bestellung lösche
    Then werde ich gefragt ob ich die Bestellung wirklich löschen möchte
    And ich befinde mich wieder auf der Startseite
    And alle Einträge werden aus der Bestellung gelöscht
    And die Gegenstände sind wieder zur Ausleihe verfügbar

  @personas
  Scenario: Bestellübersicht Bestellen
    When ich einen Zweck eingebe
    And ich die Bestellung abschliesse
    Then ändert sich der Status der Bestellung auf Abgeschickt
    And ich erhalte eine Bestellbestätigung
    And in der Bestellbestätigung wird mitgeteilt, dass die Bestellung in Kürze bearbeitet wird
    And ich befinde mich wieder auf der Startseite

  @personas
  Scenario: Bestellübersicht Zweck nicht eingegeben
    When der Zweck nicht abgefüllt wird
    Then hat der Benutzer keine Möglichkeit die Bestellung abzuschicken

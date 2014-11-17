
Feature: Suche

  @personas
  Scenario: Suche nach Verträgen mittels Inventarcode eines Gegenstandes der dem Vertrag zugewisen ist
    Given I am Mike
    And ich gebe den Inventarcode eines Gegenstandes der einem Vertrag zugewisen ist in die Suche ein
    Then sehe ich den Vertrag dem der Gegenstand zugewisen ist in der Ergebnisanzeige

  @javascript @personas
  Scenario: Such nach einem Benutzer mit Verträgen, der kein Zugriff mehr auf das Gerätepark hat
    Given I am Mike
    And es existiert ein Benutzer mit Verträgen, der kein Zugriff mehr auf das Gerätepark hat
    When man nach dem Benutzer sucht
    Then sieht man alle Veträge des Benutzers
    And der Name des Benutzers ist in jeder Vertragslinie angezeigt
    And die Personalien des Benutzers werden im Tooltip angezeigt

  @javascript @personas
  Scenario: Keine Aushändigung ohne vorherige Genehmigung
    Given I am Pius
    And es gibt einen Benutzer, mit einer nicht genehmigter Bestellung
    When man nach diesem Benutzer sucht
    Then kann ich die nicht genehmigte Bestellung des Benutzers nicht aushändigen ohne sie vorher zu genehmigen

  @javascript @personas
  Scenario: Kein 'zeige alle gefundenen Verträge' Link
    Given I am Mike
    And es existiert ein Benutzer mit mindestens 3 und weniger als 5 Verträgen
    When man nach dem Benutzer sucht
    Then sieht man alle unterschriebenen und geschlossenen Veträge des Benutzers
    And man sieht keinen Link 'Zeige alle gefundenen Verträge'

  @javascript @personas
  Scenario: Anzeige von ausgemusterten Gegenständen
    Given I am Mike
    And there exists a closed contract with a retired item
    When I search globally after this item with its inventory code
    Then sehe den Gegenstand ihn im Gegenstände-Container
    And I hover over the list of items on the contract line
    Then I see in the tooltip the model of this item

  @javascript @personas
  Scenario: Anzeige von Gegenständen eines anderen Geräteparks in geschlossenen Verträgen
    Given I am Mike
    And there exists a closed contract with an item, for which an other inventory pool is responsible and owner
    When I search globally after this item with its inventory code
    Then I do not see the items container
    And I hover over the list of items on the contract line
    Then I see in the tooltip the model of this item

  @personas @javascript
  Scenario Outline: Probleme bei Gegenständen in globaler Suche anzeigen
    Given I am Mike
    And there is a "<Zustand>" item in my inventory pool
    When I search globally after this item with its inventory code
    Then I see the item in the items container
    And the item line ist marked as "<Zustand>" in red
    Examples:
      | Zustand          |
      | Defekt           |
      | Ausgemustert     |
      | Unvollständig    |
      | Nicht ausleihbar |

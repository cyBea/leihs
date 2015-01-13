
Feature: Search

  @personas
  Scenario: Searching for contracts by inventory code of an item that is assigned to a contract
    Given I am Mike
    And I search for the inventory code of an item that is in a contract
    Then I see the contract this item is assigned to in the list of results

  @javascript @personas
  Scenario: Searching for a user that has contracts but no longer has access to the current inventory pool
    Given I am Mike
    And there is a user with contracts who no longer has access to the current inventory pool
    When I search for that user
    Then I see all that user's contracts
    And the name of that user is shown on each contract line
    And that user's personal details are shown in the tooltip

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

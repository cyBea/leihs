
Feature: Ausleihe

  Background:
    Given I am Pius
    And I open the daily view

  @personas @javascript
  Scenario: Anzeige der längsten Zeitspanne für Bestellungen
    Given eine Bestellungen mit zwei unterschiedlichen Zeitspannen existiert
    And I navigate to the open orders
    Then sehe ich für diese Bestellung die längste Zeitspanne direkt auf der Linie

  @personas @javascript
  Scenario Outline: Sperrstatus des Benutzers anzeigen
    Given eigenes Benutzer sind gesperrt
    And I navigate to the <target>
    Then sehe ich auf allen Linien dieses Benutzers den Sperrstatus 'Gesperrt'
  Examples: 
    | target           |
    | open orders      |
    | hand over visits |
    | take back visits |

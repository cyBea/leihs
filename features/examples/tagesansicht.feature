
Feature: Ausleihe

  Grundlage:
    Given I am Pius
    And I open the daily view

  @personas
  Scenario: Anzeige der längsten Zeitspanne für Bestellungen
    Given eine Bestellungen mit zwei unterschiedlichen Zeitspannen existiert
    Then sehe ich für diese Bestellung die längste Zeitspanne direkt auf der Linie

  @personas
  Scenario: Sperrstatus des Benutzers anzeigen
    Given eigenes Benutzer sind gesperrt
    Then sehe ich auf allen Linien dieses Benutzers den Sperrstatus 'Gesperrt'




Feature: Suche

  @personas
  Scenario: Suche nach Verträgen mittels Inventarcode eines Gegenstandes der dem Vertrag zugewisen ist
    Given ich bin Mike
    And ich gebe den Inventarcode eines Gegenstandes der einem Vertrag zugewisen ist in die Suche ein
    Then sehe ich den Vertrag dem der Gegenstand zugewisen ist in der Ergebnisanzeige

  @javascript @personas
  Scenario: Such nach einem Benutzer mit Verträgen, der kein Zugriff mehr auf das Gerätepark hat
    Given ich bin Mike
    And es existiert ein Benutzer mit Verträgen, der kein Zugriff mehr auf das Gerätepark hat
    When man nach dem Benutzer sucht
    Then sieht man alle Veträge des Benutzers
    And der Name des Benutzers ist in jeder Vertragslinie angezeigt
    And die Personalien des Benutzers werden im Tooltip angezeigt

  @javascript @personas
  Scenario: Keine Aushändigung ohne vorherige Genehmigung
    Given ich bin Pius
    And es gibt einen Benutzer, mit einer nicht genehmigter Bestellung
    When man nach diesem Benutzer sucht
    Then kann ich die nicht genehmigte Bestellung des Benutzers nicht aushändigen ohne sie vorher zu genehmigen

  @javascript @personas
  Scenario: Kein 'zeige alle gefundenen Verträge' Link
    Given ich bin Mike
    And es existiert ein Benutzer mit mindestens 3 und weniger als 5 Verträgen
    When man nach dem Benutzer sucht
    Then sieht man alle unterschriebenen und geschlossenen Veträge des Benutzers
    And man sieht keinen Link 'Zeige alle gefundenen Verträge'

  @javascript @personas
  Scenario: Anzeige von ausgemusterten Gegenständen
    Given ich bin Mike
    And es gibt einen geschlossenen Vertrag mit ausgemustertem Gegenstand
    When ich anhand der Inventarnummer nach diesem Gegenstand global suche
    Then sehe den Gegenstand ihn im Gegenstände-Container
    And wenn ich über die Liste der Gegenstände auf der Vertragslinie hovere
    Then sehe ich im Tooltip das Modell dieses Gegenstandes

  @javascript @personas
  Scenario: Anzeige von Gegenständen eines anderen Geräteparks in geschlossenen Verträgen
    Given ich bin Mike
    And es gibt einen geschlossenen Vertrag mit einem Gegenstand, wofür ein anderer Gerätepark verantwortlich und Besitzer ist
    When ich anhand der Inventarnummer nach diesem Gegenstand global suche
    Then sehe ich keinen Gegenstände-Container
    And wenn ich über die Liste der Gegenstände auf der Vertragslinie hovere
    Then sehe ich im Tooltip das Modell dieses Gegenstandes

  @personas @javascript
  Scenario Outline: Probleme bei Gegenständen in globaler Suche anzeigen
    Given ich bin Mike
    And es gibt in meinem Gerätepark einen "<Zustand>"en Gegenstand
    When ich anhand der Inventarnummer nach diesem Gegenstand global suche
    Then sehe ich diesen Gegenstand im Gegenstände-Container
    And die Gegenstandszeile ist mit "<Zustand>" in rot ausgezeichnet
    Examples:
      | Zustand          |
      | Defekt           |
      | Ausgemustert     |
      | Unvollständig    |
      | Nicht ausleihbar |

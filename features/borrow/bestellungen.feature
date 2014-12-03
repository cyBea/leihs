
Feature: Bestellungen

  Background:
    Given I am Normin

  @personas
  Scenario: Anzahl
    Then sehe ich die Anzahl meiner abgeschickten, noch nicht genehmigten Bestellungen auf jeder Seite

  @personas
  Scenario: Bestellungen-Übersichtsseite
    When ich auf den Bestellungen Link drücke
    Then sehe ich meine abgeschickten, noch nicht genehmigten Bestellungen
    And ich sehe die Information, dass die Bestellung noch nicht genehmigt wurde
    And die Bestellungen sind nach Datum und Gerätepark sortiert
    And jede Bestellung zeigt die zu genehmigenden Geräte
    And die Geräte der Bestellung sind alphabetisch sortiert nach Modellname
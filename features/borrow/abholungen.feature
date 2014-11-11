
Feature: Abholungen

  @personas
  Scenario: Anzahl und Rückgabe-Button
    Given I am Normin
    Then sehe ich die Anzahl meiner "Abholungen" auf jeder Seite

  @personas
  Scenario: Kein Abhol-Button im Fall nicht vorhandenen Rückgaben
    Given I am Peter
    And man befindet sich im Ausleihen-Bereich
    Then sehe ich den "Abholungen" Button nicht

  @personas
  Scenario: Abholungen-Übersichtsseite
    Given I am Normin
    When ich auf den "Abholungen" Link drücke
    Then sehe ich meine "Abholungen"
    And die "Abholungen" sind nach Datum und Gerätepark sortiert
    And jede der "Abholungen" zeigt die abzuholenden Geräte
    And die Geräte sind alphabetisch sortiert und gruppiert nach Modellname mit Anzahl der Geräte

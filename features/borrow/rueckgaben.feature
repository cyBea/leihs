
Feature: Rückgaben

  @personas
  Scenario: Anzahl und Rückgabe-Button
    Given ich bin Normin
    Then sehe ich die Anzahl meiner "Rückgaben" auf jeder Seite

  @personas
  Scenario: Kein Rückgabe-Button im Fall nicht vorhandenen Rückgaben
    Given ich bin Ramon
    And man befindet sich im Ausleihen-Bereich
    Then sehe ich den "Rückgaben" Button nicht

  @personas
  Scenario: Rückgabe-Übersichtsseite
    Given ich bin Normin
    When ich auf den "Rückgaben" Link drücke
    Then sehe ich meine "Rückgaben"
    And die "Rückgaben" sind nach Datum und Gerätepark sortiert
    And jede der "Rückgaben" zeigt die zurückzugebenden Geräte
    And die Geräte sind alphabetisch sortiert nach Modellname
    And jedes Gerät zeigt seinen Inventarcode


Feature: Suche

  Um die Sprache der Applikation zu verstehen
  möchte ich als Benutzer
  die Sprache umschalten können

  @personas
  Scenario: Wechsel der Sprache
    Given ich bin Normin
    And man sich auf der Modellliste befindet
    When ich die Sprache auf "English" umschalte
    Then ist die Sprache "English"
    When ich die Sprache auf "Deutsch" umschalte
    Then ist die Sprache "Deutsch"


Feature: Reservierenden wechseln

  Background:
    Given I am Pius

  @javascript @personas
  Scenario: Reservierende Person für ausgewählte Linien wechseln
    Given I am doing a hand over
    Then kann ich die reservierende Person für eine Auswahl an Linien wechseln


Feature: Software löschen

  Background:
    Given I am Mike

  @javascript @browser @personas
  Scenario: Software-Produkt löschen
    Given es existiert eine Software mit folgenden Konditionen:
      | in keinem Vertrag aufgeführt |
      | keiner Bestellung zugewiesen |
      | keine Lizenzen zugefügt      |
    When I delete this Software from the list
    Then die Software wurde aus der Liste gelöscht
    And the "Software" is deleted

  @javascript @browser @personas
  Scenario: Softwareanhängsel löschen wenn Software gelöscht wird
    Given es existiert eine Software mit folgenden Konditionen:
      | in keinem Vertrag aufgeführt |
      | keiner Bestellung zugewiesen |
      | keine Lizenzen zugefügt      |
      | hat Anhänge                  |
    When I delete this Software from the list
    And the "Software" is deleted
    And es wurden auch alle Anhängsel gelöscht


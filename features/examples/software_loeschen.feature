
Feature: Software löschen

  Grundlage:
    Given I am Mike

  @javascript @browser @personas
  Scenario: Software-Produkt löschen
    Given es existiert eine Software mit folgenden Konditionen:
      | in keinem Vertrag aufgeführt |
      | keiner Bestellung zugewiesen |
      | keine Lizenzen zugefügt      |
    When ich diese "Software" aus der Liste lösche
    Then die Software wurde aus der Liste gelöscht
    And die "Software" ist gelöscht

  @javascript @browser @personas
  Scenario: Softwareanhängsel löschen wenn Software gelöscht wird
    Given es existiert eine Software mit folgenden Konditionen:
      | in keinem Vertrag aufgeführt |
      | keiner Bestellung zugewiesen |
      | keine Lizenzen zugefügt      |
      | hat Anhänge                  |
    When ich diese "Software" aus der Liste lösche
    And die "Software" ist gelöscht
    And es wurden auch alle Anhängsel gelöscht


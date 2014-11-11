
Feature: Sprachauswahl

  Um die Interfacesprache auf meine Bedürfnisse anzupassen
  möchte ich Benutzer
  die Möglichkeit haben meine Sprache einzustellen

  @personas
  Scenario: Navigation für Ausleihenden
    Given I am Mike
    And ich sehe die Sprachauswahl
    When ich die Sprache ändere
    Then ist die Sprache für mich geändert  

Feature: Option

  Background:
    Given I am Mike

  @javascript @browser @personas
  Scenario: Option hinzufügen
    Given I open the inventory
    When ich eine neue Option hinzufüge
    And ich ändere die folgenden Details
    | Feld             | Wert         |
    | Produkt          | Test Option  |
    | Preis            | 50           |
    | Inventarcode     | Test Barcode |
    And ich speichere die Informationen
    Then die neue Option ist erstellt

  @javascript @browser @personas
  Scenario: Option bearbeiten
    Given I open the inventory
    When ich eine bestehende Option bearbeite
    And ich erfasse die folgenden Details
    | Feld             | Wert           |
    | Produkt          | Test Option x  |
    | Preis            | 51             |
    | Inventarcode     | Test Barcode x |
    And ich speichere die Informationen
    Then the information is saved
    And die Daten wurden entsprechend aktualisiert


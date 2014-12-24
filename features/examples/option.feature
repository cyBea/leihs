
Feature: Option

  Background:
    Given I am Mike

  @javascript @browser @personas
  Scenario: Adding options
    Given I open the inventory
    When I add a new Option
    And I edit the following details
    | Field             | Value         |
    | Product          | Test Option  |
    | Price            | 50           |
    | Inventory code     | Test Barcode |
    And I save
    Then the information is saved

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


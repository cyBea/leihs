
Feature: Option

  Grundlage:
    Given ich bin Mike

  @javascript @browser @personas
  Scenario: Option hinzufügen
    Given man öffnet die Liste des Inventars
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
    Given man öffnet die Liste des Inventars
    When ich eine bestehende Option bearbeite
    And ich erfasse die folgenden Details
    | Feld             | Wert           |
    | Produkt          | Test Option x  |
    | Preis            | 51             |
    | Inventarcode     | Test Barcode x |
    And ich speichere die Informationen
    Then die Informationen sind gespeichert
    And die Daten wurden entsprechend aktualisiert


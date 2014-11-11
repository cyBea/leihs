
Feature: Software suchen

  Grundlage:
    Given I am Mike

  @javascript @personas
  Scenario: Software anhand eines Suchbegriffs finden
    Given es existiert ein Software-Produkt mit folgenden Eigenschaften:
      | Produktname          | suchbegriff1 |
      | Hersteller           | suchbegriff4 |
    And es existiert eine Software-Lizenz mit folgenden Eigenschaften:
      | Inventarcode         | suchbegriff2 |
      | Seriennummer         | suchbegriff3 |
      | Dongle-ID            | suchbegriff5 |
      | Anzahl-Zuteilung     | 1 / Christina Meier |
    And diese Software-Lizenz ist an jemanden ausgeliehen
    When ich nach einer dieser Software-Produkt Eigenschaften suche
    Then es erscheinen alle zutreffenden Software-Produkte
    And es erscheinen alle zutreffenden Software-Lizenzen
    And es erscheinen alle zutreffenden Verträge, in denen diese Software-Produkt vorkommt
    When ich nach einer dieser Software-Lizenz Eigenschaften suche
    Then es erscheinen alle zutreffenden Software-Lizenzen
    And es erscheinen alle zutreffenden Verträge, in denen diese Software-Produkt vorkommt

  @javascript @personas
  Scenario: Verträge für Software-Lizenzen anhand des Ausleihenden finden
    Given es existiert eine Software-Lizenz
    And diese Software-Lizenz ist an jemanden ausgeliehen
    When ich nach dem Namen dieser Person suche
    Then erscheint der Vertrag dieser Person in den Suchresultaten
    And es erscheint diese Person in den Suchresultaten

  @javascript @personas
  Scenario: Aufteilung der Suchresultate
    Given es existieren Software-Produkte
    And es existieren für diese Produkte Software-Lizenzen
    When ich diese in meinen Suchresultaten sehe
    Then kann ich wählen, ausschliesslich Software-Produkte aufzulisten
    And ich kann wählen, ausschliesslich Software-Lizenzen aufzulisten

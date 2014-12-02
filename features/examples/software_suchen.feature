
Feature: Software suchen

  Grundlage:
    Given I am Mike

  @javascript @personas
  Scenario: Software anhand eines Suchbegriffs finden
    Given there is a software product with the following properties:
      | Product name          | suchbegriff1 |
      | Manufacturer           | suchbegriff4 |
    And there is a software license with the following properties:
      | Inventory code         | suchbegriff2 |
      | Serial number         | suchbegriff3 |
      | Dongle ID            | suchbegriff5 |
      | Quantity allocations     | 1 / Christina Meier |
    And this software license is handed over to somebody
    When ich nach einer dieser Software-Produkt Eigenschaften suche
    Then they appear all matched software products
    And they appear all matched software licenses
    And they appear all matched contracts, in which this software product is contained
    When ich nach einer dieser Software-Lizenz Eigenschaften suche
    Then they appear all matched software licenses
    And they appear all matched contracts, in which this software product is contained

  @javascript @personas
  Scenario: Verträge für Software-Lizenzen anhand des Ausleihenden finden
    Given a software license exists
    And this software license is handed over to somebody
    When I search after the name of that person
    Then it appears the contract of this person in the search results
    And it appears this person in the search results

  @javascript @personas
  Scenario: Aufteilung der Suchresultate
    Given a software product exists
    And there exist licenses for this software product
    When I see these in my search result
    Then I can select to list only software products
    And I can select to list only software licenses


# Translating from: features/examples/ausleihe.feature
Feature: Lending

  Background:
    Given I am Pius

  @javascript @browser @personas
  Scenario: Selection during manual interaction when handing over
    When I open a hand over
    And I manually assign an inventory code to an item
    Then the item is selected and the box is checked

  @javascript @browser @personas
  Scenario: Hand over: Highlight items in inventory code lists when they are not available
    When I try to complete a hand over that contains a model with unborrowable items
    And I try to assign an inventory code to this model
    Then the system suggests a list of items
    And unborrowable items are highlighted

  @javascript @personas
  Scenario: When people appear in the last visitors list
    Given I open the daily view
    When I edit an order
    Then the user appears under last visitors
    When I open a hand over
    Then the user appears under last visitors
    When I open a take back
    Then the user appears under last visitors


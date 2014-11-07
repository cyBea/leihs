
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

  @javascript @personas
  Scenario: Error message when trying to hand over something from the future
    When I open a hand over
    And the chosen items contain some from a future hand over
    And I click hand over
    Then I see the error message "you cannot hand out lines which are starting in the future"
    And I cannot hand over the items

  # https://www.pivotaltracker.com/story/show/29455957
  @javascript @personas
  Scenario: Booking calendar: Show the customer's groups in "show availability"
    Given the customer is in multiple groups
    When I open a hand over to this customer
    And I edit a line containing group partitions
    And I expand the group selector
    Then I see which groups the customer is a member of
    And I see which groups the customer is not a member of

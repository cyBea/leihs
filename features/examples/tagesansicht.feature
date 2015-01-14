
Feature: Daily view

  Background:
    Given I am Pius
    And I open the daily view

  @personas @javascript
  Scenario: Showing the longest time window for orders
    Given there is an order with two different time windows
    And I navigate to the open orders
    Then I see the longest time span of this order directly on the order's line

  @personas @javascript
  Scenario Outline: Showing whether a user is suspended
    Given the current inventory pool's users are suspended
    And I navigate to the <target>
    Then each line of this user contains the text 'Suspended'
  Examples:
    | target           |
    | open orders      |
    | hand over visits |
    | take back visits |

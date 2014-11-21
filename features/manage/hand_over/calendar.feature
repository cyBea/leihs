Feature: calendar

  Background:
    Given I am Pius

  @personas @javascript
  Scenario: reached maximum amount of visits of a week day
    Given the current inventory pool has reached maximum amount of visits
    When I open the calendar of a model
    Then the availability number is shown on this specific date
    When I specify this date as start or end date
    Then the day is marked red
    And I receive an error message within the modal
    When I submit the reservation
    Then the booking calendar is closed
    And the reservation is stored with this specific date as start or end date


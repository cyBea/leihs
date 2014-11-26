Feature: User model

  Model test (instance methods)

  Scenario: Create a user with long lastname
    Given the following users exist
      | firstname        | lastname                                    | email                        |
      | Peter Hans Hueli | With last name longer than forty characters | peter.hans.hueli@example.com |
    Then a user with login "Peter Hans Hueli With last name longer than forty characters" exists
    And the login of this user is longer than 40 chars

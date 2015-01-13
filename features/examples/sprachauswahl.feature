
Feature: Changing interface language 

  In order to understand what the software is telling me
  As any user
  I want to switch the interface language to a language I know

  @personas
  Scenario: Changing my interface language
    Given I am Mike
    And I see the language list
    When I change the language
    Then the interface language has been changed

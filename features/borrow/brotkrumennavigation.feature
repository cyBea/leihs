
Feature: Breadcrumb navigation

  Background:
    Given I am Normin

  @personas
  Scenario: Breadcrumb navigation
    Given I am listing the root categories
    Then I see the breadcrumb navigation bar

  @personas
  Scenario: Home button in the breadcrumb navigation
    Given I am listing the root categories
    And I see the breadcrumb navigation bar
    Then the first position in the breadcrumb navigation bar is always the home button
    And that button directs me to the root categories

  @personas
  Scenario: Choosing main category
    Given I am listing the root categories
    When I choose a main category
    Then that category opens
    And that category is the second and last element of the breadcrumb navigation bar

  @javascript @personas
  Scenario: Choosing a subcategory
    Given I am listing the root categories
    When I choose a subcategory
    Then that category opens
    And that category is the second and last element of the breadcrumb navigation bar

  @personas
  Scenario: Show the path to a model
    Given I am listing the root categories
    When I choose a main category
    Then that category opens
    And that category is the second and last element of the breadcrumb navigation bar
    When I open a model
    Then I see the whole path I traversed to get to the model
    And none of the elements of the breadcrumb navigation bar are active

  @personas
  Scenario: Explorative-Suche Kategorie der ersten Stufe auswählen
    Given man sich auf der Modellliste befindet
    When ich eine Kategorie der ersten stufe aus der Explorativen Suche wähle
    Then öffnet diese Kategorie
    And die Kategorie ist das zweite und letzte Element der Brotkrumennavigation

  @personas
  Scenario: Explorative-Suche Kategorie der zweiten Stufe auswählen
    Given man sich auf der Modellliste befindet
    When ich eine Kategorie der zweiten stufe aus der Explorativen Suche wähle
    Then öffnet diese Kategorie
    And die Kategorie ist das zweite und letzte Element der Brotkrumennavigation

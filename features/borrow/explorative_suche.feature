
Feature: Explorative search

  Background:
    Given I am Normin

  @personas
  Scenario: Explorative search in model list
    Given I am listing models
    Then I see the explorative search
    And it contains the currently selected category's direct children and their children
    And those categories and their children that do not contain any borrowable items are hidden

  @personas
  Scenario: Wahl einer Subkategorie
    Given I am listing models
    When ich eine Kategorie wähle
    Then werden die Modelle der aktuell angewählten Kategorie angezeigt

  @personas
  Scenario: Unterstes Blatt erreicht
    Given man befindet sich auf der Modellliste einer Kategorie ohne Kinder
    Then ist die explorative Suche nicht sichtbar und die Modellliste ist erweitert

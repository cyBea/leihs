
Feature: Startseite

  Um einen Überblick über das ausleihbare Inventar zu erhalten
  möchte ich als Ausleiher
  einen Einstieg/Übersicht über das ausleihbare Inventar

  @personas
  Scenario: Startseite
    Given I am Normin
    And there exists a main category with own image
    And there exists a main category without own image but with a model with image
    And man befindet sich auf der Seite der Hauptkategorien
    Then sieht man genau die für den User bestimmte Haupt-Kategorien mit Namen
    And one sees for each category its image, or if not set, the first image of a model from this category
    When man eine Hauptkategorie auswählt
    Then lande ich in der Modellliste für diese Hauptkategorie

  @javascript @personas
  Scenario: Haupt-Kategorien aufklappen
    Given I am Normin
    And man befindet sich auf der Seite der Hauptkategorien
    When ich über eine Hauptkategorie mit Kindern fahre
    Then sehe ich nur die Kinder dieser Hauptkategorie, die dem User zur Verfügung stehende Gegenstände enthalten
    When ich eines dieser Kinder anwähle
    Then lande ich in der Modellliste für diese Kategorie

  @personas
  Scenario: Kinder-Kategorien Dropdown nicht sichtbar
    Given I am Normin
    And man befindet sich auf der Seite der Hauptkategorien
    And es gibt eine Hauptkategorie, derer Kinderkategorien keine dem User zur Verfügung stehende Gegenstände enthalten
    Then hat diese Hauptkategorie keine Kinderkategorie-Dropdown


Feature: Startseite

  Um einen Überblick über das ausleihbare Inventar zu erhalten
  möchte ich als Ausleiher
  einen Einstieg/Übersicht über das ausleihbare Inventar

  @personas
  Scenario: Startseite
    Given ich bin Normin
    And es existiert eine Hauptkategorie mit eigenem Bild
    And es existiert eine Hauptkategorie ohne eigenes Bild aber mit einem Modell mit Bild
    And man befindet sich auf der Seite der Hauptkategorien
    Then sieht man genau die für den User bestimmte Haupt-Kategorien mit Namen
    And man sieht für jede Kategorie ihr Bild, oder falls nicht vorhanden, das erste Bild eines Modells dieser Kategorie
    When man eine Hauptkategorie auswählt
    Then lande ich in der Modellliste für diese Hauptkategorie

  @javascript @personas
  Scenario: Haupt-Kategorien aufklappen
    Given ich bin Normin
    And man befindet sich auf der Seite der Hauptkategorien
    When ich über eine Hauptkategorie mit Kindern fahre
    Then sehe ich nur die Kinder dieser Hauptkategorie, die dem User zur Verfügung stehende Gegenstände enthalten
    When ich eines dieser Kinder anwähle
    Then lande ich in der Modellliste für diese Kategorie

  @personas
  Scenario: Kinder-Kategorien Dropdown nicht sichtbar
    Given ich bin Normin
    And man befindet sich auf der Seite der Hauptkategorien
    And es gibt eine Hauptkategorie, derer Kinderkategorien keine dem User zur Verfügung stehende Gegenstände enthalten
    Then hat diese Hauptkategorie keine Kinderkategorie-Dropdown

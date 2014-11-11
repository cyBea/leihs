
Feature: Explorative Suche

  Um Modelle anhand von Kategorien explorativ zu entdecken
  möchte ich als Benutzer
  eine entsprehende Interaktionsmöglichkeit haben

  Grundlage:
    Given I am Pius

  @javascript @personas
  Scenario: Explorative Suche in der Liste des Inventars
    Given man öffnet die Liste des Inventars
    And ich die Navigation der Kategorien aufklappe
    When ich eine Kategorie anwähle
    Then sehe ich die darunterliegenden Kategorien
    And kann die darunterliegende Kategorie anwählen
    And ich sehe die Hauptkategorie sowie die aktuell ausgewählte und die darunterliegenden Kategorien
    And das Inventar wurde nach dieser Kategorie gefiltert
    And ich kann in einem Schritt auf die aktuelle Hauptkategorie zurücknavigieren
    And ich kann in einem Schritt auf die Übersicht der Hauptkategorien zurücknavigieren
    When ich die Navigation der Kategorien wieder zuklappe
    Then sehe ich nur noch die Liste des Inventars

  @javascript @personas
  Scenario: Kategorie in der explorativen Suche suchen
    Given man öffnet die Liste des Inventars
    And die Navigation der Kategorien ist aufgeklappt
    When ich nach dem Namen einer Kategorie suche
    Then werden alle Kategorien angezeigt, welche den Namen beinhalten
    And ich eine Kategorie anwähle
    Then sehe ich die darunterliegenden Kategorien
    And kann die darunterliegende Kategorie anwählen
    And ich sehe ein Suchicon mit dem Namen des gerade gesuchten Begriffs sowie die aktuell ausgewählte und die darunterliegenden Kategorien
    And das Inventar wurde nach dieser Kategorie gefiltert

  @javascript @personas
  Scenario: Zurücknavigieren in der explorativen Suche
    Given ich befinde mich in der Unterkategorie der explorativen Suche
    Then kann ich in die übergeordnete Kategorie navigieren

  @javascript @personas
  Scenario: Explorative Suche in der Liste der Modelle
    Given man öffnet die Liste des Inventars
    And ich die Navigation der Kategorien aufklappe
    When ich eine Kategorie anwähle
    Then sehe ich die darunterliegenden Kategorien
    And kann die darunterliegende Kategorie anwählen
    And ich sehe die Hauptkategorie sowie die aktuell ausgewählte und die darunterliegenden Kategorien
    And die Modelle wurden nach dieser Kategorie gefiltert

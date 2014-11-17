
Feature: Suche

  Um etwas zu finden möchte ich als Ausleiher eine Suchfunktionalität

  Grundlage:
    Given I am Normin

  @personas
  Scenario: Suchfeld
    Given man befindet sich auf der Seite der Hauptkategorien
    Then sieht man die Suche

  @javascript @personas
  Scenario: Liste gemäss Suchkritieren anzeigen
    Given man befindet sich auf der Seite der Hauptkategorien
    When man einen Suchbegriff eingibt
    Then sieht man das Foto, den Namen und den Hersteller der ersten 6 Modelle gemäss aktuellem Suchbegriff
    And sieht den Link 'Alle Suchresultate anzeigen'

  @javascript @personas
  Scenario: Man findet nur Modelle die man auch ausleihen kann
    Given ich nach einem Modell suche, welches in nicht ausleihen kann
    Then wird dieses Modell auch nicht in den Suchergebnissen angezeigt

  @javascript @personas
  Scenario: Vorschlag wählen
    Given man befindet sich auf der Seite der Hauptkategorien
    And man wählt ein Modell von der Vorschlagsliste der Suche
    Then wird die Modell-Ansichtsseite geöffnet

  @personas
  Scenario: Suchfeld
    Given man befindet sich auf der Seite der Hauptkategorien
    Then sieht man die Suche

  @javascript @personas
  Scenario: Suchresultate anzeigen
    Given man befindet sich auf der Seite der Hauptkategorien
    And man gibt einen Suchbegriff ein
    And drückt ENTER
    Then wird die Such-Resultatseite angezeigt
    And man sieht alle gefundenen Modelle mit Bild, Modellname und Herstellername
    And man sieht die Sortiermöglichkeit
    And man sieht die Geräteparkeinschränkung
    And man sieht die Ausleihzeitraumwahl
    And die Vorschlagswerte sind verschwunden

  @javascript @personas
  Scenario: Suchbegriff mit Leerschlag anzeigen
    Given man befindet sich auf der Seite der Hauptkategorien
    When I search for models giving at least two space separated terms
    And drückt ENTER
    Then wird die Such-Resultatseite angezeigt
    And man sieht alle gefundenen Modelle mit Bild, Modellname und Herstellername


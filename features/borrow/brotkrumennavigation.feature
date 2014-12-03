
Feature: Brotkrumennavigation

  Um mich schnell durch die Applikation bewegen zu können
  möchte ich als Ausleiher
  die möglichkeit haben schnell von A nach Z zu kommen

  Background:
    Given I am Normin

  @personas
  Scenario: Brotkrumennavigation
    Given man befindet sich auf der Seite der Hauptkategorien
    Then sehe ich die Brotkrumennavigation

  @personas
  Scenario: Home-Button der Brotkrumennavigation
    Given man befindet sich auf der Seite der Hauptkategorien
    And ich sehe die Brotkrumennavigation
    Then beinhaltet diese immer an erster Stelle das Übersichtsbutton
    And dieser führt mich immer zur Seite der Hauptkategorien

  @personas
  Scenario: Hauptkategorie auswählen
    Given man befindet sich auf der Seite der Hauptkategorien
    When ich eine Hauptkategorie wähle
    Then öffnet diese Kategorie
    And die Kategorie ist das zweite und letzte Element der Brotkrumennavigation

  @javascript @personas
  Scenario: Unterkategorie auswählen
    Given man befindet sich auf der Seite der Hauptkategorien
    When ich eine Unterkategorie wähle
    Then öffnet diese Kategorie
    And die Kategorie ist das zweite und letzte Element der Brotkrumennavigation

  @personas
  Scenario: Weg bis zum Modell anzeigen
    Given man befindet sich auf der Seite der Hauptkategorien
    When ich eine Hauptkategorie wähle
    Then öffnet diese Kategorie
    And die Kategorie ist das zweite und letzte Element der Brotkrumennavigation
    When ich ein Modell öffne
    Then sehe ich den ganzen Weg den ich zum Modell beschritten habe
    And kein Element der Brotkrumennavigation ist aktiv

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

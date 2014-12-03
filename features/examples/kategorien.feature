
Feature: Kategorien

  Background:
    Given I am Mike
    And I open the inventory

  @javascript @personas
  Scenario: Top-Level-Kategorien erstellen
    When man das Register Kategorien wählt
    And man eine neue Kategorie erstellt
    And man gibt den Namen der Kategorie ein
    And I save
    Then ist die Kategorie mit dem angegegebenen Namen erstellt

  @javascript @personas
  Scenario: Kategorien anzeigen
    When man das Register Kategorien wählt
    Then sieht man die Liste der Kategorien
    And die Kategorien sind alphabetisch sortiert
    And die erste Ebene steht zuoberst
    And man kann die Unterkategorien anzeigen und verstecken

  @javascript @personas
  Scenario: Kategorien editieren
    When man eine Kategorie editiert
    And man den Namen und die Elternelemente anpasst
    And I save
    Then werden die Werte gespeichert

  @javascript @personas
  Scenario: Kategorien löschen
    When eine Kategorie nicht genutzt ist
    And man die Kategorie löscht
    Then ist die Kategorie gelöscht und alle Duplikate sind aus dem Baum entfernt
    And man bleibt in der Liste der Kategorien

  @javascript @personas
  Scenario: Kategorie löschen löscht auch alle Duplikate im Baum
    When ich eine ungenutzte Kategorie lösche die im Baum mehrmals vorhanden ist
    Then ist die Kategorie gelöscht und alle Duplikate sind aus dem Baum entfernt

  @javascript @personas
  Scenario: Kategorien nicht löschbar wenn genutzt
    When eine Kategorie genutzt ist
    Then ist es nicht möglich die Kategorie zu löschen

  @javascript @browser @personas
  Scenario: Modell der Kategorie zuteilen
    When man das Modell editiert
    And ich die Kategorien zuteile
    And ich das Modell speichere
    Then sind die Kategorien zugeteilt

  @javascript @browser @personas
  Scenario: Kategorien entfernen
    When man das Modell editiert
    And ich eine oder mehrere Kategorien entferne
    And ich das Modell speichere
    Then sind die Kategorien entfernt und das Modell gespeichert

  @javascript @browser @personas
  Scenario: Kategorie suchen
    When man nach einer Kategorie anhand des Namens sucht
    Then sieht man nur die Kategorien, die den Suchbegriff im Namen enthalten
    And sieht die Ergebnisse in alphabetischer Reihenfolge
    And man kann diese Kategorien editieren

  @javascript @browser @personas
  Scenario: nicht genutzte Kategorie suchen und löschen 
    When man nach einer ungenutzten Kategorie anhand des Namens sucht
    Then sieht man nur die Kategorien, die den Suchbegriff im Namen enthalten
    And man kann diese Kategorien löschen

  @personas
  Scenario: Kategorien
    Then man sieht das Register Kategorien

  @javascript @personas @browser
  Scenario: Kategorien erstellen
    When man das Register Kategorien wählt
    And man eine neue Kategorie erstellt
    And man gibt den Namen der Kategorie ein
    And man gibt die Elternelemente und die dazugehörigen Bezeichnungen ein
    And I add an image
    Then I can not add a second image
    When I save
    Then ist die Kategorie mit dem angegegebenen Namen und den zugewiesenen Elternelementen und dem Bild erstellt

  @personas @javascript
  Scenario: Kategorien bearbeiten
    Given there exists a category with an image
    And one edits this category
    When I remove the image
    And I add a new image
    And I save
    Then the category was saved with the new image

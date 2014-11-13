
Feature: Gruppen

  Um Benutzer in Gruppen zu organisieren und Gruppen Modell-Kapazitäten zuzuteilen
  möchte ich als Ausleih-Verwalter
  vom System Featureen bereitgestellt bekommen

  Grundlage:
    Given I am Pius

  @personas
  Scenario: Anzeige der Gruppenliste
    Given ich befinde mich im Admin-Bereich im Reiter Gruppen
    Then sehe ich die Liste der Gruppen
    And die Anzahl zugeteilter Benutzer
    And die Anzahl der zugeteilten Modell-Kapazitäten

  @personas
  Scenario: Visierungspflichtige Gruppe erstellen
    Given ich befinde mich im Admin-Bereich im Reiter Gruppen
    When ich eine Gruppe erstelle
    And ich die Eigenschaft 'Visierung erforderlich' anwähle
    And den Namen der Gruppe angebe
    And die Benutzer hinzufüge
    And die Modelle und deren Kapazität hinzufüge
    And I save
    Then ist die Gruppe gespeichert
    And die Gruppe ist visierungspflichtig
    And die Benutzer und Modelle mit deren Kapazitäten sind zugeteilt
    And ich sehe die Gruppenliste alphabetisch sortiert
    And ich sehe eine Bestätigung

  @personas
  Scenario: Gruppe editieren und als visierungspflichtig kennzeichnen
    Given ich befinde mich im Admin-Bereich im Reiter Gruppen
    When ich eine bestehende, nicht visierungspflichtige Gruppe editiere
    And ich die Eigenschaft 'Visierung erforderlich' anwähle
    And ich den Namen der Gruppe ändere
    And die Benutzer hinzufüge und entferne
    And die Modelle und deren Kapazität hinzufüge und entferne
    And I save
    Then ist die Gruppe gespeichert
    And die Gruppe ist visierungspflichtig
    And die Benutzer und Modelle mit deren Kapazitäten sind zugeteilt
    And ich sehe die Gruppenliste
    And ich sehe eine Bestätigung

  @personas
  Scenario: Gruppe ist nicht visierungspflichtig
    Given ich befinde mich im Admin-Bereich im Reiter Gruppen
    When ich eine bestehende visierungspflichtige Gruppe editiere
    And ich die Eigenschaft 'Visierung erforderlich' abwähle
    And ich den Namen der Gruppe ändere
    And die Benutzer hinzufüge und entferne
    And die Modelle und deren Kapazität hinzufüge und entferne
    And I save
    Then ist die Gruppe gespeichert
    And die Gruppe ist nicht mehr visierungspflichtig
    And die Benutzer und Modelle mit deren Kapazitäten sind zugeteilt
    And ich sehe die Gruppenliste
    And ich sehe eine Bestätigung

  @javascript @personas
  Scenario: Noch nicht zugeteilten Kapazitäten
    Given ich befinde mich im Admin-Bereich im Reiter Gruppen
    When ich eine Gruppe erstelle
    And die Modelle und deren Kapazität hinzufüge
    Then sehe ich die noch nicht zugeteilten Kapazitäten

  @javascript @personas
  Scenario: Gruppe löschen
    Given ich befinde mich im Admin-Bereich im Reiter Gruppen
    When ich eine Gruppe lösche
    And die Gruppe wurde aus der Liste gelöscht
    And die Gruppe wurde aus der Datenbank gelöscht

  @javascript @personas
  Scenario: Benutzer hinzufügen
    Given ich befinde mich im Admin-Bereich im Reiter Gruppen
    And ich eine bestehende Gruppe editiere
    When ich einen Benutzer hinzufüge
    Then wird der Benutzer zuoberst in der Liste hinzugefügt

  @personas
  Scenario: Benutzer sortieren
    Given ich befinde mich im Admin-Bereich im Reiter Gruppen
    And ich eine bestehende Gruppe editiere
    Then sind die bereits hinzugefügten Benutzer alphabetisch sortiert

  @javascript @personas
  Scenario: Modelle hinzufügen
    Given ich befinde mich im Admin-Bereich im Reiter Gruppen
    And ich eine bestehende Gruppe editiere
    When ich ein Modell hinzufüge
    Then wird das Modell zuoberst in der Liste hinzugefügt

  @personas
  Scenario: Modelle sortieren
    Given ich befinde mich im Admin-Bereich im Reiter Gruppen
    And ich eine bestehende Gruppe editiere
    Then sind die bereits hinzugefügten Modelle alphabetisch sortiert

  @javascript @personas
  Scenario: Modelle hinzufügen
    Given ich befinde mich im Admin-Bereich im Reiter Gruppen
    And ich eine bestehende Gruppe editiere
    When ich ein Modell hinzufüge
    Then wird das Modell zuoberst in der Liste hinzugefügt

  @personas
  Scenario: Modelle sortieren
    Given ich befinde mich im Admin-Bereich im Reiter Gruppen
    And ich eine bestehende Gruppe editiere
    Then sind die bereits hinzugefügten Modelle alphabetisch sortiert

  @javascript @personas
  Scenario: bereits bestehende Modelle hinzufügen
    Given ich befinde mich im Admin-Bereich im Reiter Gruppen
    And ich eine bestehende Gruppe editiere
    When ich ein bereits hinzugefügtes Modell hinzufüge
    Then wird das Modell nicht erneut hinzugefügt
    And das vorhandene Modell ist nach oben gerutscht
    And das vorhandene Modell behält die eingestellte Anzahl

  @javascript @personas
  Scenario: bereits bestehende Benutzer hinzufügen
    Given ich befinde mich im Admin-Bereich im Reiter Gruppen
    And ich eine bestehende Gruppe editiere
    When ich einen bereits hinzugefügten Benutzer hinzufüge
    Then wird der Benutzer nicht hinzugefügt
    And der vorhandene Benutzer ist nach oben gerutscht

  @personas
  Scenario: Gruppenliste Sortierung
    Given ich befinde mich im Admin-Bereich im Reiter Gruppen
    Then sehe ich die Liste der Gruppen
    And die Liste ist alphabetisch sortiert

  @javascript @personas
  Scenario: Gruppe erstellen
    Given ich befinde mich im Admin-Bereich im Reiter Gruppen
    When ich eine Gruppe erstelle
    And den Namen der Gruppe angebe
    And die Benutzer hinzufüge
    And die Modelle und deren Kapazität hinzufüge
    And I save
    Then ist die Gruppe gespeichert
    And die Gruppe ist nicht visierungspflichtig
    And die Benutzer und Modelle mit deren Kapazitäten sind zugeteilt
    And ich sehe die Gruppenliste alphabetisch sortiert
    And ich sehe eine Bestätigung

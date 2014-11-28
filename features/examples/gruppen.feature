Feature: Groups

  Background:
    Given I am Pius
    And I am in the admin area's groups section

  @personas
  Scenario: Anzeige der Gruppenliste
    When I am listing groups
    Then each group shows the number of users assigned to it
    And each group shows how many of each model are assigned to it

  # Not implemented
  @personas
  Scenario: Visierungspflichtige Gruppe erstellen
    When ich eine Gruppe erstelle
    # Next step missing
    And ich die Eigenschaft 'Visierung erforderlich' anwähle
    And den Namen der Gruppe angebe
    And die Benutzer hinzufüge
    And die Modelle und deren Kapazität hinzufüge
    And I save
    Then ist die Gruppe gespeichert
    # Next step missing
    And die Gruppe ist visierungspflichtig
    And die Benutzer und Modelle mit deren Kapazitäten sind zugeteilt
    And ich sehe die Gruppenliste alphabetisch sortiert
    And ich sehe eine Bestätigung

  @personas
  Scenario: Gruppe editieren und als visierungspflichtig kennzeichnen
    # Next step missing
    When ich eine bestehende, nicht visierungspflichtige Gruppe editiere
    # Next step missing
    And ich die Eigenschaft 'Visierung erforderlich' anwähle
    And ich den Namen der Gruppe ändere
    And die Benutzer hinzufüge und entferne
    And die Modelle und deren Kapazität hinzufüge und entferne
    And I save
    Then ist die Gruppe gespeichert
    # Next step missing
    And die Gruppe ist visierungspflichtig
    And die Benutzer und Modelle mit deren Kapazitäten sind zugeteilt
    And ich sehe die Gruppenliste
    And ich sehe eine Bestätigung

  @personas
  Scenario: Gruppe ist nicht visierungspflichtig
    # Next step missing
    When ich eine bestehende visierungspflichtige Gruppe editiere
    # Next step missing
    And ich die Eigenschaft 'Visierung erforderlich' abwähle
    And ich den Namen der Gruppe ändere
    And die Benutzer hinzufüge und entferne
    And die Modelle und deren Kapazität hinzufüge und entferne
    And I save
    Then ist die Gruppe gespeichert
    # Next step missing
    And die Gruppe ist nicht mehr visierungspflichtig
    And die Benutzer und Modelle mit deren Kapazitäten sind zugeteilt
    And ich sehe die Gruppenliste
    And ich sehe eine Bestätigung

  @javascript @personas
  Scenario: Noch nicht zugeteilten Kapazitäten
    When ich eine Gruppe erstelle
    And die Modelle und deren Kapazität hinzufüge
    Then sehe ich die noch nicht zugeteilten Kapazitäten

  @javascript @personas
  Scenario: Gruppe löschen
    When ich eine Gruppe lösche
    And die Gruppe wurde aus der Liste gelöscht
    And die Gruppe wurde aus der Datenbank gelöscht

  @javascript @personas
  Scenario: Benutzer hinzufügen
    And ich eine bestehende Gruppe editiere
    When ich einen Benutzer hinzufüge
    Then wird der Benutzer zuoberst in der Liste hinzugefügt

  @personas
  Scenario: Benutzer sortieren
    And ich eine bestehende Gruppe editiere
    Then sind die bereits hinzugefügten Benutzer alphabetisch sortiert

  @javascript @personas
  Scenario: Modelle hinzufügen
    And ich eine bestehende Gruppe editiere
    When ich ein Modell hinzufüge
    Then wird das Modell zuoberst in der Liste hinzugefügt

  @personas
  Scenario: Modelle sortieren
    And ich eine bestehende Gruppe editiere
    Then sind die bereits hinzugefügten Modelle alphabetisch sortiert

  @javascript @personas
  Scenario: Modelle hinzufügen
    And ich eine bestehende Gruppe editiere
    When ich ein Modell hinzufüge
    Then wird das Modell zuoberst in der Liste hinzugefügt

  @personas
  Scenario: Modelle sortieren
    And ich eine bestehende Gruppe editiere
    Then sind die bereits hinzugefügten Modelle alphabetisch sortiert

  @javascript @personas
  Scenario: bereits bestehende Modelle hinzufügen
    And ich eine bestehende Gruppe editiere
    When ich ein bereits hinzugefügtes Modell hinzufüge
    Then wird das Modell nicht erneut hinzugefügt
    And das vorhandene Modell ist nach oben gerutscht
    And das vorhandene Modell behält die eingestellte Anzahl

  @javascript @personas
  Scenario: bereits bestehende Benutzer hinzufügen
    And ich eine bestehende Gruppe editiere
    When ich einen bereits hinzugefügten Benutzer hinzufüge
    Then wird der Benutzer nicht hinzugefügt
    And der vorhandene Benutzer ist nach oben gerutscht

  @personas
  Scenario: Gruppenliste Sortierung
    And I am listing groups
    And die Liste ist alphabetisch sortiert

  @javascript @personas
  Scenario: Gruppe erstellen
    When ich eine Gruppe erstelle
    And den Namen der Gruppe angebe
    And die Benutzer hinzufüge
    And die Modelle und deren Kapazität hinzufüge
    And I save
    Then ist die Gruppe gespeichert
    # Next step missing
    And die Gruppe ist nicht visierungspflichtig
    And die Benutzer und Modelle mit deren Kapazitäten sind zugeteilt
    And ich sehe die Gruppenliste alphabetisch sortiert
    And ich sehe eine Bestätigung

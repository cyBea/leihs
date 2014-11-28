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
    When I create a group
    # Next step missing
    And ich die Eigenschaft 'Visierung erforderlich' anwähle
    And I fill in the group's name
    And I add users to the group
    And I add models and capacities to the group
    And I save
    Then the group is saved
    # Next step missing
    And die Gruppe ist visierungspflichtig

    And the group has users as well as models and their capacities

  @personas
  Scenario: Mark a group as requiring verification
    # Next step missing
    When ich eine bestehende, nicht visierungspflichtige Gruppe editiere
    # Next step missing
    And ich die Eigenschaft 'Visierung erforderlich' anwähle
    And I change the group's name
    And I add and remove users from the group
    And I add and remove models and their capacities from the group
    And I save
    Then the group is saved
    # Next step missing
    And die Gruppe ist visierungspflichtig
    And users as well as models and their capacities are added to the group
    Then I am listing groups
    And I receive a notification of success

  @personas
  Scenario: Group does not require verification
    # Next step missing
    When ich eine bestehende visierungspflichtige Gruppe editiere
    # Next step missing
    And I change the group's name
    And I add and remove users from the group
    And I add and remove models and their capacities from the group
    And I save
    Then the group is saved
    # Next step missing
    And die Gruppe ist nicht mehr visierungspflichtig
    And users as well as models and their capacities are added to the group
    Then I am listing groups
    And I receive a notification of success

  @javascript @personas
  Scenario: Capacities still available for assignment
    When I create a group
    And I add users to the group
    And I add models and capacities to the group
    Then I see any capacities that are still available for assignment

  @javascript @personas
  Scenario: Deleting groups
    When I delete a group
    # Next step missing
    #And die Gruppe wurde aus der Liste gelöscht
    And the group has been deleted from the database

  @javascript @personas
  Scenario: Benutzer hinzufügen
    And ich eine bestehende Gruppe editiere
    When ich einen Benutzer hinzufüge
    Then wird der Benutzer zuoberst in der Liste hinzugefügt

  @javascript @personas
  Scenario: Modelle hinzufügen
    And ich eine bestehende Gruppe editiere
    When ich ein Modell hinzufüge
    Then wird das Modell zuoberst in der Liste hinzugefügt

  @personas
  Scenario: Modelle sortieren
    When I edit an existing group
    Then the already present models are sorted alphabetically

  @javascript @personas
  Scenario: Modelle hinzufügen
    And ich eine bestehende Gruppe editiere
    When ich ein Modell hinzufüge
    Then wird das Modell zuoberst in der Liste hinzugefügt


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
    When I am listing groups
    Then the list is sorted alphabetically

  @javascript @personas
  Scenario: Creating a group
    When I create a group
    And I fill in the group's name
    And I add users to the group
    And I add models and capacities to the group
    And I save
    Then the group is saved
    And I receive a notification of success
    And the group has users as well as models and their capacities
    When I am listing groups

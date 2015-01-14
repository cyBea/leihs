
Feature: Managing templates

  Background:
    Given I am Mike

  @personas
  Scenario: Show list of all templates
    When I click on "Templates" in the inventory area
    Then I see a list of currently available templates for the current inventory pool
    And the templates are ordered alphabetically by their names

  @javascript @browser @personas
  Scenario: Create template
    Given I am listing templates 
    When I click the button "New Template"
    Then I can create a new template
    When I enter the template's name
    And I add some models to the template
    Then each model shows the maximum number of available items
    And each model I've added has the minimum quantity 1
    When I enter a quantity for each model
    And I save
    Then I am listing templates
    And the template and all the entered information are saved

  @javascript @personas
  Scenario: Prüfen, ob max. Anzahl bei den Modellen überschritten ist
    And ich befinde mich der Seite zur Erstellung einer neuen Vorlage
    And ich habe den Namen der Vorlage eingegeben
    When ich Modelle hinzufüge
    And ich bei einem Modell eine Anzahl eingebe, welche höher ist als die höchst mögliche ausleihbare Anzahl der Gegenstände für dieses Modell
    When I save
    Then ich sehe eine Warnmeldung wegen nicht erfüllbaren Vorlagen
    And die neue Vorlage wurde mit all den erfassten Informationen erfolgreich gespeichert
    And die Vorlage ist in der Liste als unerfüllbar markiert
    When ich die gleiche Vorlage bearbeite
    And ich die korrekte Anzahl angebe
    And I save
    Then ich sehe die Erfolgsbestätigung
    And die bearbeitete Vorlage wurde mit all den erfassten Informationen erfolgreich gespeichert
    And die Vorlage ist in der Liste nicht als unerfüllbar markiert

  @javascript @personas
  Scenario: Vorlage löschen
    And ich befinde mich auf der Liste der Vorlagen
    Then kann ich beliebige Vorlage direkt aus der Liste löschen
    And die Vorlage wurde aus der Liste gelöscht
    And die Vorlage wurde erfolgreich aus der Datenbank gelöscht

  @javascript @personas
  Scenario: Vorlage ändern
    And ich befinde mich auf der Liste der Vorlagen
    And es existiert eine Vorlage mit mindestens zwei Modellen
    When ich auf den Button "Vorlage bearbeiten" klicke
    Then öffnet sich die Seite zur Bearbeitung einer existierenden Vorlage
    When ich den Namen ändere
    And ein Modell aus der Liste lösche
    And ich ein zusätzliches Modell hinzufüge
    Then für das hinzugefügte Modell ist die Mindestanzahl 1
    And die Anzahl bei einem der Modell ändere
    And I save
    Then ich wurde auf die Liste der Vorlagen weitergeleitet
    And ich sehe die Erfolgsbestätigung
    And die bearbeitete Vorlage wurde mit all den erfassten Informationen erfolgreich gespeichert

  @javascript @personas
  Scenario: Pflichtangaben bei der Editieransicht
    And ich befinde mich auf der Editieransicht einer Vorlage
    When der Name nicht ausgefüllt ist
    And es ist mindestens ein Modell dem Template hinzugefügt
    And I save
    Then I see an error message
    When ich den Name ausgefüllt habe
    And kein Modell hinzugefügt habe
    And I save
    Then I see an error message

  @javascript @personas
  Scenario: Pflichtangaben bei der Erstellungsansicht
    And ich befinde mich auf der Erstellungsansicht einer Vorlage
    When der Name nicht ausgefüllt ist
    And es ist mindestens ein Modell dem Template hinzugefügt
    And I save
    Then I see an error message
    When ich den Name ausgefüllt habe
    And kein Modell hinzugefügt habe
    And I save
    Then I see an error message

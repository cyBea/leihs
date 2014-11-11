
Feature: Vorlagen verwalten

  Als Ausleihe-Verwalter / Inventar-Verwalter möchte ich 
  die Möglichkeit haben, Vorlagen zu verwalten

  Grundlage:
    Given I am Mike

  @personas
  Scenario: Liste aller Vorlagen anzeigen
    When ich im Inventarbereich auf den Link "Vorlagen" klicke
    Then öffnet sich die Seite mit der Liste der im aktuellen Inventarpool erfassten Vorlagen
    And die Vorlagen für dieses Inventarpool sind alphabetisch nach Namen sortiert

  @javascript @browser @personas
  Scenario: Vorlage erstellen
    And ich befinde mich auf der Liste der Vorlagen
    When ich auf den Button "Neue Vorlage" klicke
    Then öffnet sich die Seite zur Erstellung einer neuen Vorlage
    When ich den Namen der Vorlage eingebe
    And ich Modelle hinzufüge
    Then steht bei jedem Modell die höchst mögliche ausleihbare Anzahl der Gegenstände für dieses Modell
    And für jedes hinzugefügte Modell ist die Mindestanzahl 1
    When ich zu jedem Modell die Anzahl angebe
    And ich speichere
    Then ich wurde auf die Liste der Vorlagen weitergeleitet
    And ich sehe die Erfolgsbestätigung
    And die neue Vorlage wurde mit all den erfassten Informationen erfolgreich gespeichert

  @javascript @personas
  Scenario: Prüfen, ob max. Anzahl bei den Modellen überschritten ist
    And ich befinde mich der Seite zur Erstellung einer neuen Vorlage
    And ich habe den Namen der Vorlage eingegeben
    When ich Modelle hinzufüge
    And ich bei einem Modell eine Anzahl eingebe, welche höher ist als die höchst mögliche ausleihbare Anzahl der Gegenstände für dieses Modell
    When ich speichere
    Then ich sehe eine Warnmeldung wegen nicht erfüllbaren Vorlagen
    And die neue Vorlage wurde mit all den erfassten Informationen erfolgreich gespeichert
    And die Vorlage ist in der Liste als unerfüllbar markiert
    When ich die gleiche Vorlage bearbeite
    And ich die korrekte Anzahl angebe
    And ich speichere
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
    And ich speichere
    Then ich wurde auf die Liste der Vorlagen weitergeleitet
    And ich sehe die Erfolgsbestätigung
    And die bearbeitete Vorlage wurde mit all den erfassten Informationen erfolgreich gespeichert

  @javascript @personas
  Scenario: Pflichtangaben bei der Editieransicht
    And ich befinde mich auf der Editieransicht einer Vorlage
    When der Name nicht ausgefüllt ist
    And es ist mindestens ein Modell dem Template hinzugefügt
    And ich speichere
    Then I see an error message
    When ich den Name ausgefüllt habe
    And kein Modell hinzugefügt habe
    And ich speichere
    Then I see an error message

  @javascript @personas
  Scenario: Pflichtangaben bei der Erstellungsansicht
    And ich befinde mich auf der Erstellungsansicht einer Vorlage
    When der Name nicht ausgefüllt ist
    And es ist mindestens ein Modell dem Template hinzugefügt
    And ich speichere
    Then I see an error message
    When ich den Name ausgefüllt habe
    And kein Modell hinzugefügt habe
    And ich speichere
    Then I see an error message

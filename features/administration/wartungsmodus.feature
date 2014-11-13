
Feature: Wartungsmodus

Als Administrator möchte ich die Möglichkeit haben,
für die Bereiche "Verwalten" und "Verleih" bei Wartungsarbeiten das System zu sperren und dem Benutzer eine Meldung anzuzeigen

  Grundlage:
    Given I am Gino

  @javascript @personas
  Scenario: Verwalten-Bereich sperren
    Given ich befinde mich in den Pool-übergreifenden Einstellungen
    When ich die Funktion "Verwaltung sperren" wähle
    Then muss ich eine Bemerkung angeben
    When ich eine Bemerkung für "Verwalten-Bereich" angebe
    And I save
    Then wurde die Einstellung für "Verwalten-Bereich" erfolgreich gespeichert
    And der Bereich "Verwalten" ist für die Benutzer gesperrt
    And dem Benutzer wird die eingegebene Bemerkung angezeigt

  @javascript @personas
  Scenario: Ausleihen-Bereich sperren
    Given ich befinde mich in den Pool-übergreifenden Einstellungen
    When ich die Funktion "Ausleihen sperren" wähle
    Then muss ich eine Bemerkung angeben
    When ich eine Bemerkung für "Ausleihen-Bereich" angebe
    And I save
    Then wurde die Einstellung für "Ausleihen-Bereich" erfolgreich gespeichert
    And der Bereich "Ausleihen" ist für die Benutzer gesperrt
    And dem Benutzer wird die eingegebene Bemerkung angezeigt

  @javascript @personas
  Scenario: Verwalten-Bereich entsperren
    Given der "Verwalten" Bereich ist gesperrt
    And ich befinde mich in den Pool-übergreifenden Einstellungen
    When ich die Funktion "Verwaltung sperren" deselektiere
    And I save
    Then ist der Bereich "Verwalten" für den Benutzer nicht mehr gesperrt
    And die eingegebene Meldung für "Verwalten" Bereich ist immer noch gespeichert

  @javascript @personas
  Scenario: Ausleihen-Bereich entsperren
    Given der "Ausleihen" Bereich ist gesperrt
    And ich befinde mich in den Pool-übergreifenden Einstellungen
    When ich die Funktion "Ausleihen sperren" deselektiere
    And I save
    Then ist der Bereich "Ausleihen" für den Benutzer nicht mehr gesperrt
    And die eingegebene Meldung für "Ausleihen" Bereich ist immer noch gespeichert

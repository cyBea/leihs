
Feature: Timeout Page

  @personas
  Scenario: Bestellung abgelaufen
    Given I am Normin
    And ich zur Timeout Page mit einem Konfliktmodell weitergeleitet werde
    And I have added items to an order
    And die letzte Aktivität auf meiner Bestellung ist mehr als 30 minuten her
    When ich die Seite der Hauptkategorien besuche
    Then lande ich auf der Bestellung-Abgelaufen-Seite
    And ich sehe eine Information, dass die Geräte nicht mehr reserviert sind

  @personas
  Scenario: Ansicht
    Given I am Normin
    And ich zur Timeout Page mit einem Konfliktmodell weitergeleitet werde
    Then sehe ich meine Bestellung
    And die nicht mehr verfügbaren Modelle sind hervorgehoben
    And ich kann Einträge löschen
    And ich kann Einträge editieren
    And ich kann zur Hauptübersicht

  @javascript @browser @personas
  Scenario: Eintrag löschen
    Given I am Normin
    And ich zur Timeout Page mit einem Konfliktmodell weitergeleitet werde
    And ich lösche einen Eintrag
    Then wird der Eintrag aus der Bestellung gelöscht

  @javascript @browser @personas
  Scenario: In Bestellung übernehmen nicht möglich
    Given I am Normin
    And ich zur Timeout Page mit 2 Konfliktmodellen weitergeleitet werde
    When I click on "Continue this order"
    Then lande ich wieder auf der Timeout Page
    And ich erhalte einen Fehler
    When ich einen der Fehler korrigiere
    When I click on "Continue this order"
    Then lande ich wieder auf der Timeout Page
    And ich erhalte einen Fehler
    When ich alle Fehler korrigiere
    Then verschwindet die Fehlermeldung

  @personas
  Scenario: Bestellung löschen
    Given I am Normin
    And ich zur Timeout Page mit einem Konfliktmodell weitergeleitet werde
    When ich die Bestellung lösche
    Then werden die Modelle meiner Bestellung freigegeben
    And wird die Bestellung des Benutzers gelöscht
    And ich lande auf der Seite der Hauptkategorien

  @personas
  Scenario: Nur verfügbare Modelle aus Bestellung übernehmen
    Given I am Normin
    And ich zur Timeout Page mit einem Konfliktmodell weitergeleitet werde
    When ein Modell nicht verfügbar ist
    And I click on "Continue with available models only"
    Then werden die nicht verfügbaren Modelle aus der Bestellung gelöscht
    And ich lande auf der Seite der Bestellübersicht
    And ich sehe eine Information, dass alle Geräte wieder verfügbar sind

  @javascript @browser @personas
  Scenario: Eintrag ändern
    Given I am Normin
    And ich zur Timeout Page mit einem Konfliktmodell weitergeleitet werde
    And ich einen Eintrag ändere
    Then werden die Änderungen gespeichert
    And lande ich wieder auf der Timeout Page

  @javascript @browser @personas
  Scenario: Die Menge eines Eintrags heruntersetzen
    Given I am Normin
    And ich zur Timeout Page mit einem Konfliktmodell weitergeleitet werde
    When ich die Menge eines Eintrags heraufsetze
    Then werden die Änderungen gespeichert
    When ich die Menge eines Eintrags heruntersetze
    Then werden die Änderungen gespeichert
    And lande ich wieder auf der Timeout Page

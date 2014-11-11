
Feature: Umleitung zur Anmeldung

  Um Aktionen als authentifizierter Benutzer durchführen zu können
  möchte ich als Benutzer
  vom System darauf hingewiesen werden sobald ich abgemeldet bin

  @javascript @personas
  Scenario: Ausführung einer Aktion für authentifizierte Benutzer ohne angemeldet zu sein
    Given I am Pius
    And versuche eine Aktion im Backend auszuführen obwohl ich abgemeldet bin
    Then werden ich auf die Startseite weitergeleitet
    And sehe einen Hinweis, dass ich nicht angemeldet bin
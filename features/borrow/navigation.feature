
Feature: Navigation

  Um mich durch die Applikation navigieren zu können
  möchte ich als Ausleiher
  Navigationsmöglichkeiten haben

  @personas
  Scenario: Navigation für Ausleihenden
    Given I am Normin
    And man befindet sich auf der Seite der Hauptkategorien
    Then seh ich die Navigation
    And die Navigation beinhaltet "Abzuholen"
    And die Navigation beinhaltet "Rückgaben"
    And die Navigation beinhaltet "Bestellungen"
    And die Navigation beinhaltet "Geräteparks"
    And die Navigation beinhaltet "Benutzer"
    And die Navigation beinhaltet "Logout"

  @personas
  Scenario: Navigation für Manager
    Given I am Pius
    And man befindet sich auf der Seite der Hauptkategorien
    Then seh ich die Navigation
    And die Navigation beinhaltet "Abzuholen"
    And die Navigation beinhaltet "Rückgaben"
    And die Navigation beinhaltet "Bestellungen"
    And die Navigation beinhaltet "Geräteparks"
    And die Navigation beinhaltet "Verwalten"
    And die Navigation beinhaltet "Benutzer"
    And die Navigation beinhaltet "Logout"

  @personas
  Scenario: Navigation für Prüfer
    Given I am Andi
    And man befindet sich auf der Seite der Hauptkategorien
    Then seh ich die Navigation
    And die Navigation beinhaltet "Abzuholen"
    And die Navigation beinhaltet "Rückgaben"
    And die Navigation beinhaltet "Bestellungen"
    And die Navigation beinhaltet "Geräteparks"
    And die Navigation beinhaltet "Verwalten"
    And die Navigation beinhaltet "Benutzer"
    And die Navigation beinhaltet "Logout"

  @personas
  Scenario: Home-Button
    Given I am Normin
    Then seh ich in der Navigation den Home-Button
    When ich den Home-Button bediene
    Then lande ich auf der Seite der Hauptkategorien

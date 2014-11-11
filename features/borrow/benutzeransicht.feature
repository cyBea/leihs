
Feature: Benutzeransicht

  Als Benutzer möchte ich die Möglichkeit haben meine Benutzerdaten zu sehen

  Grundlage:
    Given I am Normin

  @personas
  Scenario: Benutzerdaten ansehen
    When ich auf meinen Namen klicke
    Then gelange ich auf die Seite der Benutzerdaten
    And werden mir meine Benutzerdaten angezeigt
    And die Benutzerdaten beinhalten
    |Vorname|
    |Nachname|
    |E-Mail|
    |Telefon|

  @javascript @personas
  Scenario: Benutzerdaten unter dem Benutzername
    When ich über meinen Namen fahre
    Then sehe ich im Dropdown eine Schaltfläche die zur Benutzeransicht führt

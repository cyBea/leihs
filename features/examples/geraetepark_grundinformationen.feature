
Feature: Basic information for inventory pools

  As a person responsible for managing inventory pools
  I want to be able to change their settings and supply basic information
  So that each inventory pool has all the information and settings they
  need to work efficiently (e.g. opening hours, proper addresses, etc.)

  @javascript @personas
  Scenario: Make basic settings
    Given I am Mike
    When I navigate to the inventory pool section in the admin area
    Then I can enter the inventory pool's basic settings as follows:
    | Name |
    | Short Name |
    | E-Mail |
    | Description |
    | Default Contract Note|
    | Print Contracts |
    | Automatic access |
    And I make a note of which page I'm on
    And I save
    Then I see a confirmation that the information was saved
    And the settings are updated
    And I am still on the same page

  @personas
  Scenario: Pflichtfelder der Grundinformationen zusammen prüfen
    Given I am Mike
    When I edit the current inventory pool
    And I leave the following fields empty:
      | Name       |
      | Short Name |
      | E-Mail     |
    And I save
    Then I see an error message

  @personas
  Scenario: Aut. zuweisen beim Benutzererstellen ausserhalb des Geräteparks
    Given I am Gino
    And es ist bei mehreren Geräteparks aut. Zuweisung aktiviert
    And man befindet sich auf der Benutzerliste
    When ich einen Benutzer mit Login "username" und Passwort "password" erstellt habe
    Then kriegt der neu erstellte Benutzer bei allen Geräteparks mit aut. Zuweisung die Rolle 'Kunde'

  @personas
  Scenario: Aut. zuweisen beim Benutzererstellen innerhalb des Geräteparks
    Given I am Mike
    And es ist bei mehreren Geräteparks aut. Zuweisung aktiviert
    And es ist bei meinem Gerätepark aut. Zuweisung aktiviert
    When ich in meinem Gerätepark einen neuen Benutzer mit Rolle 'Inventar-Verwalter' erstelle
    Then kriegt der neu erstellte Benutzer bei allen Geräteparks mit aut. Zuweisung ausser meinem die Rolle 'Kunde'
    And in meinem Gerätepark hat er die Rolle 'Inventar-Verwalter'

  #72676850
  @personas @javascript
  Scenario: Aut. Zuweisen entfernen
    Given I am Mike
    And es ist bei mehreren Geräteparks aut. Zuweisung aktiviert
    And ich editiere eine Gerätepark bei dem die aut. Zuweisung aktiviert ist
    When ich die aut. Zuweisung deaktiviere
    And I save
    Then ist die aut. Zuweisung deaktiviert
    Given I am Gino
    And man befindet sich auf der Benutzerliste
    When ich einen Benutzer mit Login "username" und Passwort "password" erstellt habe
    Then kriegt der neu erstellte Benutzer bei dem vorher editierten Gerätepark kein Zugriffsrecht

  #72676850
  @personas
  Scenario Outline: Checkboxen abwählen
    Given I am Mike
    And ich editiere eine Gerätepark
    When ich "<Checkbox>" aktiviere
    And I save
    Then ist "<Checkbox>" aktiviert
    When ich "<Checkbox>" deaktiviere
    And I save
    Then ist "<Checkbox>" deaktiviert
    Examples:
      | Checkbox                |
      | Verträge drucken        |
      | Automatische Sperrung   |
      | Automatischer Zugriff   |

  @personas
  Scenario: Arbeitstage verwalten
   Given I am Mike
   And I edit my inventory pool settings
   When ich die Arbeitstage Montag, Dienstag, Mittwoch, Donnerstag, Freitag, Samstag, Sonntag ändere
   And I save
   Then sind die Arbeitstage gespeichert

  @javascript @personas
  Scenario: Tage der Ausleihschliessung verwalten
   Given I am Mike
   And I edit my inventory pool settings
   When ich eine oder mehrere Zeitspannen und einen Namen für die Ausleihsschliessung angebe
   And I save
   Then werden die Ausleihschliessungszeiten gespeichert
   And ich kann die Ausleihschliessungszeiten wieder löschen

  @personas
  Scenario Outline: Pflichtfelder der Grundinformationen einzeln prüfen
    Given I am Mike
    When ich die Grundinformationen des Geräteparks abfüllen möchte
    And jedes Pflichtfeld des Geräteparks ist gesetzt
    | Name        |
    | Kurzname    |
    | E-Mail      |
    When ich das gekennzeichnete "<Pflichtfeld>" des Geräteparks leer lasse
    Then kann das Gerätepark nicht gespeichert werden
    And I see an error message
    And die anderen Angaben wurde nicht gelöscht
    Examples:
      | Pflichtfeld |
      | Name        |
      | Kurzname    |
      | E-Mail      |

  @personas
  Scenario: Automatische Benutzersperrung bei verspäteter Rückgabe
    Given I am Mike
    When ich die Grundinformationen des Geräteparks abfüllen möchte
    When ich für den Gerätepark die automatische Sperrung von Benutzern mit verspäteten Rückgaben einschalte
    Then muss ich einen Sperrgrund angeben
    When I save
    Then ist diese Konfiguration gespeichert
    When ein Benutzer wegen verspäteter Rückgaben automatisch gesperrt wird
    Then wird er für diesen Gerätepark gesperrt bis zum '1.1.2099'
    And der Sperrgrund ist derjenige, der für diesen Park gespeichert ist
    When ich "Automatische Sperrung" deaktiviere
    And I save
    Then ist "Automatische Sperrung" deaktiviert

  @personas
  Scenario: Automatische Benutzersperrung nur wenn Benutzer nicht schon gesperrt
    Given I am Mike
    When on the inventory pool I enable the automatic suspension for users with overdue take backs
    And a user is already suspended for this inventory pool
    Then the existing suspension motivation and the suspended time for this user are not overwritten


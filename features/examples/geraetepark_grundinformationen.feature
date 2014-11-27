
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
  Scenario: Automatically grant access to new users
    Given I am Gino
    And multiple inventory pools are granting automatic access
    And I am listing users
    When I have created a user with login "username" and password "password"
    Then the newly created user has 'customer'-level access to all inventory pools that grant automatic access

  @personas
  Scenario: Automatically grant access to new users from within my own inventory pool's settings
    Given I am Mike
    And multiple inventory pools are granting automatic access
    And my inventory pool is granting automatic access
    When I create a new user with the 'inventory manager' role in my inventory pool
    Then the newly created user has 'customer'-level access to all inventory pools that grant automatic access, but not to mine
    And in my inventory pool the user gets the role 'inventory manager'

  #72676850
  @personas @javascript
  Scenario: Aut. Zuweisen entfernen
    Given I am Mike
    And multiple inventory pools are granting automatic access
    And I edit an inventory pool that is granting automatic access
    When I disable automatic access
    And I save
    Then automatic access is disabled
    Given I am Gino
    And I am listing users
    When I have created a user with login "username" and password "password"
    Then the newly created user does not have access to that inventory pool

  #72676850
  @personas
  Scenario Outline: Deselect checkboxes
    Given I am Mike
    And I edit an inventory pool
    When I enable "<checkbox>"
    And I save
    Then "<checkbox>" is enabled
    When I disable "<checkbox>"
    And I save
    Then "<checkbox>" is disabled
    Examples:
      | checkbox                |
      | Print contracts        |
      | Automatic suspension   |
      | Automatic access   |

  @personas
  Scenario: Manage workdays
   Given I am Mike
   And I edit my inventory pool settings
   When I randomly set the workdays monday, tuesday, wednesday, thursday, friday, saturday and sunday to open or closed
   And I save
   Then those randomly chosen workdays are saved

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


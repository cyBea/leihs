
Feature: Administer inventory pools

  As an administrator
  I want to have admin tools spanning the entire system
  So that I can create, update and edit inventory pools

  @javascript @personas
  Scenario: Choosing an inventory pool
    Given I am Gino
    When I navigate to the admin area
    Then I see the list of inventory pools
    When I click on the inventory pool selection toggler again
    Then I see all the inventory pools
    And the list of inventory pools is sorted alphabetically

  @personas
  Scenario: Creating an initial inventory pool
    Given I am Gino
    When I create a new inventory pool in the admin area's inventory pool tab
    And I enter name, shortname and email address
    And I save
    Then I see all the inventory pools
    And I receive a notification
    And the inventory pool is saved

  @personas
  Scenario Outline: Pflichtfelder beim erstmaligen Erstellen eines Geräteparks
    Given I am Ramon
    When ich im Admin-Bereich unter dem Reiter Geräteparks einen neuen Gerätepark erstelle
    And ich <Pflichtfeld> nicht eingebe
    And I save
    Then wird mir eine Fehlermeldung angezeigt
    And der Gerätepark wird nicht erstellt

    Examples:
      | Pflichtfeld |
      | Name        |
      | Kurzname    |
      | E-Mail      |

  @personas
  Scenario: Gerätepark ändern
    Given I am Ramon
    When ich im Admin-Bereich unter dem Reiter Geräteparks einen bestehenden Gerätepark ändere
    And ich Name und Kurzname und Email ändere
    And I save
    Then ist der Gerätepark und die eingegebenen Informationen gespeichert

  @javascript @personas
  Scenario: Gerätepark löschen
    Given I am Ramon
    When ich im Admin-Bereich unter dem Reiter Geräteparks einen bestehenden Gerätepark lösche
    And der Gerätepark wurde aus der Liste gelöscht
    And der Gerätepark wurde aus der Datenbank gelöscht

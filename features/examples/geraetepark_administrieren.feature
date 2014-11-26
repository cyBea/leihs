
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
  Scenario Outline: Required fields when creating an inventory pool
    Given I am Ramon
    When I create a new inventory pool in the admin area's inventory pool tab
    And I don't enter <required_field>
    And I save
    Then I see an error message
    And the inventory pool is not created

    Examples:
      | required_field |
      | Name        |
      | Short Name    |
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

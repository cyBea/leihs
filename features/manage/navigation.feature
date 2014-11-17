
Feature: Navigation

  @personas
  Scenario: Navigation für Gruppen-Verwalter
    Given I am Andi
    And I visit the lending section
    Then seh ich die Navigation
    And die Navigation beinhaltet "Verleih"
    And die Navigation beinhaltet "Ausleihen"
    And die Navigation beinhaltet "Benutzer"

  @personas
  Scenario: Navigation für Gruppen-Verwalter in Verleih-Bereich
    Given I am Andi
    And I visit the lending section
    Then seh ich die Navigation
    And kann man auf ein der "Bestellungen" Tab klichen
    And kann man auf ein der "Verträge" Tab klichen
    And man sieht die Gerätepark-Auswahl im Verwalten-Bereich

  @personas
  Scenario: Aufklappen der Geraeteparkauswahl und Wechsel des Geraeteparks
    Given I am Mike
    When ich auf die Geraetepark-Auswahl klicke
    Then I see all inventory pools for which I am a manager
    When I click on one of the inventory pools
    Then I switch to that inventory pool

  @personas @javascript
  Scenario: Zuklappen der Geraeteparkauswahl
    Given I am Mike
    When ich auf die Geraetepark-Auswahl klicke
    Then I see all inventory pools for which I am a manager
    When I click somewhere outside of the inventory pool menu list
    Then the inventory pool menu list closes
    When ich auf die Geraetepark-Auswahl klicke
    Then I see all inventory pools for which I am a manager
    When ich erneut auf die Geraetepark-Auswahl klicke
    Then the inventory pool menu list closes

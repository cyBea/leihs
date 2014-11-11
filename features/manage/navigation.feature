
Feature: Navigation

  @personas
  Scenario: Navigation für Gruppen-Verwalter
    Given I am Andi
    And man befindet sich im Verleih-Bereich
    Then seh ich die Navigation
    And die Navigation beinhaltet "Verleih"
    And die Navigation beinhaltet "Ausleihen"
    And die Navigation beinhaltet "Benutzer"

  @personas
  Scenario: Navigation für Gruppen-Verwalter in Verleih-Bereich
    Given I am Andi
    And man befindet sich im Verleih-Bereich
    Then seh ich die Navigation
    And kann man auf ein der "Bestellungen" Tab klichen
    And kann man auf ein der "Verträge" Tab klichen
    And man sieht die Gerätepark-Auswahl im Verwalten-Bereich

  @personas
  Scenario: Aufklappen der Geraeteparkauswahl und Wechsel des Geraeteparks
    Given I am Mike
    When ich auf die Geraetepark-Auswahl klicke
    Then sehe ich alle Geraeteparks, zu denen ich Zugriff als Verwalter habe
    When ich auf einen Geraetepark klicke
    Then wechsle ich zu diesem Geraetepark

  @personas @javascript
  Scenario: Zuklappen der Geraeteparkauswahl
    Given I am Mike
    When ich auf die Geraetepark-Auswahl klicke
    Then sehe ich alle Geraeteparks, zu denen ich Zugriff als Verwalter habe
    When ich ausserhalb der Geraetepark-Auswahl klicke
    Then schliesst sich die Geraetepark-Auswahl
    When ich auf die Geraetepark-Auswahl klicke
    Then sehe ich alle Geraeteparks, zu denen ich Zugriff als Verwalter habe
    When ich erneut auf die Geraetepark-Auswahl klicke
    Then schliesst sich die Geraetepark-Auswahl


Feature: Displaying problems

  Background:
    Given I am Pius

  @javascript @browser @personas
  Scenario: Showing problems in an order when a model is not avaiable
    #Given ich editiere eine Bestellung die nicht in der Vergangenheit liegt
    Given I edit an order
    And a model is no longer available
    Then I see any problems displayed on the relevant lines
     And the problem is displayed as: "Nicht verfügbar 2(3)/7"
     And "2" are available for the user, also counting availability from groups the user is member of
     And "3" are available in total, also counting availability from groups the user is not member of
     And "7" are in this inventory pool (and borrowable)

  @javascript @browser @personas
  Scenario: Showing problems in an order when taking back a defective item
    Given I take back an item
    And one item is defective
     Then the affected item's line shows the item's problems
     And the problem is displayed as: "Gegenstand ist defekt"

  @javascript @personas @browser
  Scenario: Problemanzeige bei Aushändigung wenn Gegenstand defekt
    Given I am doing a hand over
     And eine Gegenstand ist defekt
     Then sehe ich auf der Linie des betroffenen Gegenstandes die Auszeichnung von Problemen
     And das Problem wird wie folgt dargestellt: "Gegenstand ist defekt"

  @javascript @browser @personas
  Scenario: Problemanzeige bei Rücknahme wenn Gegenstand unvollständig
    Given I take back an item
     And eine Gegenstand ist unvollständig
     Then sehe ich auf der Linie des betroffenen Gegenstandes die Auszeichnung von Problemen
     And das Problem wird wie folgt dargestellt: "Gegenstand ist unvollständig"

  @javascript @personas
  Scenario: Problemanzeige bei Aushändigung wenn Gegenstand nicht ausleihbar
    Given I am doing a hand over
     And eine Gegenstand ist nicht ausleihbar
     Then sehe ich auf der Linie des betroffenen Gegenstandes die Auszeichnung von Problemen
     And das Problem wird wie folgt dargestellt: "Gegenstand nicht ausleihbar"

  @javascript @browser @personas
  Scenario: Problemanzeige bei Rücknahme wenn Gegenstand nicht ausleihbar
    Given I take back an item
    And eine Gegenstand ist nicht ausleihbar
    Then sehe ich auf der Linie des betroffenen Gegenstandes die Auszeichnung von Problemen
    And das Problem wird wie folgt dargestellt: "Gegenstand nicht ausleihbar"

  @personas @javascript
  Scenario: Problemanzeige wenn Modell nicht verfügbar bei Aushändigung
    Given I am doing a hand over
     And eine Model ist nichtmehr verfügbar
     Then sehe ich auf den beteiligten Linien die Auszeichnung von Problemen
     And das Problem wird wie folgt dargestellt: "Nicht verfügbar 2(3)/7"
     And "2" sind verfügbar für den Kunden inklusive seinen Gruppenzugehörigen
     And "3" sind insgesamt verfügbar inklusive diejenigen Gruppen, welchen der Kunde nicht angehört
     And "7" sind total im Pool bekannt (ausleihbar)

  @personas
  Scenario: Problemanzeige wenn Modell nicht verfügbar bei Rücknahmen
    Given ich mache eine Rücknahme, die nicht überfällig ist
     And eine Model ist nichtmehr verfügbar
     Then sehe ich auf den beteiligten Linien die Auszeichnung von Problemen
     And das Problem wird wie folgt dargestellt: "Nicht verfügbar 2(3)/7"
     And "2" sind verfügbar für den Kunden inklusive seinen Gruppenzugehörigen
     And "3" sind insgesamt verfügbar inklusive diejenigen Gruppen, welchen der Kunde nicht angehört
     And "7" sind total im Pool bekannt (ausleihbar)

  @javascript @personas @browser
  Scenario: Problemanzeige bei Aushändigung wenn Gegenstand unvollständig
    Given I am doing a hand over
     And eine Gegenstand ist unvollständig
     Then sehe ich auf der Linie des betroffenen Gegenstandes die Auszeichnung von Problemen
     And das Problem wird wie folgt dargestellt: "Gegenstand ist unvollständig"

  @javascript @personas
  Scenario: Problemanzeige bei Rücknahme wenn verspätet
    Given I take back a late item
     Then sehe ich auf der Linie des betroffenen Gegenstandes die Auszeichnung von Problemen
     And das Problem wird wie folgt dargestellt: "Überfällig seit 6 Tagen"

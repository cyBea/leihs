
Feature: Anzeige von Problemen

  Background:
    Given I am Pius

  @javascript @browser @personas
  Scenario: Problemanzeige wenn Modell nicht verfügbar bei Bestellungen
    Given ich editiere eine Bestellung die nicht in der Vergangenheit liegt
     And ein Modell ist nichtmehr verfügbar
     Then sehe ich auf den beteiligten Linien die Auszeichnung von Problemen
     And das Problem wird wie folgt dargestellt: "Nicht verfügbar 2(3)/7"
     And "2" sind verfügbar für den Kunden inklusive seinen Gruppenzugehörigen
     And "3" sind insgesamt verfügbar inklusive diejenigen Gruppen, welchen der Kunde nicht angehört
     And "7" sind total im Pool bekannt (ausleihbar)

  @javascript @browser @personas
  Scenario: Problemanzeige bei Rücknahme wenn Gegenstand defekt
    Given I take back an item
     And eine Gegenstand ist defekt
     Then sehe ich auf der Linie des betroffenen Gegenstandes die Auszeichnung von Problemen
     And das Problem wird wie folgt dargestellt: "Gegenstand ist defekt"

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

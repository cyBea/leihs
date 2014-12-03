
Feature: Kalender-Ansicht im Backend

  Background:
    Given I am Pius

  @javascript @personas
  Scenario: Verfügbare Anzahl immer anzeigen
    When man den Kalender sieht
    Then sehe ich die Verfügbarkeit von Modellen auch an Feier- und Ferientagen sowie Wochenenden

  @javascript @browser @personas
  Scenario: Anzahl im Buchungskalender während einer Bestellung überbuchen
    Given ich editiere eine Bestellung
     And I open the booking calendar
     Then kann ich die Anzahl unbegrenzt erhöhen / überbuchen
     And die Bestellung kann gespeichert werden

  @javascript @browser @personas
  Scenario: Anzahl im Buchungskalender während einer Aushändigung überbuchen
    Given I am doing a hand over
     And I open the booking calendar
     Then kann ich die Anzahl unbegrenzt erhöhen / überbuchen
     And die Aushändigung kann gespeichert werden

  @personas @javascript
  Scenario: Nicht verfügbare Zeitspannen
    Given I am doing a hand over
     And eine Model ist nichtmehr verfügbar
     And ich editiere alle Linien
    Then wird in der Liste unter dem Kalender die entsprechende Linie als nicht verfügbar (rot) ausgezeichnet

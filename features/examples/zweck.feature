
Feature: Zweck

  Um den Zweck einer Bestellung oder Übergabe zu sehen
  möchte ich als Verleiher
  den vom Benutzer angegebenen Zweck sehen
  
  Grundlage:
    Given I am Pius

  @personas
  Scenario: Unabhängigkeit
    When ein Zweck gespeichert wird ist er unabhängig von einer Bestellung
     And jeder Eintrag einer abgeschickten Bestellung referenziert auf einen Zweck
     And jeder Eintrag eines Vertrages kann auf einen Zweck referenzieren

  @javascript @personas @browser
  Scenario: Orte, an denen ich den Zweck sehe
    When ich eine Bestellung editiere
    Then sehe ich den Zweck
    When I open a hand over
    Then sehe ich auf jeder Zeile den zugewisenen Zweck

  @javascript @personas @browser
  Scenario: Orte, an denen ich den Zweck editieren kann
    When ich eine Bestellung editiere
    Then kann ich den Zweck editieren

  @javascript @browser @personas
  Scenario: Aushändigung mit Gegenständen teilweise ohne Zweck übertragen einen angegebenen Zweck nur auf die Gegenstände ohne Zweck
    When I open a hand over
     And I click an inventory code input field of an item line
     And I select one of those
     And I add an item to the hand over by providing an inventory code
     And I add an option to the hand over by providing an inventory code and a date range
    And ich einen Zweck angebe
    Then wird nur den Gegenständen ohne Zweck der angegebene Zweck zugewiesen

  @javascript @browser @personas
  Scenario: Aushändigung mit Gegenständen die alle einen Zweck haben
    When I open a hand over
    And alle der ausgewählten Gegenstände haben einen Zweck angegeben
    Then kann ich keinen weiteren Zweck angeben

  @javascript @browser @personas
  Scenario: Aushändigung ohne Zweck
    When I open a hand over
    And keine der ausgewählten Gegenstände hat einen Zweck angegeben
    Then werde ich beim Aushändigen darauf hingewiesen einen Zweck anzugeben
    And erst wenn ich einen Zweck angebebe
    Then kann ich die Aushändigung durchführen

  @javascript @browser @personas
  Scenario: Aushändigung mit Gegenständen teilweise ohne Zweck können durchgeführt werden
    When I open a hand over
    And I click an inventory code input field of an item line
    And I select one of those
    And I add an item to the hand over by providing an inventory code
    And I add an option to the hand over by providing an inventory code and a date range
    Then muss ich keinen Zweck angeben um die Aushändigung durchzuführen

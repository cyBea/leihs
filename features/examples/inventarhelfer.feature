
Feature: Inventarhelfer

  Grundlage:
    Given I am Matti

  @personas
  Scenario: Wie man den Helferschirm erreicht
    When I open the Inventory
    Then kann man über die Tabnavigation zum Helferschirm wechseln

  @javascript @personas
  Scenario: Gestell bei vorhandenem Ort ändern
    Given man ist auf dem Helferschirm
    And es existiert ein Gegenstand, welches sich denselben Ort mit einem anderen Gegenstand teilt
    Then wähle ich das Feld "Gestell" aus der Liste aus
    And ich setze den Wert für das Feld "Gestell"
    Then gebe ich den Anfang des Inventarcodes des spezifischen Gegenstandes ein
    And wähle den Gegenstand über die mir vorgeschlagenen Suchtreffer
    Then sehe ich alle Werte des Gegenstandes in der Übersicht mit Modellname, die geänderten Werte sind bereits gespeichert
    And die geänderten Werte sind hervorgehoben
    And der Ort des anderen Gegenstandes ist dergleiche geblieben

  @javascript @browser @personas
  Scenario: Bei ausgeliehenen Gegenständen kann man die verantwortliche Abteilung nicht editieren
    Given man ist auf dem Helferschirm
    And one edits the field "Verantwortliche Abteilung" of an owned item not in stock
    Then erhält man eine Fehlermeldung, dass man diese Eigenschaft nicht editieren kann, da das Gerät ausgeliehen ist

  @javascript @personas
  Scenario: Die ausgeliehenen Gegenständen kann man nicht ausmustern
    Given man ist auf dem Helferschirm
    And man mustert einen ausgeliehenen Gegenstand aus
    Then erhält man eine Fehlermeldung, dass man den Gegenstand nicht ausmustern kann, da das Gerät bereits ausgeliehen oder einer Vertragslinie zugewiesen ist

  @javascript @personas
  Scenario: Geräte über den Helferschirm editieren, mittels vollständigem Inventarcode (Scanner)
    Given man ist auf dem Helferschirm
    Then wähle ich all die Felder über eine List oder per Namen aus
    And ich setze all ihre Initalisierungswerte
    Then scanne oder gebe ich den Inventarcode von einem Gegenstand ein, der am Lager und in keinem Vertrag vorhanden ist
    Then sehe ich alle Werte des Gegenstandes in der Übersicht mit Modellname, die geänderten Werte sind bereits gespeichert
    And die geänderten Werte sind hervorgehoben

  @javascript @personas
  Scenario: Pflichtfelder
    Given man ist auf dem Helferschirm
    When "Bezug" ausgewählt und auf "Investition" gesetzt wird, dann muss auch "Projektnummer" angegeben werden
    When "Inventarrelevant" ausgewählt und auf "Ja" gesetzt wird, dann muss auch "Anschaffungskategorie" angegeben werden
    When "Ausmusterung" ausgewählt und auf "Ja" gesetzt wird, dann muss auch "Grund der Ausmusterung" angegeben werden
    Then sind alle Pflichtfelder mit einem Stern gekenzeichnet
    When ein Pflichtfeld nicht ausgefüllt/ausgewählt ist, dann lässt sich der Inventarhelfer nicht nutzen
    And I see an error message
    And die nicht ausgefüllten/ausgewählten Pflichtfelder sind rot markiert

  @javascript @personas
  Scenario: Geräte über den Helferschirm editieren, mittels Inventarcode konnte nicht gefunden wurde
    Given man ist auf dem Helferschirm
    Then wähle ich die Felder über eine List oder per Namen aus
    And ich setze ihre Initalisierungswerte
    Then scanne oder gebe ich den Inventarcode eines Gegenstandes ein der nicht gefunden wird
    Then erhählt man eine Fehlermeldung

  @javascript @personas
  Scenario: Geräte über den Helferschirm editieren mittels Inventarcode über Autovervollständigung
    Given man ist auf dem Helferschirm
    Then wähle ich die Felder über eine List oder per Namen aus
    And ich setze ihre Initalisierungswerte
    Then gebe ich den Anfang des Inventarcodes eines Gegenstand ein
    And wähle den Gegenstand über die mir vorgeschlagenen Suchtreffer
    Then sehe ich alle Werte des Gegenstandes in der Übersicht mit Modellname, die geänderten Werte sind bereits gespeichert
    And die geänderten Werte sind hervorgehoben

  @javascript @browser @personas
  Scenario: Editeren nach automatischen speichern
    Given man editiert ein Gerät über den Helferschirm mittels Inventarcode
    When man die Editierfunktion nutzt
    Then kann man an Ort und Stelle alle Werte des Gegenstandes editieren
    When man die Änderungen speichert
    Then sind sie gespeichert

  @javascript @personas
  Scenario: Editeren nach automatischen speichern abbrechen
    Given man editiert ein Gerät über den Helferschirm mittels Inventarcode
    When man die Editierfunktion nutzt
    Then kann man an Ort und Stelle alle Werte des Gegenstandes editieren
    When man seine Änderungen widerruft
    Then sind die Änderungen widerrufen
    And man sieht alle ursprünglichen Werte des Gegenstandes in der Übersicht

  @javascript @personas
  Scenario: Bei Gegenständen, die in Verträgen vorhanden sind, können gewisse Felder nicht editiert werden
    Given man ist auf dem Helferschirm
    And man editiert das Feld "Modell" eines Gegenstandes, der im irgendeinen Vertrag vorhanden ist
    Then erhält man eine Fehlermeldung, dass man diese Eigenschaft nicht editieren kann, da das Gerät in einem Vortrag vorhanden ist

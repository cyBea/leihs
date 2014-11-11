
Feature: Bestellfensterchen

  Um Gegenstände ausleihen zu können
  möchte ich als Ausleiher
  die möglichkeit haben Modelle zu bestellen

  Grundlage:
    Given I am Normin

  @personas
  Scenario: Bestellfensterchen
    Given man befindet sich auf der Seite der Hauptkategorien
    Then sehe ich das Bestellfensterchen

  @personas
  Scenario: Kein Bestellfensterchen
    Given man befindet sich auf der Bestellübersicht
    Then sehe ich kein Bestellfensterchen

  @personas
  Scenario: Bestellfensterchen Inhalt
    Given ich ein Modell der Bestellung hinzufüge
    Then erscheint es im Bestellfensterchen
    And die Modelle im Bestellfensterchen sind alphabetisch sortiert
    And gleiche Modelle werden zusammengefasst
    When das gleiche Modell nochmals hinzugefügt wird
    Then wird die Anzahl dieses Modells erhöht
    And die Modelle im Bestellfensterchen sind alphabetisch sortiert
    And gleiche Modelle werden zusammengefasst
    And ich kann zur detaillierten Bestellübersicht gelangen

  @javascript @browser @personas
  Scenario: Bestellfensterchen aus Kalender updaten
    When ich mit dem Kalender ein Modell der Bestellung hinzufüge
    Then wird das Bestellfensterchen aktualisiert

  @javascript @personas
  Scenario: Zeit abgelaufen
    When die Zeit abgelaufen ist
    Then werde ich auf die Timeout Page weitergeleitet

  @javascript @personas
  Scenario: Zeit überschritten
    When ich ein Modell der Bestellung hinzufüge
    Then sehe ich die Zeitanzeige
    When die Zeit überschritten ist

  @javascript @personas
  Scenario: Zeitentität, Ablauf der erlaubten Zeit anzeigen
    Given meine Bestellung ist leer
    When man befindet sich auf der Seite der Hauptkategorien
    Then sehe ich keine Zeitanzeige
    When ich ein Modell der Bestellung hinzufüge
    Then sehe ich die Zeitanzeige
    And die Zeitanzeige ist in einer Schaltfläche im Reiter "Bestellung" auf der rechten Seite
    And die Zeitanzeige zählt von 30 Minuten herunter

  @personas
  Scenario: Zeit zurücksetzen
    Given die Bestellung ist nicht leer
    Then sehe ich die Zeitanzeige
    When ich den Time-Out zurücksetze
    Then wird die Zeit zurückgesetzt

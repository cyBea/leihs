
Feature: Werteliste

  Um eine konforme Werteliste aushändigen zu können
  möchte ich als Verleiher
  das mir das System für eine Auswahl eine Werteliste zur verfügung stellen kann

  Grundlage:
    Given I am Pius

  @javascript @browser @personas
  Scenario: Was ich auf der Werteliste sehen möchte
    Given man öffnet eine Werteliste
    Then möchte ich die folgenden Bereiche in der Werteliste sehen:
    | Bereich          |
    | Datum            |
    | Titel            |
    | Ausleihender     |
    | Verleier         |
    | Liste            |

  @javascript @browser @personas
  Scenario: Der Inhalt der Werte-Liste
    Given man öffnet eine Werteliste
    Then beinhaltet die Liste folgende Spalten:
    | Spaltenname     |
    | Laufende Nummer |
    | Inventarcode    |
    | Modellname      |
    | End Datum       |
    | Anzahl          |
    | Wert            |
    And die Modelle in der Werteliste sind alphabetisch sortiert

  @javascript @personas
  Scenario: Werteliste auf Bestellübersicht ausdrucken
    Given es existiert eine Bestellung mit mindestens zwei Modellen, wo die Bestellmenge mindestens drei pro Modell ist
    When ich eine Bestellung öffne
    And ich mehrere Linien von der Bestellung auswähle
    And das Werteverzeichniss öffne
    Then sehe ich das Werteverzeichniss für die ausgewählten Linien
    And die nicht zugewiesenen Linien sind zusammengefasst
    And für die nicht zugewiesenen Linien ist der Preis der höchste Preis eines Gegenstandes eines Models innerhalb des Geräteparks

  @javascript @personas
  Scenario: Werteliste auf der Aushändigungsansicht ausdrucken
    Given es existiert eine Aushändigung mit mindestens zwei Modellen und einer Option, wo die Bestellmenge mindestens drei pro Modell ist
    And es ist pro Modell genau einer Linie ein Gegenstand zugewiesen
    When ich die Aushändigung öffne
    And ich mehrere Linien von der Aushändigung auswähle
    And das Werteverzeichniss öffne
    Then sehe ich das Werteverzeichniss für die ausgewählten Linien
    And für die nicht zugewiesenen Linien ist der Preis der höchste Preis eines Gegenstandes eines Models innerhalb des Geräteparks
    And für die zugewiesenen Linien ist der Preis der des Gegenstandes
    And die nicht zugewiesenen Linien sind zusammengefasst
    And der Preis einer Option ist der innerhalb des Geräteparks

  @javascript @browser @personas
  Scenario: Totale Werte
    Given man öffnet eine Werteliste
    Then gibt es eine Zeile für die totalen Werte
    And diese summierte die Spalten:
     | Spaltenname |
     | Anzahl      |
     | Wert        |

  @javascript @browser @personas
  Scenario: Totale Werte
    Given man öffnet eine Werteliste
    Then gibt es eine Zeile für die totalen Werte
    And diese summierte die Spalten:
     | Spaltenname |
     | Anzahl      |
     | Wert        |

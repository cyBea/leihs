
Feature: Value list

  Background:
    Given I am Pius

  @javascript @browser @personas
  Scenario: What I want to see on the value list
    Given I open a value list
    Then I want to see the following sections in the value list:
    | Section  |
    | Date     |
    | Title    |
    | Borrower |
    | Lender   |
    | List     |

  @javascript @browser @personas
  Scenario: Content of a value list
    Given I open a value list
    Then the value list contains the following columns:
    | Column             |
    | Consecutive number |
    | Inventory code     |
    | Model name         |
    | End date           |
    | Quantity           |
    | Price              |
    And the models in the value list are sorted alphabetically

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

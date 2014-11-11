
Feature: Verfügbarkeit


  @personas @personas
  Scenario: Zuweisung einer Bestellungs-Zeile für ein Nicht-Gruppenmitglied
    Given der Kunde ist nicht in der Gruppe "CAST"
    And es gibt ein Modell, welches folgende Partitionen hat:
      | gruppe    | anzahl |
      | CAST      | 3      |
      | Allgemein | 5      |
    When dieser Kunde das Modell bestellen möchte
    Then ist dieses Modell für den Kunden "5" Mal verfügbar
    Then ist dieses Modell für den Kunden nicht "8" Mal verfügbar

  @personas @personas
  Scenario: Zuweisung einer Bestellungs-Zeile für ein Gruppenmitglied
    Given der Kunde ist in der Gruppe "CAST"
    And es gibt ein Modell, welches folgende Partitionen hat:
      | gruppe    | anzahl |
      | CAST      | 3      |
      | Allgemein | 5      |
    When dieser Kunde das Modell bestellen möchte
    Then ist dieses Modell für den Kunden "8" Mal verfügbar

  @personas @personas
  Scenario: Prioritäten der Gruppen bei der Zuweisung
    When ein Modell in mehreren Gruppen verfügbar ist
    Then wird zuletzt die Gruppe "Allgemein" belastet

  @javascript @browser @personas
  Scenario: Keine Verfügbarkeitsberechnung bei Optionen
    Given I am Pius
    When eine Rücknahme nur Optionen enthält
    Then wird für diese Optionen keine Verfügbarkeit berechnet
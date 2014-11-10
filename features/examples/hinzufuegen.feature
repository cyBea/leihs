
Feature: Hinzufügen von Modellen

  Grundlage:
    Given ich bin Pius

  @javascript @browser @personas
  Scenario: Verfügbarkeitsanzeige beim Hinzufügen zu einer Bestellung
    Given ich editiere eine Bestellung
      And ich suche ein Modell um es hinzuzufügen
    Then sehe ich die Verfügbarkeit innerhalb der gefundenen Modelle im Format: "2(3)/7 Modelname Typ"

  @javascript @browser @personas
  Scenario: Verfügbarkeitsanzeige beim Hinzufügen zu einer Aushändigung
    Given I am doing a hand over
      And ich suche ein Modell um es hinzuzufügen
    Then sehe ich die Verfügbarkeit innerhalb der gefundenen Modelle im Format: "2(3)/7 Modelname Typ"

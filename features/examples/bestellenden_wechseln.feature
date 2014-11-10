
Feature: Bestellenden wechseln

  Grundlage:
    Given ich bin Pius

  @javascript @personas
  Scenario: Bestellende Person wechseln
    Given ich öffne eine Bestellung
    Then kann ich die bestellende Person wechseln
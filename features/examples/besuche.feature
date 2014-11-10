
Feature: Ausleihe

  @javascript @personas
  Scenario: Menschlich lesbare Anzeige der Differenz zum Datum
    Given ich bin Pius
    Given ich befinde mich auf der Seite der Besuche
    Then wird für jeden Besuch korrekt, menschlich lesbar die Differenz zum jeweiligen Datum angezeigt

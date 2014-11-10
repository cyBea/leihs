
Feature: Modell Eigenschaften

  Grundlage:
    Given ich bin Mike

  @javascript @personas
  Scenario: Eigenschaften erstellen
  Given ich erstelle ein Modell und gebe die Pflichtfelder an
  When ich Eigenschaften hinzufügen und die Felder mit den Platzhaltern Schlüssel und Wert angebe
  And ich die Eigenschaften sortiere
  And ich das Modell speichere
  Then sind die Eigenschaften gemäss Sortierreihenfolge für dieses Modell gespeichert

  @javascript @browser @personas
  Scenario: Eigenschaften editieren
  Given ich editiere ein Modell
  When ich Eigenschaften hinzufügen und die Felder mit den Platzhaltern Schlüssel und Wert angebe
  And ich bestehende Eigenschaften ändere
  And ich die Eigenschaften sortiere
  And ich das Modell speichere
  Then sind die Eigenschaften gemäss Sortierreihenfolge für das geänderte Modell gespeichert

  @javascript @personas
  Scenario: Eigenschaften löschen
  Given ich editiere ein Modell welches bereits Eigenschaften hat
  When ich eine oder mehrere bestehende Eigenschaften lösche
  And ich das Modell speichere
  Then sind die Eigenschaften gemäss Sortierreihenfolge für das geänderte Modell gespeichert

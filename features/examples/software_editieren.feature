
Feature: Software editieren

  Grundlage:
    Given I am Mike

  @javascript @personas
  Scenario: Software-Produkt editieren
    When ich eine Software editiere
    And ich ändere die folgenden Details
      | Feld                   | Wert                                                           |
      | Produkt                | Test Software I                                                |
      | Version                | Test Version I                                                 |
      | Hersteller             | Neuer Hersteller                                               |
      | Software Informationen | Installationslink beachten: http://wwww.dokuwiki.ch/neue_seite |
    When ich speichere
    And ich mich auf der Softwareliste befinde
    Then die Informationen sind gespeichert
    And die Daten wurden entsprechend aktualisiert

  #73278586
  @javascript @personas
  Scenario: Grösse des Software Informationen-Felds
    Given eine Software-Produkt mit mehr als 6 Zeilen Text im Feld "Software Informationen" existiert
    When ich diese Software editiere
    And ich in das Feld "Software Informationen" klicke
    Then wächst das Feld, bis es den ganzen Text anzeigt
    When ich aus dem Feld herausgehe
    Then schrumpft das Feld wieder auf die Ausgangsgrösse

  @javascript @personas
  Scenario: Software-Lizenz editieren
    When ich eine bestehende Software-Lizenz mit Software-Informationen, Anzahl-Zuteilungen und Anhängen editiere
    Then sehe ich die "Software Informationen" angezeigt
    And die "Software Informationen" sind nicht editierbar
    And die bestehende Links der "Software Informationen" öffnen beim Klicken in neuem Browser-Tab
    Then sehe ich die "Anhänge" der Software angezeigt
    And ich kann die Anhänge in neuem Browser-Tab öffnen
    When ich eine andere Software auswähle
    And ich eine andere Seriennummer eingebe
    And ich einen anderen Aktivierungstyp wähle
    And ich den Wert "Ausleihbar" ändere
    And ich die Optionen für das Betriebssystem ändere
    And ich die Optionen für die Installation ändere
    And ich das Lizenzablaufdatum ändere
    And ich den Wert für den Maintenance-Vertrag ändere
    And ich den Wert für Bezug ändere
    And ich den Wert der Notiz ändere
    And ich die Dongle-ID ändere
    And ich einen der folgenden Lizenztypen wähle:
      | Mehrplatz   |
      | Konkurrent  |
      | Site-Lizenz |
    And ich die Gesamtanzahl ändere
    And ich die Anzahl-Zuteilungen ändere
    #But ich kann den Inventarcode nicht ändern # really? inventory manager can change the inventory number of an item right now...
    When ich speichere
    Then sind die Informationen dieser Software-Lizenz erfolgreich aktualisiert worden

  @javascript @personas
  Scenario: Software-Lizenz editieren - Werte der Datenfelder löschen
    When ich eine Software-Lizenz mit gesetztem Maintenance-Ablaufdatum, Lizenzablaufdatum und Rechnungsdatum editiere
    And ich die Daten für die folgenden Feldern lösche:
      | Maintenance-Ablaufdatum |
      | Lizenzablaufdatum       |
      | Rechnungsdatum          |
    And ich speichere
    Then I receive a notification of success
    When ich die gleiche Lizenz editiere
    Then sind die folgenden Felder der Lizenz leer:
      | Maintenance-Ablaufdatum |
      | Lizenzablaufdatum       |
      | Rechnungsdatum          |


Feature: Inventar

  @personas
  Scenario: Globaler Export des Inventars aller Geräteparks
    Given I am Gino
    And man öffnet die Liste der Geräteparks
    Then kann man das globale Inventar als CSV-Datei exportieren

  @javascript @personas @browser
  Scenario: Export der aktuellen Ansicht als CSV
    Given I am Mike
    And man öffnet die Liste des Inventars
    When I view the tab "Models"
    Then kann man diese Daten als CSV-Datei exportieren
    And die Datei enthält die gleichen Zeilen, wie gerade angezeigt werden (inkl. Filter)
    And die Zeilen enthalten die folgenden Felder in aufgeführter Reihenfolge
    | Felder                            |
    | Erstellt am                       |
    | Aktualisiert am                   |
    | Produkt                           |
    | Version                           |
    | Hersteller                        |
    | Beschreibung                      |
    | Technische Details                |
    | Interne Beschreibung              |
    | Wichtige Notizen zur Aushändigung |
    | Kategorien                        |
    | Zubehör                           |
    | Ergänzende Modelle                |
    | Eigenschaften                     |
    | Inventarcode                      |
    | Seriennummer                      |
    | MAC-Adresse                       |
    | IMEI-Nummer                       |
    | Name                              |
    | Notiz                             |
    | Ausmusterung                      |
    | Grund der Ausmusterung            |
    | Zustand                           |
    | Vollständigkeit                   |
    | Ausleihbar                        |
    | Gebäude                           |
    | Raum                              |
    | Gestell                           |
    | Inventarrelevant                  |
    | Besitzer                          |
    | Letzte Inventur                   |
    | Verantwortliche Abteilung         |
    | Verantwortliche Person            |
    | Benutzer/Verwendung               |
    | Anschaffungskategorie             |
    | Bezug                             |
    | Projektnummer                     |
    | Rechnungsnummer                   |
    | Rechnungsdatum                    |
    | Anschaffungswert                  |
    | Lieferant                         |
    | Garantieablaufdatum               |
    | Vertragsablaufdatum               |
    | Umzug                             |
    | Zielraum                          |
    | Ankunftsdatum                     |
    | Ankunftszustand                   |
    | Ankunftsnotiz                     |
    When I view the tab "Software"
    Then kann man diese Daten als CSV-Datei exportieren
    And die Datei enthält die gleichen Zeilen, wie gerade angezeigt werden (inkl. Filter)
    And die Zeilen enthalten die folgenden Felder in aufgeführter Reihenfolge
    | Felder                            |
    | Erstellt am                       |
    | Aktualisiert am                   |
    | Produkt                           |
    | Version                           |
    | Hersteller                        |
    | Software Informationen            |
    | Inventarcode                      |
    | Seriennummer                      |
    | Notiz                             |
    | Aktivierungstyp                   |
    | Dongle ID                         |
    | Lizenztyp                         |
    | Gesamtanzahl                      |
    | Anzahl-Zuteilungen                |
    | Betriebssystem                    |
    | Installation                      |
    | Lizenzablaufdatum                 |
    | Maintenance-Vertrag               |
    | Maintenance-Ablaufdatum           |
    | Ausmusterung                      |
    | Grund der Ausmusterung            |
    | Ausleihbar                        |
    | Besitzer                          |
    | Verantwortliche Abteilung         |
    | Bezug                             |
    | Projektnummer                     |
    | Rechnungsdatum                    |
    | Anschaffungswert                  |
    | Lieferant                         |
    | Beschafft durch                   |

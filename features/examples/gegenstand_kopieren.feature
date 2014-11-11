
Feature: Gegenstand kopieren

  Grundlage:
    Given I am Mike

  @javascript @personas
  Scenario: Gegenstand erstellen und kopieren
    Given man erstellt einen Gegenstand
    | Feldname                     | Type         | Wert                          |
    | Modell                       | autocomplete | Sharp Beamer 456              |
    | Ausmusterung                 | checkbox     | unchecked                     |
    | Zustand                      | radio        | OK                            |
    | Vollständigkeit              | radio        | OK                            |
    | Ausleihbar                   | radio        | OK                            |
    | Inventarrelevant             | select       | Ja                            |
    | Letzte Inventur              |              | 01.01.2013                    |
    | Verantwortliche Abteilung    | autocomplete | A-Ausleihe                    |
    | Verantwortliche Person       |              | Matus Kmit                    |
    | Benutzer/Verwendung          |              | Test Verwendung               |
    | Umzug                        | select       | sofort entsorgen              |
    | Zielraum                     |              | Test Raum                     |
    | Ankunftsdatum                |              | 01.01.2013                    |
    | Ankunftszustand              | select       | transportschaden              |
    | Ankunftsnotiz                |              | Test Notiz                    |
    | Seriennummer                 |              | Test Seriennummer             |
    | MAC-Adresse                  |              | Test MAC-Adresse              |
    | IMEI-Nummer                  |              | Test IMEI-Nummer              |
    | Name                         |              | Test Name                     |
    | Notiz                        |              | Test Notiz                    |
    | Gebäude                      | autocomplete | Keine/r                       |
    | Raum                         |              | Test Raum                     |
    | Gestell                      |              | Test Gestell                  |
    | Bezug                        | radio must   | investment                    |
    | Projektnummer                |              | Test Nummer                   |
    | Rechnungsnummer              |              | Test Nummer                   |
    | Rechnungsdatum               |              | 01.01.2013                    |
    | Anschaffungswert             |              | 50.00                         |
    #| Lieferant                    | autocomplete | Neuer Lieferant               |
    | Garantieablaufdatum          |              | 01.01.2013                    |
    | Vertragsablaufdatum          |              | 01.01.2013                    |
    When man speichert und kopiert
    Then wird der Gegenstand gespeichert
    And eine neue Gegenstandserstellungsansicht wird geöffnet
    And man sieht den Seitentitel 'Kopierten Gegenstand erstellen'
    And man sieht den Abbrechen-Knopf
    And alle Felder bis auf die folgenden wurden kopiert:
    | Inventarcode                 |
    | Name                         |
    | Seriennummer                 |
    And der Inventarcode ist vorausgefüllt
    When ich speichere
    Then wird der kopierte Gegenstand gespeichert
    And man wird zur Liste des Inventars zurückgeführt

  @javascript @browser @personas
  Scenario: Bestehenden Gegenstand aus Liste kopieren
    Given man befindet sich auf der Liste des Inventars
    When man einen Gegenstand kopiert
    Then wird eine neue Gegenstandskopieransicht geöffnet
    And alle Felder bis auf Inventarcode, Seriennummer und Name wurden kopiert

  @javascript @browser @personas
  Scenario: Bestehenden Gegenstand aus Editieransicht kopieren
    When ich mich in der Editieransicht einer Gegenstand befinde
    And man speichert und kopiert
    Then wird eine neue Gegenstandskopieransicht geöffnet
    And alle Felder bis auf Inventarcode, Seriennummer und Name wurden kopiert

  @javascript @personas
  Scenario: Gegenstand aus einem anderem Gerätepark kopieren
    Given I go to logout
    And I am Matti
    And man editiert ein Gegenstand eines anderen Besitzers
    When man speichert und kopiert
    Then wird eine neue Gegenstandskopieransicht geöffnet
    And alle Felder sind editierbar, da man jetzt Besitzer von diesem Gegenstand ist

  @javascript @browser @personas
  Scenario: Neuen Lieferanten erstellen falls nicht vorhanden
    Given man einen Gegenstand kopiert
    Then wird eine neue Gegenstandskopieransicht geöffnet
    When ich einen nicht existierenen Lieferanten angebe
    And ich merke mir den Inventarcode für weitere Schritte
    And ich speichere
    Then wird der neue Lieferant erstellt
    And bei dem kopierten Gegestand ist der neue Lieferant eingetragen


Feature: Vertrag

  Um eine Aushändigung durchzuführen/zu dokumentieren
  möchte ich als Verleiher
  das mir das System einen Vertrag bereitstellen kann

  Grundlage:
    Given ich bin Pius

  @javascript @browser @personas
  Scenario: Was ich auf dem Vertrag sehen möchte
    Given man öffnet einen Vertrag bei der Aushändigung
    Then möchte ich die folgenden Bereiche sehen:
    | Bereich                       |
    | Datum                         |
    | Titel                         |
    | Ausleihender                  |
    | Verleier                      |
    | Liste 1                       |
    | Liste 2                       |
    | Liste der Zwecke              |
    | Zusätzliche Notiz             |
    | Hinweis auf AGB               |
    | Unterschrift des Ausleihenden |
    | Seitennummer                  |
    | Barcode                       |
    | Vertragsnummer                |
    And die Modelle sind innerhalb ihrer Gruppe alphabetisch sortiert

  @javascript @browser @personas
  Scenario: Hinweis auf AGB
    Given man öffnet einen Vertrag bei der Aushändigung
    Then seh ich den Hinweis auf AGB "Es gelten die Ausleih- und Benutzungsreglemente des Verleihers."

  @javascript @browser @personas
  Scenario: Welche Informationen ich vom Ausleihenden sehen möchte
    Given man öffnet einen Vertrag bei der Aushändigung
    Then möchte ich im Feld des Ausleihenden die folgenden Bereiche sehen:
    | Bereich      |
    | Vorname      |
    | Nachname     |
    | Strasse      |
    | Hausnummer   |
    | Länderkürzel |
    | PLZ          |
    | Stadt        |

  @javascript @browser @personas
  Scenario: Liste der zurückgebenen Gegenstände
    Given man öffnet einen Vertrag bei der Aushändigung
    When es Gegenstände gibt, die zurückgegeben wurden
    Then sehe ich die Liste 1 mit dem Titel "Zurückgegebene Gegenstände"
    And diese Liste enthält Gegenstände die ausgeliehen und zurückgegeben wurden

  @javascript @browser @personas
  Scenario: Zwecke
    Given man öffnet einen Vertrag bei der Aushändigung
    Then sehe ich eine Liste Zwecken, getrennt durch Kommas
     And jeder identische Zweck ist maximal einmal aufgelistet

  @javascript @browser @personas
  Scenario: Datum
    Given man öffnet einen Vertrag bei der Aushändigung
    Then sehe ich das heutige Datum oben rechts

  @javascript @browser @personas
  Scenario: Titel
    Given man öffnet einen Vertrag bei der Aushändigung
    Then sehe ich den Titel im Format "Leihvertrag Nr. #"

  @javascript @browser @personas
  Scenario: Position des Barcodes
    Given man öffnet einen Vertrag bei der Aushändigung
    Then sehe ich den Barcode oben links

  @javascript @browser @personas
  Scenario: Position des Ausleihenden
    Given man öffnet einen Vertrag bei der Aushändigung
    Then sehe ich den Ausleihenden oben links

  @javascript @browser @personas
  Scenario: Inhalt der Liste 1 und Liste 2
    Given man öffnet einen Vertrag bei der Aushändigung mit Software
    Then beinhalten Liste 1 und Liste 2 folgende Spalten:
    | Spaltenname   |
    | Anzahl        |
    | Inventarcode  |
    | Modellname    |
    | Enddatum      |
    | Rückgabedatum / Rücknehmende Person |
    When der Vertrag eine Software-Lizenz beinhaltet
    Then sehe ich zusätzlich die folgende Information
    | Seriennummer  |

  @javascript @browser @personas
  Scenario: Rücknehmende Person
    Given man öffnet einen Vertrag bei der Rücknahme
    Then sieht man bei den betroffenen Linien die rücknehmende Person im Format "V. Nachname"

  @javascript @browser @personas
  Scenario: Verleiher
    Given man öffnet einen Vertrag bei der Aushändigung
    Then sehe ich den Verleiher neben dem Ausleihenden

  @javascript @browser @personas
  Scenario: Liste der ausgeliehenen Gegenstände
    Given man öffnet einen Vertrag bei der Aushändigung
    When es Gegenstände gibt, die noch nicht zurückgegeben wurden
    Then sehe ich die Liste 2 mit dem Titel "Ausgeliehene Gegenstände"
    And diese Liste enthält Gegenstände, die ausgeliehen und noch nicht zurückgegeben wurden

  @javascript @browser @personas
  Scenario: Adresse des Verleihers aufführen
    Given man öffnet einen Vertrag bei der Aushändigung
    Then wird unter 'Verleiher/in' der Gerätepark aufgeführt
    When in den globalen Einstellungen die Adresse der Instanz konfiguriert ist
    Then wird unter dem Verleiher diese Adresse angezeigt

  @personas
  Scenario: Adresse des Kunden ohne abschliessenden ", " anzeigen
    Given es gibt einen Kunden mit Vertrag wessen Addresse mit ", " endet
    When ich einen Vertrag dieses Kunden öffne
    Then wird seine Adresse ohne den abschliessenden ", " angezeigt

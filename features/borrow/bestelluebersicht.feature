
Feature: Bestellübersicht

  Um die Bestellung in der Übersicht zu sehen
  möchte ich als Ausleiher
  die Möglichkeit haben meine bestellten Gegenstände in der Übersicht zu sehen

  Grundlage:
    Given I am Normin
    And ich habe Gegenstände der Bestellung hinzugefügt
    When ich die Bestellübersicht öffne

  @personas
  Scenario: Bestellübersicht Auflistung der Gegenstände
    Then sehe ich die Einträge gruppiert nach Startdatum und Gerätepark
    And die Modelle sind alphabetisch sortiert
    And für jeden Eintrag sehe ich die folgenden Informationen
    |Bild|
    |Anzahl|
    |Modellname|
    |Hersteller|
    |Anzahl der Tage|
    |Enddatum|
    |die versch. Aktionen|

  @javascript @browser @personas
  Scenario: Bestellübersicht Aktion 'löschen'
    When ich einen Eintrag lösche
    Then die Gegenstände sind wieder zur Ausleihe verfügbar
     And wird der Eintrag aus der Bestellung entfernt

  @javascript @personas
  Scenario: Zeit überschritten
    When ich ein Modell der Bestellung hinzufüge
    Then sehe ich die Zeitanzeige
    When man befindet sich auf der Bestellübersicht
    And  die Zeit überschritten ist
    Then werde ich auf die Timeout Page weitergeleitet

  @javascript @personas @browser
  Scenario: Bestellübersicht Aktion 'ändern'
    When ich den Eintrag ändere
    Then öffnet der Kalender
    And ich ändere die aktuellen Einstellung
    And speichere die Einstellungen
    Then wird der Eintrag gemäss aktuellen Einstellungen geändert
    And der Eintrag wird in der Liste anhand der des aktuellen Startdatums und des Geräteparks gruppiert

  @javascript @personas
  Scenario: Zeitentität, Ablauf der erlaubten Zeit anzeigen
    Then sehe ich die Zeitinformationen in folgendem Format "mm:ss"
    And die Zeitanzeige zählt von 30 Minuten herunter

  @personas
  Scenario: Zeit zurücksetzen
    Given die Bestellung ist nicht leer
    Then sehe ich die Zeitanzeige
    When ich den Time-Out zurücksetze
    Then wird die Zeit zurückgesetzt

  @javascript @personas
  Scenario: Zeit abgelaufen
    When die Zeit abgelaufen ist
    Then werde ich auf die Timeout Page weitergeleitet

  @javascript @browser @personas
  Scenario: Bestellübersicht Bestellung löschen
    When ich die Bestellung lösche
    Then werde ich gefragt ob ich die Bestellung wirklich löschen möchte
    And ich befinde mich wieder auf der Startseite
    And alle Einträge werden aus der Bestellung gelöscht
    And die Gegenstände sind wieder zur Ausleihe verfügbar

  @personas
  Scenario: Bestellübersicht Bestellen
    When ich einen Zweck eingebe
    And ich die Bestellung abschliesse
    Then ändert sich der Status der Bestellung auf Abgeschickt
    And ich erhalte eine Bestellbestätigung
    And in der Bestellbestätigung wird mitgeteilt, dass die Bestellung in Kürze bearbeitet wird
    And ich befinde mich wieder auf der Startseite

  @personas
  Scenario: Bestellübersicht Zweck nicht eingegeben
    When der Zweck nicht abgefüllt wird
    Then hat der Benutzer keine Möglichkeit die Bestellung abzuschicken

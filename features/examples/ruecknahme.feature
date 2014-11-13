
Feature: Rücknahme

  Um eine Gegenstände wieder dem Verleih zuzuführen
  möchte ich als Ausleih-Verwalter
  Gegenstände Zurücknehmen können

  Grundlage:
    Given I am Pius

  @javascript @personas
  Scenario: Hinzufügen eines Gegenstandes in der Rücknahme
    Given ich befinde mich in einer Rücknahme
    When ich einen Gegenstand über das Zuweisenfeld zurücknehme
    Then wird die Zeile selektiert
    And die Zeile wird grün markiert
    Then I receive a notification of success

  @personas @javascript
  Scenario: Deselektieren einer Linie
    Given ich befinde mich in einer Rücknahme
    When ich einen Gegenstand über das Zuweisenfeld zurücknehme
    And ich die Zeile deselektiere
    Then ist die Zeile nicht mehr grün markiert

  @javascript @personas
  Scenario: Zurückzugebender Gegenstand hat Verspätung
    Given ich befinde mich in einer Rücknahme mit mindestens einem verspäteten Gegenstand
    When ich einen verspäteten Gegenstand über das Zuweisenfeld zurücknehme
    Then wird die Zeile grün markiert
    And die Zeile wird selektiert
    And das Problemfeld für die Linie wird angezeigt
    Then I receive a notification of success

  @javascript @browser @personas
  Scenario: Festhalten wer einen Gegenstand zurückgenommen hat
    When ich einen Gegenstand zurücknehme
    Then wird festgehalten, dass ich diesen Gegenstand zurückgenommen habe

  @personas
  Scenario: Sperrstatus des Benutzers anzeigen
    Given ich befinde mich in einer Rücknahme für ein gesperrter Benutzer
    Then sehe ich neben seinem Namen den Sperrstatus 'Gesperrt!'

  @javascript @personas
  Scenario: Zurückgeben einer Option
    Given ich befinde mich in einer Rücknahme mit mindestens zwei gleichen Optionen
    When ich eine Option über das Zuweisenfeld zurücknehme
    Then wird die Zeile selektiert
    Then I receive a notification of success
    And die Zeile ist nicht grün markiert
    When ich alle Optionen der gleichen Zeile zurücknehme
    Then wird die Zeile grün markiert
    Then I receive a notification of success

  @javascript @browser @personas
  Scenario: Inspektion während einer Rücknahme
    Given ich befinde mich in einer Rücknahme mit mindestens einem Gegenstand und einer Option
    When ich bei der Option eine Stückzahl von 1 eingebe
    And beim Gegenstand eine Inspektion durchführe
    And ich setze "Zustand" auf "Defekt"
    And I save
    Then steht bei der Option die zuvor angegebene Stückzahl

  @javascript @browser @personas
  Scenario: Festhalten wer einen Gegenstand zurückgenommen hat
    When ich einen Gegenstand zurücknehme
    Then wird festgehalten, dass ich diesen Gegenstand zurückgenommen habe

  @personas
  Scenario: Korrekte Reihenfolge mehrerer Verträge
    And es existiert ein Benutzer mit mindestens 2 Rückgaben an 2 verschiedenen Tagen
    When man die Rücknahmenansicht für den Benutzer öffnet
    Then sind die Rücknahmen aufsteigend nach Datum sortiert

  @javascript @personas
  Scenario: Optionen in mehreren Zeitfenstern vorhanden
    Given es existiert ein Benutzer mit einer zurückzugebender Option in zwei verschiedenen Zeitfenstern
    And ich öffne die Rücknahmeansicht für diesen Benutzer
    When ich diese Option zurücknehme
    Then wird die Option dem ersten Zeitfenster hinzugefügt
    When im ersten Zeitfenster bereits die maximale Anzahl dieser Option erreicht ist
    And ich dieselbe Option nochmals hinzufüge
    Then wird die Option dem zweiten Zeitfenster hinzugefügt


Feature: Rüstliste

  Um die Gegenstände in den Gestellen möglichst schnell zu finden
  möchte ich als Verleiher
  dass mir das System eine Rüstliste mit Auflistung der jeweiligen Gestellen gibt

  Grundlage:
    Given ich bin Pius

  @personas
  Scenario: Was ich auf der Rüstliste sehen möchte
    When man öffnet eine Rüstliste
    Then möchte ich die folgenden Bereiche in der Rüstliste sehen:
    | Bereich          |
    | Datum            |
    | Titel            |
    | Ausleihender     |
    | Verleiher        |
    | Liste            |

  @personas @javascript @browser
  Scenario: Inhalt der Rüstliste vor Aushändigung - keine Zuteilung von Inventarcode
    Given es gibt eine Aushändigung mit mindestens einem nicht problematischen Modell und einer Option
    And ich die Aushändigung öffne
    And ein Gegenstand zugeteilt ist und diese Zeile markiert ist
    And einer Zeile noch kein Gegenstand zugeteilt ist und diese Zeile markiert ist
    And eine Option markiert ist
    When man öffnet die Rüstliste
    Then sind die Listen zuerst nach Ausleihdatum sortiert
    And jede Liste beinhaltet folgende Spalten:
    | Spaltenname                        |
    | Anzahl                             |
    | Inventarcode                       |
    | Modellname                         |
    | verfügbare Anzahl x Raum / Gestell |
    And innerhalb jeder Liste wird nach Modell, dann nach Raum und Gestell des meistverfügbaren Ortes sortiert
    And in der Liste wird der Inventarcode des zugeteilten Gegenstandes mit Angabe dessen Raums und Gestells angezeigt
    And in der Liste wird der nicht zugeteilte Gegenstand ohne Angabe eines Inventarcodes angezeigt
    And Gegenständen kein Raum oder Gestell zugeteilt sind, wird die verfügbare Anzahl für den Kunden und "x Ort nicht definiert" angezeigt
    And fehlende Rauminformationen bei Optionen werden als "Ort nicht definiert" angezeigt

  @personas @javascript @browser
  Scenario: Inhalt der Rüstliste vor Aushändigung - nicht verfügbare Gegenstände
    Given es gibt eine Aushändigung mit mindestens einer problematischen Linie
    And ich die Aushändigung öffne
    And einer Zeile noch kein Gegenstand zugeteilt ist und diese Zeile markiert ist
    When man öffnet die Rüstliste
    Then sind die Listen zuerst nach Ausleihdatum sortiert
    And nicht verfügbaren Gegenständen, wird "Nicht verfügbar" angezeigt

  @personas @javascript @browser
  Scenario: Inhalt der Rüstliste vor Aushändigung - nicht zugeteilt Raum und Gestell
    Given es gibt eine Aushändigung mit mindestens einem Gegenstand ohne zugeteilt Raum und Gestell
    And ich die Aushändigung öffne
    And einer Zeile mit einem Gegenstand ohne zugeteilt Raum und Gestell markiert ist
    When man öffnet die Rüstliste
    Then Gegenständen kein Raum oder Gestell zugeteilt sind, wird "Ort nicht definiert" angezeigt

  @personas @javascript
  Scenario: Inhalt der Rüstliste nach Aushändigung - Inventarcodes sind bekannt
    When man öffnet die Rüstliste für einen unterschriebenen Vertrag
    Then sind die Listen zuerst nach Rückgabedatum sortiert
    And jede Liste beinhaltet folgende Spalten:
    | Spaltenname    |
    | Anzahl         |
    | Inventarcode   |
    | Modellname     |
    | Raum / Gestell |
    And innerhalb jeder Liste wird nach Raum und Gestell sortiert
    When Gegenständen kein Raum oder Gestell zugeteilt sind, wird "Ort nicht definiert" angezeigt
    And fehlende Rauminformationen bei Optionen werden als "Ort nicht definiert" angezeigt

  @personas @javascript
  Scenario: Wo wird die Rüstliste aufgerufen
  	When ich mich im Verleih im Reiter aller Verträge befinde
    And ich sehe mindestens einen Vertrag
    Then kann ich die Rüstliste auf den jeweiligen Vertrags-Zeilen öffnen
    When ich mich im Verleih im Reiter der offenen Verträge befinde
    And ich sehe mindestens einen Vertrag
    Then kann ich die Rüstliste auf den jeweiligen Vertrags-Zeilen öffnen
    When ich mich im Verleih im Reiter der geschlossenen Verträge befinde
    And ich sehe mindestens einen Vertrag
    Then kann ich die Rüstliste auf den jeweiligen Vertrags-Zeilen öffnen
    When ich mich im Verleih in einer Aushändigung befinde
    And ich mindestens eine Zeile in dieser Aushändigung markiere
    Then kann ich die Rüstliste öffnen






















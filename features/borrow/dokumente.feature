
Feature: Benutzerdokumente

  Als Benutzer möchte ich meine Dokumente einsehen koennen

  Background:
    Given man ist ein Kunde mit Verträge

  @javascript @personas
  Scenario: Schaltfläche zur Dokumentenübersichtsseite
    When ich unter meinem Benutzernamen auf "Meine Dokumente" klicke
    Then gelange ich zu der Dokumentenübersichtsseite

  @javascript @personas
  Scenario: Dokumentenübersicht
    Given ich befinde mich auf der Dokumentenübersichtsseite
    Then sind die Verträge nach neuestem Zeitfenster sortiert
    And für jede Vertrag sehe ich folgende Informationen
      | Vertragsnummer                          |
      | Zeitfenster mit von bis Datum und Dauer |
      | Gerätepark                              |
      | Zweck                                   |
      | Status                                  |
      | Vertraglink                             |
      | Wertelistelink                          |

  @javascript @personas
  Scenario: Rücknehmende Person
    When ich einen Vertrag mit zurück gebrachten Gegenständen aus meinen Dokumenten öffne
    Then sieht man bei den betroffenen Linien die rücknehmende Person im Format "V. Nachname"

  @javascript @personas
  Scenario: Werteliste öffnen
    Given ich befinde mich auf der Dokumentenübersichtsseite
    And ich drücke auf den Wertelistelink
    Then öffnet sich die Werteliste

  @javascript @personas
  Scenario: Was ich auf der Werteliste sehen möchte
    When ich eine Werteliste aus meinen Dokumenten öffne
    Then sehe ich die Werteliste genau wie im Verwalten-Bereich

  @javascript @personas
  Scenario: Vertrag öffnen
    Given ich befinde mich auf der Dokumentenübersichtsseite
    And ich drücke auf den Vertraglink
    Then öffnet sich der Vertrag

  @javascript @personas
  Scenario: Was ich auf dem Vertrag sehen möchte
    When ich einen Vertrag aus meinen Dokumenten öffne
    Then sehe ich den Vertrag genau wie im Verwalten-Bereich


Feature: Modell

  Grundlage:
    Given I am Mike
    And I open the inventory

  @javascript @personas
  Scenario: Übersicht neues Modell hinzufügen
    When ich ein neues Modell hinzufüge
    Then habe ich die Möglichkeit, folgende Informationen zu erfassen:
      | Details |
      | Bilder  |
      | Anhänge |
      | Zubehör |

  @javascript @browser @personas
  Scenario: Modelldetails abfüllen
    When ich ein neues Modell hinzufüge
    And ich erfasse die folgenden Details
      | Feld                              | Wert                      |
      | Produkt                           | Test Modell               |
      | Hersteller                        | Test Hersteller           |
      | Beschreibung                      | Test Beschreibung         |
      | Technische Details                | Test Technische Details   |
      | Interne Beschreibung              | Test Interne Beschreibung |
      | Wichtige Notizen zur Aushändigung | Test Notizen              |
    And ich speichere die Informationen
    Then ist das neue Modell erstellt und unter ungenutzen Modellen auffindbar

  @javascript @personas
  Scenario: Modellzubehör bearbeiten
    When ich ein bestehendes, genutztes Modell bearbeite welches bereits Zubehör hat
    Then ich sehe das gesamte Zubehöre für dieses Modell
    And ich sehe, welches Zubehör für meinen Pool aktiviert ist
    When ich Zubehör hinzufüge und falls notwendig die Anzahl des Zubehör ins Textfeld schreibe
    And ich speichere die Informationen
    Then ist das Zubehör dem Modell hinzugefügt worden

  @javascript @personas
  Scenario: Modellzubehör löschen
    When ich ein bestehendes, genutztes Modell bearbeite welches bereits Zubehör hat
    Then kann ich ein einzelnes Zubehör löschen, wenn es für keinen anderen Pool aktiviert ist

  @javascript @personas
  Scenario: Modellzubehör deaktivieren
    When ich ein bestehendes, genutztes Modell bearbeite welches bereits ein aktiviertes Zubehör hat
    Then kann ich ein einzelnes Zubehör für meinen Pool deaktivieren

  @javascript @browser @personas
  Scenario: sich ergänzende Modelle entfernen (kompatibel)
    When ich ein Modell öffne, das bereits ergänzende Modelle hat
    And ich ein ergänzendes Modell entferne
    And ich speichere die Informationen
    Then ist das Modell ohne das gelöschte ergänzende Modell gespeichert

  @javascript @browser @personas
  Scenario: Gruppenverteilung editieren
    Given ich editieren ein bestehndes Modell mit bereits zugeteilten Kapazitäten
    When ich bestehende Zuteilungen entfernen
    And neue Zuteilungen hinzufügen
    And ich speichere die Informationen
    Then sind die geänderten Gruppenzuteilungen gespeichert

  @javascript @personas
  Scenario: Modell löschen
    Given es existiert ein Modell mit folgenden Konditionen:
      | in keinem Vertrag aufgeführt |
      | keiner Bestellung zugewiesen |
      | keine Gegenstände zugefügt   |
    When ich dieses Modell aus der Liste lösche
    And das Modell wurde aus der Liste gelöscht
    And das Modell ist gelöscht

  @javascript @browser @personas
  Scenario: sich ergänzende Modelle hinzufügen (kompatibel)
    When ich ein bestehendes, genutztes Modell bearbeite
    And ich ein ergänzendes Modell mittel Autocomplete Feld hinzufüge
    And ich speichere die Informationen
    Then ist dem Modell das ergänzende Modell hinzugefügt worden

  @javascript @browser @personas
  Scenario: 2 Mal gleiches ergänzende Modelle hinzufügen (kompatibel)
    When ich ein Modell öffne, das bereits ergänzende Modelle hat
    And ich ein bereits bestehendes ergänzende Modell mittel Autocomplete Feld hinzufüge
    Then wurde das redundante Modell nicht hizugefügt
    And ich speichere die Informationen
    Then wurde das redundante ergänzende Modell nicht gespeichert

  @javascript @personas
  Scenario: Modelanhängsel löschen
    Given es existiert ein Modell mit folgenden Konditionen:
      | in keinem Vertrag aufgeführt     |
      | keiner Bestellung zugewiesen     |
      | keine Gegenstände zugefügt       |
      | hat Gruppenkapazitäten zugeteilt |
      | hat Eigenschaften                |
      | hat Zubehör                      |
      | hat Bilder                       |
      | hat Anhänge                      |
      | hat Kategoriezuweisungen         |
      | hat sich ergänzende Modelle      |
    When ich dieses Modell aus der Liste lösche
    And das Modell ist gelöscht
    And es wurden auch alle Anhängsel gelöscht

  @javascript @personas @browser
  Scenario: Modelldetails bearbeiten
    When ich ein bestehendes, genutztes Modell bearbeite
    And ich ändere die folgenden Details
      | Feld                              | Wert                        |
      | Produkt                           | Test Modell x               |
      | Hersteller                        | Test Hersteller x           |
      | Beschreibung                      | Test Beschreibung x         |
      | Technische Details                | Test Technische Details x   |
      | Interne Beschreibung              | Test Interne Beschreibung x |
      | Wichtige Notizen zur Aushändigung | Test Notizen x              |
    And ich speichere die Informationen
    And die Informationen sind gespeichert
    And die Daten wurden entsprechend aktualisiert

  @javascript @personas
  Scenario Outline: Attachments erstellen
    Given ich add a new <objekt> or I change an existing <objekt>
    Then füge ich eine oder mehrere Datein den Attachments hinzu
    And kann Attachments auch wieder entfernen
    And ich speichere die Informationen
    Then sind die Attachments gespeichert
  Examples:
    | objekt   |
    | Modell   |
    | Software |

  @javascript @personas
  Scenario: Modelanhängsel löschen
    Given es existiert ein Modell mit folgenden Konditionen:
      | in keinem Vertrag aufgeführt     |
      | keiner Bestellung zugewiesen     |
      | keine Gegenstände zugefügt       |
      | hat Gruppenkapazitäten zugeteilt |
      | hat Eigenschaften                |
      | hat Zubehör                      |
      | hat Bilder                       |
      | hat Anhänge                      |
      | hat Kategoriezuweisungen         |
      | hat sich ergänzende Modelle      |
    When ich dieses Modell aus der Liste lösche
    And das Modell ist gelöscht
    And es wurden auch alle Anhängsel gelöscht

  @javascript @personas
  Scenario Outline: Modelllöschversuch verhindern
    Given das Modell hat <Zuweisung> zugewiesen
    Then kann ich das Modell aus der Liste nicht löschen
  Examples:
    | Zuweisung  |
    | Vertrag    |
    | Bestellung |
    | Gegenstand |

  @javascript @personas
  Scenario: Modelanhängsel löschen
    Given es existiert ein Modell mit folgenden Konditionen:
      | in keinem Vertrag aufgeführt     |
      | keiner Bestellung zugewiesen     |
      | keine Gegenstände zugefügt       |
      | hat Gruppenkapazitäten zugeteilt |
      | hat Eigenschaften                |
      | hat Zubehör                      |
      | hat Bilder                       |
      | hat Anhänge                      |
      | hat Kategoriezuweisungen         |
      | hat sich ergänzende Modelle      |
    When ich dieses Modell aus der Liste lösche
    And das Modell ist gelöscht
    And es wurden auch alle Anhängsel gelöscht

  @javascript @browser @personas
  Scenario: Modell erstellen nur mit Name
    When ich ein neues Modell hinzufüge
    And ich speichere die Informationen
    Then wird das Modell nicht gespeichert, da es keinen Namen hat
    And I see an error message
    When ich einen Namen eines existierenden Modelles eingebe
    And ich speichere die Informationen
    Then wird das Modell nicht gespeichert, da es keinen eindeutigen Namen hat
    And I see an error message
    When ich die folgenden Details ändere
      | Feld    | Wert          |
      | Produkt | Test Modell y |
    And ich speichere die Informationen
    Then ist das neue Modell erstellt und unter ungenutzen Modellen auffindbar

  @javascript @personas
  Scenario: Bilder
    When ich ein bestehendes, genutztes Modell bearbeite
    Then kann ich mehrere Bilder hinzufügen
    And ich kann Bilder auch wieder entfernen
    And ich speichere das Modell mit Bilder
    Then wurden die ausgewählten Bilder für dieses Modell gespeichert
    And zu grosse Bilder werden den erlaubten Grössen entsprechend verkleinert

  @javascript @personas @browser
  Scenario: Bilder
    When ich ein bestehendes, genutztes Modell bearbeite
    Then kann ich mehrere Bilder hinzufügen
    And ich kann Bilder auch wieder entfernen
    And ich speichere das Modell mit Bilder
    Then wurden die ausgewählten Bilder für dieses Modell gespeichert
    And zu grosse Bilder werden den erlaubten Grössen entsprechend verkleinert

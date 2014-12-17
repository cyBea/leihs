
Feature: Model

  Background:
    Given I am Mike
    And I open the inventory

  @javascript @personas
  Scenario: Overview when adding a new model
    When I add a new Model
    Then I can enter the following information:
      | Details |
      | Images  |
      | Attachments |
      | Accessories |

  @javascript @browser @personas
  Scenario: Filling in model details
    When I add a new Model
    And I enter the following details
      | Field                         | Value                     |
      | Product                       | Test model                |
      | Manufacturer                  | Test manufacturer         |
      | Description                   | Test description          |
      | Technical Details             | Test technical details    |
      | Internal Description          | Test internal description |
      | Important notes for hand over | Test notes                |
    And I save
    Then the new model is created and can be found in the list of unused models

  @javascript @personas
  Scenario: Editing model accessories
    When I edit a model that exists, is in use and already has activated accessories
    Then I see all the accessories for this model
    And I see which accessories are active for my pool
    When I add accessories and, if necessary, fill in the quantity in the text field
    And I save
    Then accessories are added to the model

  @javascript @personas
  Scenario: Deleting model accessories
    When I edit a model that exists, is in use and already has accessories
    Then I can delete a single accessory if it is not active in any other pool

  @javascript @personas
  Scenario: Deactivating model accessories
    When I edit a model that exists, is in use and already has activated accessories
    Then I can deactivate an accessory for my pool

  @javascript @browser @personas
  Scenario: Remove compatible models
    When I open a model that already has compatible models
    And I remove a compatible model
    And I save
    Then the model is saved without the compatible model that I removed

  @javascript @browser @personas
  Scenario: Editing group capacities
    Given I edit a model that exists and has group capacities allocated to it
    When I remove existing allocations
    And I add new allocations
    And I save
    Then the changed allocations are saved

  @javascript @personas
  Scenario: Delete model
    Given there is a Model with the following conditions:
      | not in any contract |
      | not in any order|
      | no items assigned|
    When ich dieses Modell aus der Liste lösche
    And the model was deleted from the list
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
    And the information is saved
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

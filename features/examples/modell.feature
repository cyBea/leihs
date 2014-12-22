
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
    Given there is a model with the following conditions:
      | not in any contract |
      | not in any order|
      | no items assigned|
    When I delete this model from the list
    Then the model was deleted from the list
    And the model is deleted

  @javascript @browser @personas
  Scenario: Add compatible models
    When I edit a model that exists and is in use
    And I use the autocomplete field to add a compatible model
    And I save
    Then a compatible model has been added to the model I am editing

  @javascript @browser @personas
  Scenario: Adding a compatible model twice in a row
    When I open a model that already has compatible models
    And I add an already existing compatible model using the autocomplete field
    Then the redundant model was not added
    When I save
    Then the redundant compatible model was not added to this one

  @javascript @personas
  Scenario: Delete model associations
    Given there is a model with the following conditions:
      | not in any contract       |
      | not in any order          |
      | no items assigned         |
      | has group capacities      |
      | has properties            |
      | has accessories           |
      | has images                |
      | has attachments           |
      | is assigned to categories |
      | has compatible models     |
    When I delete this model from the list
    Then the model is deleted
    And all associations have been deleted as well

  @javascript @personas @browser
  Scenario: Editing model details
    When I edit a model that exists and is in use
    And I edit the following details
      | Field                              | Value                        |
      | Product                           | Test Modell x               |
      | Manufacturer | Test Hersteller x           |
      | Description                      | Test Beschreibung x         |
      | Technical Details                | Test Technische Details x   |
      | Internal Description              | Test Interne Beschreibung x |
      | Important notes for hand over | Test Notizen x              |
    And I save
    Then the information is saved
    And the data has been updated

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

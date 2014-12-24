
Feature: Model properties

  Background:
    Given I am Mike

  @javascript @personas
  Scenario: Creating properties
  Given I create a model and fill in all required fields
  When I add some properties and fill in their keys and values
  And I sort the properties
  And I save the model
  Then this model's properties are saved in the order they were given

  @javascript @browser @personas
  Scenario: Editing properties
  Given I am editing a model
  When I add some properties and fill in their keys and values
  And I change existing properties
  And I sort the properties
  And I save the model
  Then this model's properties are saved in the order they were given

  @javascript @personas
  Scenario: Eigenschaften löschen
  Given ich editiere ein Modell welches bereits Eigenschaften hat
  When ich eine oder mehrere bestehende Eigenschaften lösche
  And ich das Modell speichere
  Then sind die Eigenschaften gemäss Sortierreihenfolge für das geänderte Modell gespeichert


Feature: Model list

  @personas
  Scenario: Model list overview
    Given I am Normin
    When I am listing models
    Then I see the explorative search
    And I see the models of the selected category
    And I see the sort options
    And I see the inventory pool selector
    And I see filters for start and end date

  @personas
  Scenario: A single model list entry
    Given I am Normin
    When I am listing models
    And a single model list entry contains:
    | Image            |
    | Model name       |
    | Manufacturer     |
    | Selection button |

  @javascript @browser @personas
  Scenario: Scrolling the model list
    Given I am Normin
    And I see a model list that can be scrolled
    When I scroll to the end of the currently loaded list
    Then the next block of models is loaded and shown
    When I scroll to the end of the list
    Then all models of the chosen category have been loaded and shown

  @javascript @personas
  Scenario: Sorting the model list
    Given I am Normin
    And I am listing models
    When I sort the list by "Model, ascending"
    Then the list is sorted by "Model", "ascending"
    When I sort the list by "Model, descending"
    Then the list is sorted by "Model", "descending"
    When I sort the list by "Manufacturer, ascending"
    Then the list is sorted by "Manufacturer", "ascending"
    When I sort the list by "Manufacturer, descending"
    Then the list is sorted by "Manufacturer", "descending"

  @personas
  Scenario: Standard settings for lending period
    Given I am Normin
    And I am listing models
    Then no lending period is set

  @javascript @personas
  Scenario: Inventory pool selection cannot be empty
    Given I am Normin
    When I am listing models
    Then kann man nicht alle Geräteparks in der Geräteparkauswahl abwählen

  @personas
  Scenario: Geräteparkauswahl sortierung
    Given I am Normin
    When I am listing models
    Then ist die Geräteparkauswahl alphabetisch sortiert

  @javascript @browser @personas
  Scenario: Inventory pool selection "select all"
    Given I am Normin
    When I am listing models
    And I select a specific inventory pool from the choices offered
    And I select all inventory pools using the "All inventory pools" function
    Then all inventory pools are selected
    And the pool selector is still expanded
    And the model list contains models from all inventory pools

  @javascript @personas
  Scenario: Inventory pool selection can never be empty
    Given I am Normin
    When I am listing models
    Then I cannot deselect all the inventory pools in the inventory pool selector

  @javascript @personas @browser
  Scenario: Specifying the start date of an order
    Given I am Petra
    When I am listing models and some of them are unavailable
    And I choose a start date
    Then the end date is automatically set to the next day
    And the list is filtered by models that are available in that time frame

  @javascript @personas
  Scenario: Specifying the end date of an order
    Given I am Petra
    When I am listing models and some of them are unavailable
    And I choose an end date
    Then the start date is automatically set to the previous day
    And the list is filtered by models that are available in that time frame

  @javascript @personas
  Scenario: Removing the lending time frame
    Given I am Petra
    When I am listing models and some of them are unavailable
    And I choose a start date
    And I choose an end date
    When I blank the start and end date
    Then the list is not filtered by lending time frame

  @javascript @personas
  Scenario: Date picker for lending time frame
    Given I am Normin
    And I am listing models
    Then I can also use a date picker to specify start and end date instead of entering them by hand

  @javascript @personas
  Scenario: Searching for a model
    Given I am Normin
    And I am listing models
    When I enter a search term
    Then those models are shown whose names or manufacturers match the search term

  @javascript @browser @personas
  Scenario: Hovering over models
    Given I am Normin
    And there is a model with images, description and properties
    And the model list contains that model
    When I hover over that model
    Then I see the model's name, images, description, list of properties
    When I open the calendar for this model
    And I hover over that model
    Then I see the model's name, images, description, list of properties

  @personas
  Scenario: Default values for inventory pool selection
    Given I am Normin
    When I am listing models
    Then all inventory pools are selected
    And the model list shows models from all inventory pools
    And the filter is labeled "All inventory pools"

  @javascript @personas
  Scenario: Geräteparkauswahl Einzelauswählen
    Given I am Normin
    And I am listing models
    When man ein bestimmten Gerätepark in der Geräteparkauswahl auswählt
    Then sind alle anderen Geräteparks abgewählt
    And die Modellliste zeigt nur Modelle dieses Geräteparks an
    And die Auswahl klappt noch nicht zu
    And im Filter steht der Name des ausgewählten Geräteparks

  @javascript @personas
  Scenario: Geräteparkauswahl Einzelabwahl
    Given I am Normin
    And I am listing models
    When man einige Geräteparks abwählt
    Then wird die Modellliste nach den übrig gebliebenen Geräteparks gefiltert
    And die Auswahl klappt nocht nicht zu
    And im Filter steht die Zahl der ausgewählten Geräteparks

  @javascript @personas
  Scenario: Geräteparkauswahl Einzelabwahl bis auf einen Gerätepark
    Given I am Normin
    And I am listing models
    When man alle Geräteparks bis auf einen abwählt
    Then wird die Modellliste nach dem übrig gebliebenen Gerätepark gefiltert
    And die Auswahl klappt nocht nicht zu
    And im Filter steht der Name des übriggebliebenen Geräteparks

  @javascript @personas
  Scenario: Alles zurücksetzen
    Given I am Normin
    And I am listing models
    And Filter sind ausgewählt
    And die Schaltfläche "Alles zurücksetzen" ist aktivert
    When man "Alles zurücksetzen" wählt
    Then sind alle Geräteparks in der Geräteparkauswahl wieder ausgewählt
    And der Ausleihezeitraum ist leer
    And die Sortierung ist nach Modellnamen (aufsteigend)
    And das Suchfeld ist leer
    And man sieht wieder die ungefilterte Liste der Modelle
    And die Schaltfläche "Alles zurücksetzen" ist deaktiviert

  @javascript @personas
  Scenario: Alles zurücksetzen verschwindet automatisch, wenn die Filter wieder auf die Starteinstellungen gesetzt werden
    Given I am Normin
    And I am listing models
    And Filter sind ausgewählt
    And die Schaltfläche "Alles zurücksetzen" ist aktivert
    When ich alle Filter manuell zurücksetze
    Then verschwindet auch die "Alles zurücksetzen" Schaltfläche

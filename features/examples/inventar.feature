Feature: Inventory

  Background:
    Given I am Mike
    And I open the inventory

  @javascript @personas
  Scenario: Finding inventory using a search term
    Given there is a model with the following properties:
      | Name       | suchbegriff1 |
      | Hersteller | suchbegriff4 |
    And there is a item with the following properties:
      | Inventarcode | suchbegriff2 |
    When I search in the inventory section for one of those properties
    Then all matching models appear
    And all matching items appear

  @javascript @personas
  Scenario: Finding packages using search term
    Given there is a model with the following properties:
      | Name | Package Model |
    And this model is a package
    And there is a item with the following properties:
      | Inventory code | P-AVZ40001 |
    And this package item is part of this package model
    And there is a model with the following properties:
      | Name | Normal Model |
    And there is a item with the following properties:
      | Inventory code | AVZ40020 |
    And this item is part of this package item
    When I search in the inventory section for one of those properties
    Then all matching package models appear
    And all matching package items appear
    And all matching items appear

  @personas @javascript
  Scenario: Finding model and item in the inventory pool that owns them
    Given there is a model with the following properties:
      | Name | Package Model |
    And this model is a package
    And there is a item with the following properties:
      | Inventory code             | P-AVZ40001             |
      | Owner                      | Another inventory pool |
      | Responsible inventory pool | Another inventory pool |
    And this package item is part of this package model
    And there is a model with the following properties:
      | Name | Normal Model |
    And there is a item with the following properties:
      | Inventory code             | AVZ40020               |
      | Owner                      | Current inventory pool |
      | Responsible inventory pool | Another inventory pool |
    And this item is part of this package item
    When I search for the following properties in the inventory section:
      | Normal Model |
    Then the item corresponding to the model appears
    And the item appears
    When I search for the following properties in the inventory section:
      | AVZ40020 |
    Then the item corresponding to the model appears
    And the item appears

  @personas @javascript
  Scenario Outline: Finding a package's models and items in its responsible inventory pool
    Given there is a model with the following properties:
      | Name | Package Model |
    And this model is a package
    And there is a item with the following properties:
      | Inventory code             | P-AVZ40001             |
      | Owner                      | Current inventory pool |
      | Responsible inventory pool | Current inventory pool |
    And this package item is part of this package model
    And there is a model with the following properties:
      | Name | Normal Model |
    And there is a item with the following properties:
      | Inventory code             | AVZ40020               |
      | Owner                      | Another inventory pool |
      | Responsible inventory pool | Current inventory pool |
    And this item is part of this package item
    When I search for the following properties in the inventory section:
      | <property> |
    Then the item corresponding to the model appears
    And the item appears
    And all matching package models appear
    And all matching package items appear
    And all matching items appear
  Examples:
    | property     |
    | Normal Model |
    | AVZ40020     |

  @personas @javascript @browser
  Scenario: The tab 'All'
    Then I can click one of the following tabs to filter inventory by:
      | Choice |
      | All               |

  @personas @javascript @browser
  Scenario: The tab 'Models'
    Then I can click one of the following tabs to filter inventory by:
      | Choice |
      | Models            |

  @personas @javascript @browser
  Scenario: The tab 'Options'
    Then I can click one of the following tabs to filter inventory by:
      | Choice |
      | Options           |

  @personas @javascript @browser
  Scenario: The tab 'Software'
    Then I can click one of the following tabs to filter inventory by:
      | Choice |
      | Software           |

  @personas @javascript @browser
  Scenario Outline: Filtering used and unused inventory
    Given I see retired and not retired inventory
    When I choose inside all inventory as "<dropdown>" the option "<property>"
    Then only the "<property>" inventory is shown
  Examples:
    | dropdown        | property |
    | used & not used | used     |
    | used & not used | not used |

  @personas @javascript @browser
  Scenario Outline: Filtering borrowable and not borrowable inventory
    Given I see retired and not retired inventory
    When I choose inside all inventory as "<dropdown>" the option "<property>"
    Then only the "<property>" inventory is shown
  Examples:
    | dropdown                    | property       |
    | borrowable & not borrowable | borrowable     |
    | borrowable & not borrowable | not borrowable |

  @personas @javascript @browser
  Scenario Outline: Filtering retired and not retired inventory
    Given I see retired and not retired inventory
    When I choose inside all inventory as "<dropdown>" the option "<property>"
    Then only the "<property>" inventory is shown
  Examples:
    | dropdown              | property    |
    | retired & not retired | retired     |
    | retired & not retired | not retired |

  @personas @javascript @browser
  Scenario Outline: Filter inventory by owner, stock, completeness and defective status
    Given I see retired and not retired inventory
    When I set the option "<filter>" inside of the full inventory
    Then only the "<filter>" inventory is shown
  Examples:
    | filter     |
    | Owned      |
    | In stock   |
    | Incomplete |
    | Broken     |

  @personas @javascript @browser
  Scenario: Filtering by responsible department
    Given I see retired and not retired inventory
    When I choose a certain responsible pool inside the whole inventory
    Then only the inventory is shown for which this pool is responsible

  @personas @javascript
  Scenario: The default filter is "not retired"
    Then for the following inventory groups the filter "not retired" is set
      | All     |
      | Models  |
      | Software |

  @personas @javascript
  Scenario: Default setting for the list view
    Then the tab "All" is active

  @personas
  Scenario: Default setting for the "Software" view
    # Undefined
    Then enthält die Auswahl "Software" Software und Software-Lizenzen
    And der Filter "Nicht Ausgemustert" ist aktiviert

  @javascript @personas
  Scenario: What an option line contains
    Given one is on the list of the options
    Then the option line contains the following information:
      | information |
      | Barcode     |
      | Name        |
      | Price       |

  @javascript @personas @browser
  Scenario: Expand package models
    Then I can expand each package model line
    And I see the packages contained in this package model
    And such a line looks like an item line
    And I can expand this package line
    And I see the components of this package
    And such a line shows only inventory code and model name of the component

  @javascript @personas
  Scenario: Aussehen einer Modell-Zeile
    When man eine Modell-Zeile sieht
    Then enthält die Modell-Zeile folgende Informationen:
      | information              |
      | Bild                     |
      | Name des Modells         |
      | Anzahl verfügbar (jetzt) |
      | Anzahl verfügbar (Total) |

  @javascript @personas @browser
  Scenario: Aussehen einer Gegenstands-Zeile
    When I view the tab "Models"
    And der Gegenstand an Lager ist und meine Abteilung für den Gegenstand verantwortlich ist
    Then enthält die Gegenstands-Zeile folgende Informationen:
      | information      |
      | Gebäudeabkürzung |
      | Raum             |
      | Gestell          |
    When meine Abteilung Besitzer des Gegenstands ist die Verantwortung aber auf eine andere Abteilung abgetreten hat
    Then enthält die Gegenstands-Zeile folgende Informationen:
      | information               |
      | Verantwortliche Abteilung |
      | Gebäudeabkürzung          |
      | Raum                      |
    When I view the tab "Models"
    And der Gegenstand nicht an Lager ist und eine andere Abteilung für den Gegenstand verantwortlich ist
    Then enthält die Gegenstands-Zeile folgende Informationen:
      | information               |
      | Verantwortliche Abteilung |
      | Aktueller Ausleihender    |
      | Enddatum der Ausleihe     |

  @javascript @personas @browser
  Scenario: Aussehen einer Software-Lizenz-Zeile
    Given there exists a software license
    And I see retired and not retired inventory
    When I look at this license in the software list
    Then enthält die Software-Lizenz-Zeile folgende Informationen:
      | information    |
      | Betriebssystem |
      | Lizenztyp      |
    Given there exists a software license of one of the following types
      | Typ         | technical          |
      | Konkurrent  | concurrent         |
      | Site-Lizenz | site_license       |
      | Mehrplatz   | multiple_workplace |
    When I look at this license in the software list
    Then enthält die Software-Lizenz-Zeile folgende Informationen:
      | information    |
      | Betriebssystem |
      | Lizenztyp      |
      | Anzahl         |
    Given there exists a software license, owned by my inventory pool, but given responsibility to another inventory pool
    When I look at this license in the software list
    Then enthält die Software-Lizenz-Zeile folgende Informationen:
      | information               |
      | Verantwortliche Abteilung |
      | Betriebssystem            |
      | Lizenztyp                 |
    Given there exists a software license, which is not in stock and another inventory pool is responsible for it
    When I look at this license in the software list
    Then enthält die Software-Lizenz-Zeile folgende Informationen:
      | information               |
      | Verantwortliche Abteilung |
      | Aktueller Ausleihender    |
      | Enddatum der Ausleihe     |
      | Betriebssystem            |
      | Lizenztyp                 |

  @javascript @personas
  Scenario: Keine Resultate auf der Liste des Inventars
    When ich eine resultatlose Suche mache
    Then sehe ich "Kein Eintrag gefunden"

  @javascript @personas @browser
  Scenario: Modell aufklappen
    Then kann man jedes Modell aufklappen
    And man sieht die Gegenstände, die zum Modell gehören
    And so eine Zeile sieht aus wie eine Gegenstands-Zeile

  #73278620
   @personas
  Scenario: Verhalten nach Speichern
    When ich einen Reiter auswähle
    And ich eine oder mehrere Filtermöglichkeiten verwende
    When ich eine aufgeführte Zeile editiere
    And I save
    Then werde ich zur Liste des eben gewählten Reiters mit den eben ausgewählten Filtern zurueckgefuehrt

  @personas @javascript
  Scenario Outline: Auszeichnung von defekten, ausgemusterten, unvollständigen oder nicht ausleihbaren Gegenstandszeilen
    Given I see the list of "<Zustand>" inventory
    When I open a model line
    Then the item line ist marked as "<Zustand>" in red
    Examples:
      | Zustand          |
      | Defekt           |
      | Ausgemustert     |
      | Unvollständig    |
      | Nicht ausleihbar |

  @personas @javascript @browser
  Scenario: Auszeichnung von mehreren Zuständen auf der Gegenstandszeile
    Given I see retired and not retired inventory
    And there exists an item with many problems
    When I search after this item in the inventory list
    And I open the model line of this item
    Then the problems of this item are displayed separated by a comma

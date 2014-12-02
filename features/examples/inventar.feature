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
      | Inventory Code                | P-AVZ40001         |
      | Owner          | Anderer Gerätepark |
      | Responsible inventory pool | Anderer Gerätepark |
    And this package item is part of this package model
    And there is a model with the following properties:
      | Name | Normal Model |
    And there is a item with the following properties:
      | Inventory Code                | AVZ40020           |
      | Owner          | Mein Gerätepark    |
      | Responsible inventory pool | Anderer Gerätepark |
    And this item is part of this package item
    When ich im Inventarbereich nach den folgenden Eigenschaften suche
    When I search for the following properties:
      | Normal Model |
    Then the item corresponding to the model appears
    And the item appears
    When I search for the following properties:
      | AVZ40020 |
    Then the item corresponding to the model appears
    And the item appears

  @personas @javascript
  Scenario Outline: Modell und Gegenstand eines Pakets in Verantwortlichem Gerätepark finden
    Given there is a model with the following properties:
      | Name | Package Model |
    And this model is a package
    And there is a item with the following properties:
      | Inventarcode                | P-AVZ40001      |
      | Besitzergerätepark          | Mein Gerätepark |
      | verantwortlicher Gerätepark | Mein Gerätepark |
    And this package item is part of this package model
    And there is a model with the following properties:
      | Name | Normal Model |
    And there is a item with the following properties:
      | Inventarcode                | AVZ40020           |
      | Besitzergerätepark          | Anderer Gerätepark |
      | verantwortlicher Gerätepark | Mein Gerätepark    |
    And this item is part of this package item
    When ich im Inventarbereich nach den folgenden Eigenschaften suche
      | <Eigenschaft> |
    Then appears the corresponding model to the item
    And appears the item
    Then all matching package models appear
    And all matching package items appear
    And all matching items appear
  Examples:
    | Eigenschaft  |
    | Normal Model |
    | AVZ40020     |

  @personas @javascript @browser
  Scenario: Auswahlmöglichkeiten: Alle-Tab
    Then kann man auf ein der folgenden Tabs klicken und dabei die entsprechende Inventargruppe sehen:
      | Auswahlmöglichkeit |
      | Alle               |

  @personas @javascript @browser
  Scenario: Auswahlmöglichkeiten: Modell-Tab
    Then kann man auf ein der folgenden Tabs klicken und dabei die entsprechende Inventargruppe sehen:
      | Auswahlmöglichkeit |
      | Modelle            |

  @personas @javascript @browser
  Scenario: Auswahlmöglichkeiten: Optionen-Tab
    Then kann man auf ein der folgenden Tabs klicken und dabei die entsprechende Inventargruppe sehen:
      | Auswahlmöglichkeit |
      | Optionen           |

  @personas @javascript @browser
  Scenario: Auswahlmöglichkeiten: Software-Tab
    Then kann man auf ein der folgenden Tabs klicken und dabei die entsprechende Inventargruppe sehen:
      | Auswahlmöglichkeit |
      | Software           |

  @personas @javascript @browser
  Scenario Outline: Auswahlmöglichkeiten: genutzt & ungenutzt
    Given I see retired and not retired inventory
    When I choose inside all inventory as "<Select-Feld>" the option "<Eigenschaft>"
    Then only the "<Eigenschaft>" inventory is shown
  Examples:
    | Select-Feld         | Eigenschaft   |
    | genutzt & ungenutzt | genutzt       |
    | genutzt & ungenutzt | nicht genutzt |

  @personas @javascript @browser
  Scenario Outline: Auswahlmöglichkeiten: ausleihbar & nicht ausleihbar
    Given I see retired and not retired inventory
    When I choose inside all inventory as "<Select-Feld>" the option "<Eigenschaft>"
    Then only the "<Eigenschaft>" inventory is shown
  Examples:
    | Select-Feld                   | Eigenschaft      |
    | ausleihbar & nicht ausleihbar | ausleihbar       |
    | ausleihbar & nicht ausleihbar | nicht ausleihbar |

  @personas @javascript @browser
  Scenario Outline: Auswahlmöglichkeiten: ausgemustert & nicht ausgemustert
    Given I see retired and not retired inventory
    When I choose inside all inventory as "<Select-Feld>" the option "<Eigenschaft>"
    Then only the "<Eigenschaft>" inventory is shown
  Examples:
    | Select-Feld                       | Eigenschaft        |
    | ausgemustert & nicht ausgemustert | ausgemustert       |
    | ausgemustert & nicht ausgemustert | nicht ausgemustert |

  @personas @javascript @browser
  Scenario Outline: Auswahlmöglichkeiten: Checkboxen
    Given I see retired and not retired inventory
    When I set the option "<Filterwahl>" inside of the full inventory
    Then only the "<Filterwahl>" inventory is shown
  Examples:
    | Filterwahl    |
    | Im Besitz     |
    | An Lager      |
    | Unvollständig |
    | Defekt        |

  @personas @javascript @browser
  Scenario: Auswahlmöglichkeiten: verantwortliche Abteilung
    Given I see retired and not retired inventory
    When I choose a certain responsible pool inside the whole inventory
    Then only the inventory is shown, for which this pool is responsible

  @personas @javascript
  Scenario: Default-Filter "nicht ausgemustert"
    Then for the following inventory groups the filter "nicht ausgemustert" is set
      | Alle     |
      | Modelle  |
      | Software |

  @personas @javascript
  Scenario: Grundeinstellung der Listenansicht
    Then ist die Auswahl "Alle" aktiviert

  @personas @javascript
  Scenario: Grundeinstellung der Listenansicht
    Then ist die Auswahl "Alle" aktiviert

  @personas
  Scenario: Inhalt der Auswahl "Software"
    Then enthält die Auswahl "Software" Software und Software-Lizenzen
    And der Filter "Nicht Ausgemustert" ist aktiviert

  @personas @javascript
  Scenario: Grundeinstellung der Listenansicht
    Then ist die Auswahl "Alle" aktiviert

  @personas
  Scenario: Inhalt der Auswahl "Software"
    Then enthält die Auswahl "Software" Software und Software-Lizenzen
    And der Filter "Nicht Ausgemustert" ist aktiviert

  @personas @javascript
  Scenario: Grundeinstellung der Listenansicht
    Then ist die Auswahl "Alle" aktiviert

  @javascript @personas
  Scenario: Aussehen einer Options-Zeile
    Given one is on the list of the options
    Then enthält die Options-Zeile folgende Informationen
      | information |
      | Barcode     |
      | Name        |
      | Preis       |

  @javascript @personas
  Scenario: Paket-Modelle aufklappen
    Then kann man jedes Paket-Modell aufklappen
    And man sieht die Pakete dieses Paket-Modells
    And so eine Zeile sieht aus wie eine Gegenstands-Zeile
    And man kann diese Paket-Zeile aufklappen
    And man sieht die Bestandteile, die zum Paket gehören
    And so eine Zeile zeigt nur noch Inventarcode und Modellname des Bestandteils

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


Feature: Inventar

  Grundlage:
    Given I am Mike
    And man öffnet die Liste des Inventars

  @javascript @personas
  Scenario: Inventar anhand eines Suchbegriffs finden
    Given es existiert ein Modell mit folgenden Eigenschaften:
      | Name       | suchbegriff1 |
      | Hersteller | suchbegriff4 |
    And es existiert ein Gegenstand mit folgenden Eigenschaften:
      | Inventarcode | suchbegriff2 |
    When ich im Inventarbereich nach einer dieser Eigenschaften suche
    Then es erscheinen alle zutreffenden Modelle
    And es erscheinen alle zutreffenden Gegenstände

  @javascript @personas
  Scenario: Pakete anhand eines Suchbegriffs finden
    Given es existiert ein Modell mit folgenden Eigenschaften:
      | Name | Package Model |
    And diese Modell ein Paket ist
    And es existiert ein Gegenstand mit folgenden Eigenschaften:
      | Inventarcode | P-AVZ40001 |
    And diese Paket-Gegenstand ist Teil des Pakets-Modells
    And es existiert ein Modell mit folgenden Eigenschaften:
      | Name | Normal Model |
    And es existiert ein Gegenstand mit folgenden Eigenschaften:
      | Inventarcode | AVZ40020 |
    And dieser Gegenstand ist Teil des Paket-Gegenstandes
    When ich im Inventarbereich nach einer dieser Eigenschaften suche
    Then es erscheinen alle zutreffenden Paket-Modelle
    And es erscheinen alle zutreffenden Paket-Gegenstände
    And es erscheinen alle zutreffenden Gegenstände

  @personas @javascript
  Scenario: Modell und Gegenstand eines Pakets in Besitzergerätepark finden
    Given es existiert ein Modell mit folgenden Eigenschaften:
      | Name | Package Model |
    And diese Modell ein Paket ist
    And es existiert ein Gegenstand mit folgenden Eigenschaften:
      | Inventarcode                | P-AVZ40001         |
      | Besitzergerätepark          | Anderer Gerätepark |
      | verantwortlicher Gerätepark | Anderer Gerätepark |
    And diese Paket-Gegenstand ist Teil des Pakets-Modells
    And es existiert ein Modell mit folgenden Eigenschaften:
      | Name | Normal Model |
    And es existiert ein Gegenstand mit folgenden Eigenschaften:
      | Inventarcode                | AVZ40020           |
      | Besitzergerätepark          | Mein Gerätepark    |
      | verantwortlicher Gerätepark | Anderer Gerätepark |
    And dieser Gegenstand ist Teil des Paket-Gegenstandes
    When ich im Inventarbereich nach den folgenden Eigenschaften suche
      | Normal Model |
    Then erscheint das entsprechende Modell zum Gegenstand
    And es erscheint der Gegenstand
    When ich im Inventarbereich nach den folgenden Eigenschaften suche
      | AVZ40020 |
    Then erscheint das entsprechende Modell zum Gegenstand
    And es erscheint der Gegenstand

  @personas @javascript
  Scenario Outline: Modell und Gegenstand eines Pakets in Verantwortlichem Gerätepark finden
    Given es existiert ein Modell mit folgenden Eigenschaften:
      | Name | Package Model |
    And diese Modell ein Paket ist
    And es existiert ein Gegenstand mit folgenden Eigenschaften:
      | Inventarcode                | P-AVZ40001      |
      | Besitzergerätepark          | Mein Gerätepark |
      | verantwortlicher Gerätepark | Mein Gerätepark |
    And diese Paket-Gegenstand ist Teil des Pakets-Modells
    And es existiert ein Modell mit folgenden Eigenschaften:
      | Name | Normal Model |
    And es existiert ein Gegenstand mit folgenden Eigenschaften:
      | Inventarcode                | AVZ40020           |
      | Besitzergerätepark          | Anderer Gerätepark |
      | verantwortlicher Gerätepark | Mein Gerätepark    |
    And dieser Gegenstand ist Teil des Paket-Gegenstandes
    When ich im Inventarbereich nach den folgenden Eigenschaften suche
      | <Eigenschaft> |
    Then erscheint das entsprechende Modell zum Gegenstand
    And es erscheint der Gegenstand
    Then es erscheinen alle zutreffenden Paket-Modelle
    And es erscheinen alle zutreffenden Paket-Gegenstände
    And es erscheinen alle zutreffenden Gegenstände
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
    Given ich sehe ausgemustertes und nicht ausgemustertes Inventar
    When ich innerhalb des gesamten Inventars als "<Select-Feld>" die Option "<Eigenschaft>" wähle
    Then wird nur das "<Eigenschaft>" Inventar angezeigt
  Examples:
    | Select-Feld         | Eigenschaft   |
    | genutzt & ungenutzt | genutzt       |
    | genutzt & ungenutzt | nicht genutzt |

  @personas @javascript @browser
  Scenario Outline: Auswahlmöglichkeiten: ausleihbar & nicht ausleihbar
    Given ich sehe ausgemustertes und nicht ausgemustertes Inventar
    When ich innerhalb des gesamten Inventars als "<Select-Feld>" die Option "<Eigenschaft>" wähle
    Then wird nur das "<Eigenschaft>" Inventar angezeigt
  Examples:
    | Select-Feld                   | Eigenschaft      |
    | ausleihbar & nicht ausleihbar | ausleihbar       |
    | ausleihbar & nicht ausleihbar | nicht ausleihbar |

  @personas @javascript @browser
  Scenario Outline: Auswahlmöglichkeiten: ausgemustert & nicht ausgemustert
    Given ich sehe ausgemustertes und nicht ausgemustertes Inventar
    When ich innerhalb des gesamten Inventars als "<Select-Feld>" die Option "<Eigenschaft>" wähle
    Then wird nur das "<Eigenschaft>" Inventar angezeigt
  Examples:
    | Select-Feld                       | Eigenschaft        |
    | ausgemustert & nicht ausgemustert | ausgemustert       |
    | ausgemustert & nicht ausgemustert | nicht ausgemustert |

  @personas @javascript @browser
  Scenario Outline: Auswahlmöglichkeiten: Checkboxen
    Given ich sehe ausgemustertes und nicht ausgemustertes Inventar
    When ich innerhalb des gesamten Inventars die "<Filterwahl>" setze
    Then wird nur das "<Filterwahl>" Inventar angezeigt
  Examples:
    | Filterwahl    |
    | Im Besitz     |
    | An Lager      |
    | Unvollständig |
    | Defekt        |

  @personas @javascript @browser
  Scenario: Auswahlmöglichkeiten: verantwortliche Abteilung
    Given ich sehe ausgemustertes und nicht ausgemustertes Inventar
    When ich innerhalb des gesamten Inventars ein bestimmtes verantwortliche Gerätepark wähle
    Then wird nur das Inventar angezeigt, für welche dieses Gerätepark verantwortlich ist

  @personas @javascript
  Scenario: Default-Filter "nicht ausgemustert"
    Then ist bei folgenden Inventargruppen der Filter "nicht ausgemustert" per Default eingestellt:
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
    Given man befindet sich auf der Liste der Optionen
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
    Given es gibt eine Software-Lizenz
    And ich sehe ausgemustertes und nicht ausgemustertes Inventar
    When ich diese Lizenz in der Softwareliste anschaue
    Then enthält die Software-Lizenz-Zeile folgende Informationen:
      | information    |
      | Betriebssystem |
      | Lizenztyp      |
    Given es gibt eine Software-Lizenz mit einem der folgenden Typen:
      | Typ         | technical          |
      | Konkurrent  | concurrent         |
      | Site-Lizenz | site_license       |
      | Mehrplatz   | multiple_workplace |
    When ich diese Lizenz in der Softwareliste anschaue
    Then enthält die Software-Lizenz-Zeile folgende Informationen:
      | information    |
      | Betriebssystem |
      | Lizenztyp      |
      | Anzahl         |
    Given es gibt eine Software-Lizenz, wo meine Abteilung der Besitzer ist, die Verantwortung aber auf eine andere Abteilung abgetreten hat
    When ich diese Lizenz in der Softwareliste anschaue
    Then enthält die Software-Lizenz-Zeile folgende Informationen:
      | information               |
      | Verantwortliche Abteilung |
      | Betriebssystem            |
      | Lizenztyp                 |
    Given es gibt eine Software-Lizenz, die nicht an Lager ist und eine andere Abteilung für die Software-Lizenz verantwortlich ist
    When ich diese Lizenz in der Softwareliste anschaue
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
    Given ich befinde mich auf der Liste eines "<Zustand>"en Inventars
    When ich eine Modellzeile öffne
    Then ist die Gegenstandszeile mit "<Zustand>" in rot ausgezeichnet
    Examples:
      | Zustand          |
      | Defekt           |
      | Ausgemustert     |
      | Unvollständig    |
      | Nicht ausleihbar |

  @personas @javascript @browser
  Scenario: Auszeichnung von mehreren Zuständen auf der Gegenstandszeile
    Given ich sehe ausgemustertes und nicht ausgemustertes Inventar
    And es exisitert ein Gegenstand mit mehreren Problemen
    When ich nach diesem Gegenstand in der Inventarliste suche
    And ich öffne die Modellzeile von diesem Gegenstand
    Then sind die Probleme des Gegestandes komma getrennt aneinander gereiht

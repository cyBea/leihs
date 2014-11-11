
Feature: Modellliste

  Um Modelle zu bestellen
  möchte ich als Kunde
  die Möglichkeit haben Modelle zu finden

  @personas
  Scenario: Modelllistenübersicht
    Given I am Normin
    When man sich auf der Modellliste befindet
    Then sieht man die Explorative Suche
    And man sieht die Modelle der ausgewählten Kategorie
    And man sieht Sortiermöglichkeiten
    And man sieht die Gerätepark-Auswahl
    And man sieht die Einschränkungsmöglichkeit eines Ausleihzeitraums

  @personas
  Scenario: Ein einzelner Modelllisteneintrag
    Given I am Normin
    When man sich auf der Modellliste befindet
    And einen einzelner Modelleintrag beinhaltet
    | Bild                 |
    | Modellname           |
    | Herstellname         |
    | Auswahl-Schaltfläche |

  @javascript @browser @personas
  Scenario: Modellliste scrollen
    Given I am Normin
    And man sieht eine Modellliste die gescroll werden muss
    When bis ans ende der bereits geladenen Modelle fährt
    Then wird der nächste Block an Modellen geladen und angezeigt
    When I scroll to the end of the list
    Then wurden alle Modelle der ausgewählten Kategorie geladen und angezeigt

  @javascript @personas
  Scenario: Modellliste sortieren
    Given I am Normin
    And man sich auf der Modellliste befindet
    When man die Liste nach "Modellname (alphabetisch aufsteigend)" sortiert
    Then ist die Liste nach "Modellname" "(alphabetisch aufsteigend)" sortiert
    When man die Liste nach "Modellname (alphabetisch absteigend)" sortiert
    Then ist die Liste nach "Modellname" "(alphabetisch absteigend)" sortiert
    When man die Liste nach "Herstellername (alphabetisch aufsteigend)" sortiert
    Then ist die Liste nach "Herstellername" "(alphabetisch aufsteigend)" sortiert
    When man die Liste nach "Herstellername (alphabetisch absteigend)" sortiert
    Then ist die Liste nach "Herstellername" "(alphabetisch absteigend)" sortiert

  @personas
  Scenario: Ausleihezeitraum Standarteinstellung
    Given I am Normin
    When man sich auf der Modellliste befindet
    Then ist kein Ausleihzeitraum ausgewählt

  @javascript @personas
  Scenario: Geräteparkauswahl kann nicht leer sein
    Given I am Normin
    When man sich auf der Modellliste befindet
    Then kann man nicht alle Geräteparks in der Geräteparkauswahl abwählen

  @personas
  Scenario: Geräteparkauswahl sortierung
    Given I am Normin
    When man sich auf der Modellliste befindet
    Then ist die Geräteparkauswahl alphabetisch sortiert

  @javascript @browser @personas
  Scenario: Geräteparkauswahl "alle auswählen"
    Given I am Normin
    When man sich auf der Modellliste befindet
    And man wählt alle Geräteparks bis auf einen ab
    And man wählt "Alle Geräteparks"
    Then sind alle Geräteparks wieder ausgewählt
    And die Auswahl klappt noch nicht zu
    And die Liste zeigt Modelle aller Geräteparks

  @javascript @personas
  Scenario: Geräteparkauswahl kann nicht leer sein
    Given I am Normin
    When man sich auf der Modellliste befindet
    Then kann man nicht alle Geräteparks in der Geräteparkauswahl abwählen

  @javascript @personas @browser
  Scenario: Ausleihezeitraum Startdatum wählen
    Given I am Petra
    When man sich auf der Modellliste befindet die nicht verfügbare Modelle beinhaltet
    And man ein Startdatum auswählt
    Then wird automatisch das Enddatum auf den folgenden Tag gesetzt
    And die Liste wird gefiltert nach Modellen die in diesem Zeitraum verfügbar sind

  @javascript @personas
  Scenario: Ausleihezeitraum Enddatum wählen
    Given I am Petra
    When man sich auf der Modellliste befindet die nicht verfügbare Modelle beinhaltet
    And man ein Enddatum auswählt
    Then wird automatisch das Startdatum auf den vorhergehenden Tag gesetzt
    And die Liste wird gefiltert nach Modellen die in diesem Zeitraum verfügbar sind

  @javascript @personas
  Scenario: Ausleihzeitraum löschen
    Given I am Petra
    When man sich auf der Modellliste befindet die nicht verfügbare Modelle beinhaltet
    And das Startdatum und Enddatum des Ausleihzeitraums sind ausgewählt
    When man das Startdatum und Enddatum leert
    Then wird die Liste nichtmehr nach Ausleihzeitraum gefiltert

  @javascript @personas
  Scenario: Ausleihzeitraum Datepicker
    Given I am Normin
    And man sich auf der Modellliste befindet
    Then kann man für das Startdatum und für das Enddatum den Datepick benutzen

  @javascript @personas
  Scenario: Modell suchen
    Given I am Normin
    And man befindet sich auf der Modellliste 
    When man ein Suchwort eingibt
    Then werden diejenigen Modelle angezeigt, deren Name oder Hersteller dem Suchwort entsprechen

  @javascript @browser @personas
  Scenario: Hovern über Modellen
    Given I am Normin
    And es gibt ein Modell mit Bilder, Beschreibung und Eigenschaften
    And man befindet sich auf der Modellliste mit diesem Modell
    When man über das Modell hovered
    Then werden zusätzliche Informationen angezeigt zu Modellname, Bilder, Beschreibung, Liste der Eigenschaften
    And wenn ich den Kalendar für dieses Modell benutze
    Then können die zusätzliche Informationen immer noch abgerufen werden

  @personas
  Scenario: Geräteparkauswahl Standartwert
    Given I am Normin
    When man sich auf der Modellliste befindet
    Then sind alle Geräteparks ausgewählt
    And die Modellliste zeigt Modelle aller Geräteparks an
    And im Filter steht "Alle Geräteparks"

  @javascript @personas
  Scenario: Geräteparkauswahl Einzelauswählen
    Given I am Normin
    And man befindet sich auf der Modellliste
    When man ein bestimmten Gerätepark in der Geräteparkauswahl auswählt
    Then sind alle anderen Geräteparks abgewählt
    And die Modellliste zeigt nur Modelle dieses Geräteparks an
    And die Auswahl klappt noch nicht zu
    And im Filter steht der Name des ausgewählten Geräteparks

  @javascript @personas
  Scenario: Geräteparkauswahl Einzelabwahl
    Given I am Normin
    And man befindet sich auf der Modellliste
    When man einige Geräteparks abwählt
    Then wird die Modellliste nach den übrig gebliebenen Geräteparks gefiltert
    And die Auswahl klappt nocht nicht zu
    And im Filter steht die Zahl der ausgewählten Geräteparks

  @javascript @personas
  Scenario: Geräteparkauswahl Einzelabwahl bis auf einen Gerätepark
    Given I am Normin
    And man befindet sich auf der Modellliste
    When man alle Geräteparks bis auf einen abwählt
    Then wird die Modellliste nach dem übrig gebliebenen Gerätepark gefiltert
    And die Auswahl klappt nocht nicht zu
    And im Filter steht der Name des übriggebliebenen Geräteparks

  @javascript @personas
  Scenario: Alles zurücksetzen
    Given I am Normin
    And man befindet sich auf der Modellliste
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
    And man befindet sich auf der Modellliste
    And Filter sind ausgewählt
    And die Schaltfläche "Alles zurücksetzen" ist aktivert
    When ich alle Filter manuell zurücksetze
    Then verschwindet auch die "Alles zurücksetzen" Schaltfläche

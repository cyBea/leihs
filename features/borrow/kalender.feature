
Feature: Calendar

  Background:
    Given I am Normin

  @javascript @browser @personas
  Scenario: Calendar components
    When I add an item from the model list
    Then the calendar opens
    And the calendar contains all necessary interface elements

  @javascript @personas
  Scenario: Default appearance of the calendar
    When I add an item from the model list
    Then the calendar opens
    And the current start date is today
    And the end date is tomorrow
    And the quantity is 1
    And all inventory pools are shown that have items of this model

  @javascript @browser @personas
  Scenario: Calendar appearance with date already set
    Given I am listing models
    And I have set a time span
    When I add an item to my order that is available in the selected time span
    Then the calendar opens
    And the start date is equal to the preselected start date
    And the end date is equal to the preselected end date

  @javascript @personas
  Scenario: Calendar appearance with inventory pools already set
    Given I am listing models
    And I reduce the selected inventory pools
    And I add a model to the order that is available across all the still remaining inventory pools
    Then the calendar opens
    And that inventory pool which comes alphabetically first is selected
    Then any closed days of the selected inventory pool are shown

  @javascript  @browser @personas
  Scenario: Kalender zwischen Monaten hin und herspringen
    Given man hat den Buchungskalender geöffnet
    When man zwischen den Monaten hin und herspring
    Then wird der Kalender gemäss aktuell gewähltem Monat angezeigt

  @javascript @personas
  Scenario: Kalender Sprung zu Start und Enddatum
    Given man hat den Buchungskalender geöffnet
    When man anhand der Sprungtaste zum aktuellen Startdatum springt
    Then wird das Startdatum im Kalender angezeigt
    When man anhand der Sprungtaste zum aktuellen Enddatum springt
    Then wird das Enddatum im Kalender angezeigt

  @javascript @browser @personas
  Scenario: Meiner Bestellung einen Gegenstand hinzufügen
    When man sich auf der Modellliste befindet die verfügbare Modelle beinhaltet
    And man auf einem verfügbaren Model "Zur Bestellung hinzufügen" wählt
    Then the calendar opens
    When alle Angaben die ich im Kalender mache gültig sind
    Then ist das Modell mit Start- und Enddatum, Anzahl und Gerätepark der Bestellung hinzugefügt worden

  @javascript @personas
  Scenario: Kalender max. Verfügbarkeit
    Given man hat den Buchungskalender geöffnet
    Then wird die maximal ausleihbare Anzahl des ausgewählten Modells angezeigt
    And man kann maximal die maximal ausleihbare Anzahl eingeben

  @javascript @personas
  Scenario: Auswählbare Geräteparks im Kalender
    Given man hat den Buchungskalender geöffnet
    Then sind nur diejenigen Geräteparks auswählbar, welche über Kapizäteten für das ausgewählte Modell verfügen
    And die Geräteparks sind alphabetisch sortiert

  @javascript @personas
  Scenario: Kalender Anzeige der Schliesstage
    Given man hat den Buchungskalender geöffnet

  @javascript @browser @personas
  Scenario: Bestellkalender nutzen nach dem man alle Filter zurückgesetzt hat
    Given ich ein Modell der Bestellung hinzufüge
    And I am listing models
    And man den zweiten Gerätepark in der Geräteparkauswahl auswählt
    When man "Alles zurücksetzen" wählt
    And man auf einem Model "Zur Bestellung hinzufügen" wählt
    Then öffnet sich der Kalender
    Then the calendar opens
    When alle Angaben die ich im Kalender mache gültig sind
    Then lässt sich das Modell mit Start- und Enddatum, Anzahl und Gerätepark der Bestellung hinzugefügen

  @javascript @browser @personas
  Scenario: Etwas bestellen, was nur Gruppen vorbehalten ist
    When ein Modell existiert, welches nur einer Gruppe vorbehalten ist
    Then kann ich dieses Modell ausleihen, wenn ich in dieser Gruppe bin

  @javascript @browser @personas
  Scenario: Kalender Bestellung nicht möglich, wenn Auswahl nicht verfügbar
    When man versucht ein Modell zur Bestellung hinzufügen, welches nicht verfügbar ist
    Then schlägt der Versuch es hinzufügen fehl
    And ich sehe die Fehlermeldung, dass das ausgewählte Modell im ausgewählten Zeitraum nicht verfügbar ist

  @javascript @personas
  Scenario: Bestellkalender schliessen
    When I am listing models
    And man auf einem Model "Zur Bestellung hinzufügen" wählt
    Then the calendar opens
    When ich den Kalender schliesse
    Then schliesst das Dialogfenster

  @javascript @personas
  Scenario: Kalender Verfügbarkeitsanzeige
    Given es existiert ein Modell für das eine Bestellung vorhanden ist
    When man dieses Modell aus der Modellliste hinzufügt
    Then the calendar opens
    And wird die Verfügbarkeit des Modells im Kalendar angezeigt

  @javascript @personas
  Scenario: Kalender Verfügbarkeitsanzeige nach Änderung der Kalenderdaten
    Given es existiert ein Modell für das eine Bestellung vorhanden ist
    When man dieses Modell aus der Modellliste hinzufügt
    Then the calendar opens
    When man ein Start und Enddatum ändert
    Then wird die Verfügbarkeit des Gegenstandes aktualisiert
    When man die Anzahl ändert
    Then wird die Verfügbarkeit des Gegenstandes aktualisiert

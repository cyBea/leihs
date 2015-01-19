Feature: Order window

  This all happens in the borrow section.

  Background:
    Given I am Normin

  @personas
  Scenario: Order window
    Given I am on the main category list
    Then I see the order window

  @personas
  Scenario: No order window
    Given I am listing my orders
    Then I do not see the order window

  @personas
  Scenario: Content of the order window
    When I add a model to an order
    Then it appears in the order window
    And the models in the order window are sorted alphabetically
    And identical models are collapsed
    When I add the same model one more time
    Then its quantity is increased
    And the models in the order window are sorted alphabetically
    And identical models are collapsed
    And I can go to the detailed order overview

  @javascript @browser @personas
  Scenario: Updating the order window from the calendar
    When I add a model to the order using the calendar
    Then the order window is updated

  @javascript @personas
  Scenario: Zeitentität, Ablauf der erlaubten Zeit anzeigen
    Given meine Bestellung ist leer
    When man befindet sich auf der Seite der Hauptkategorien
    Then sehe ich keine Zeitanzeige
    When ich ein Modell der Bestellung hinzufüge
    Then sehe ich die Zeitanzeige
    And die Zeitanzeige ist in einer Schaltfläche im Reiter "Bestellung" auf der rechten Seite
    And die Zeitanzeige zählt von 30 Minuten herunter

  @personas
  Scenario: Zeit zurücksetzen
    Given die Bestellung ist nicht leer
    Then sehe ich die Zeitanzeige
    When ich den Time-Out zurücksetze
    Then wird die Zeit zurückgesetzt

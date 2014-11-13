Feature: Edit a hand over

  Background:
    Given I am Pius

  @javascript @browser @personas
  Scenario: Feedback on a successful manual interaction during hand over
    Given there is a hand over with at least one unproblematic model and an option
    And I open the hand over
    When I assign an inventory code to the unproblematic model
    Then the item is assigned to the line
    And the line is selected
    And the line is highlighted in green
    Then I receive a notification of success
    When I deselect the line
    Then the line is no longer highlighted in green
    When I reselect the line
    Then the line is highlighted in green
    When I remove the assigned item from the line
    Then the line is no longer highlighted in green

  @javascript @browser @personas
  Scenario: Feedback on assigning an item to a problematic line
    Given there is a hand over with at least one problematic line
    And I open the hand over
    Then problem notifications are shown for the problematic model
    When I manually assign an inventory code to that line
    And the line is selected
    And the line is highlighted in green
    And the problem notifications remain on the line

  @personas @javascript
  Scenario: Show user's suspended state
    Given I open a hand over
    And the user in this hand over is suspended
    Then I see the note 'Suspended!' next to their name

  @javascript @browser @personas
  Scenario: System feedback when adding an option
    Given I open a hand over
    When I add an option
    Then the line is selected
    And the line is highlighted in green
    And I receive a notification

  @javascript @personas
  Scenario: Handing over an already assigned item
    Given I open a hand over with at least one assigned item
    When I assign an already added item
    Then I see the error message 'XY is already assigned to this contract'
    And the line remains selected
    And the line remains highlighted in green

  @javascript @personas
  Scenario: Standard-Vertragsnotiz
    Given für den Gerätepark ist eine Standard-Vertragsnotiz konfiguriert
    And ich öffne eine Aushändigung mit mindestens einem zugewiesenen Gegenstand
    When ich die Gegenstände aushändige
    Then erscheint ein Aushändigungsdialog
    And diese Standard-Vertragsnotiz erscheint im Textfeld für die Vertragsnotiz

  @javascript @personas
  Scenario: Vertragsnotiz
    When I open a hand over
    When ich aushändige
    Then erscheint ein Dialog
    And ich kann eine Notiz für diesen Vertrag eingeben
    When ich eine Notiz für diesen Vertrag eingebe
    Then erscheint diese Notiz auf dem Vertrag

  @javascript @browser @personas
  Scenario: Optionen mit einer Mindestmenge 1 ausgeben
    Given ich öffne eine Aushändigung
    When ich eine Option hinzufüge
    And ich die Anzahl "0" in das Mengenfeld schreibe
    Then wird die Menge mit dem ursprünglichen Wert überschrieben
    When ich die Anzahl "-1" in das Mengenfeld schreibe
    Then wird die Menge mit dem ursprünglichen Wert überschrieben
    When ich die Anzahl "abc" in das Mengenfeld schreibe
    Then wird die Menge mit dem ursprünglichen Wert überschrieben
    When ich die Anzahl "2" in das Mengenfeld schreibe
    Then wird die Menge mit dem Wert "2" gespeichert

  @javascript @browser @personas
  Scenario: Anzeige der Seriennummer bei Zuteilung der Software-Lizenz
    Given ich öffne eine Aushändigung mit einer Software
    When ich in das Zuteilungsfeld links vom Software-Namen klicke
    Then wird mir der Inventarcode sowie die vollständige Seriennummer angezeigt

  @javascript @browser @personas
  Scenario: Listung von problematischen Gegenständen
    Given es existiert ein Modell mit einem problematischen Gegenstand
    And ich öffne eine Aushändigung für irgendeinen Benutzer
    When ich diesen Modell der Aushändigung hinzufüge
    And ich auf der Modelllinie die Gegenstandsauswahl öffne
    Then wird der problematische Gegenstand in rot aufgelistet

  @javascript @browser @personas
  Scenario: Keine Auflistung von ausgemusterten Gegenständen
    Given es existiert ein Modell mit einem ausgemusterten und einem ausleihbaren Gegenstand
    And ich öffne eine Aushändigung für irgendeinen Benutzer
    When ich diesen Modell der Aushändigung hinzufüge
    And ich auf der Modelllinie die Gegenstandsauswahl öffne
    Then wird der ausgemusterte Gegenstand nicht aufgelistet

  @personas @javascript @browser
  Scenario: Anzeige von bereits zugewiesenen Gegenständen
    Given es besteht bereits eine Aushändigung mit mindestens 21 zugewiesenen Gegenständen für einen Benutzer
    When I open the hand over
    Then sehe ich all die bereits zugewiesenen Gegenstände mittels Inventarcodes

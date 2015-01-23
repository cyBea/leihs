Feature: Delegation

  @javascript @personas
  Scenario: Assigning a suspended responsible person to a delegation
    Given I am Pius
    And I am editing a delegation
    When I assign a responsible person that is suspended for the current inventory pool
    Then ist dieser bei der Auswahl rot markiert
    And I see the note 'Suspended!' next to their name

  @javascript @personas
  Scenario: Adding a suspended user to a delegation
    Given I am Pius
    And I am editing a delegation
    When I assign a responsible person that is suspended for the current inventory pool
    Then ist er bei der Auswahl rot markiert
    And I see the note 'Suspended!' next to their name

  @javascript @personas @browser
  Scenario: Choosing contact person when handing over
    Given I am Pius
    And there is a hand over for a delegation with assigned items
    And I open this hand over
    When I finish this hand over
    Then I have to specify a contact person

  @javascript @personas @browser
  Scenario: Displaying a suspended contact person while handing over
    Given I am Pius
    And there is a hand over for a delegation with assigned items
    And I open this hand over
    When I finish this hand over
    And I choose a suspended contact person
    Then ist diese Kontaktperson bei der Auswahl rot markiert
    And I see the note 'Suspended!' next to their name

  @javascript @personas @browser
  Scenario: Picking a suspended contact person while ordering
    Given I am Pius
    And I open an order
    And I swap the user
    And I pick a delegation
    When I pick a contact person that is suspended for the current inventory pool
    Then ist er bei der Auswahl rot markiert
    And I see the note 'Suspended!' next to their name

  @javascript @personas @browser
  Scenario: Switching an order from a delegation to a normal user while handing over
    Given I am Pius
    And I open a hand over for a delegation
    When I pick a user instead of a delegation
    Then the order shows the user

  @javascript @personas
  Scenario: Switching an order from a normal user to a delegation when handing over
    Given I am Pius
    And I open a hand over
    When I pick a delegation instead of a user
    Then the order shows the delegation

  @javascript @personas
  Scenario: Tooltip display
    Given I am Pius
    When I search for a delegation
    And I hover over the delegation name
    Then the tooltip shows name and responsible person for the delegation

  @javascript @personas
  Scenario: Global search
    Given I am Pius
    And I search for 'Julie'
    When Julie is in a delegation
    Then I see all results for Julie or the delegation named Julie
    And I see all delegations Julie is a member of

  @personas
  Scenario: Suspended users can't submit orders
    Given I am Julie
    When ich von meinem Benutzer zu einer Delegation wechsle
    And die Delegation ist für einen Gerätepark freigeschaltet
    But ich bin für diesen Gerätepark gesperrt
    Then kann ich keine Gegenstände dieses Geräteparks absenden

  @javascript @personas
  Scenario: Filter der Delegationen
    Given I am Pius
    When I navigate to the admin area
    And I am listing users
    Then I can restrict the user list to show only delegations
    And I can restrict the user list to show only users

  @javascript @personas
  Scenario: Creating a delegation
    Given I am Pius
    And I navigate to the admin area
    And I am on the tab 'Users'
    When I create a new delegation
    And I give the delegation access to the current inventory pool
    And I give the delegation a name
    And I assign none, one or more people to the delegation
    And ich dieser Delegation keinen, einen oder mehrere Gruppen zuteile
    And I cannot assign a delegation to the delegation
    And I enter exactly one responsible person
    And I save
    Then the new delegation is saved with the current information

  @javascript @personas
  Scenario: Delegation gets access as a customer
    Given I am Pius
    And I navigate to the admin area
    And I am on the tab 'Users'
    When I create a new delegation
    Then I can at most give the delegation access on the customer level

  @javascript @personas @browser
  Scenario: Switching delegation to a user in an order
    Given I am Pius
    And there is an order for a delegation
    And I edit the order
    When I pick a user instead of a delegation
    Then the order shows the user
    And no contact person is shown

  @javascript @personas
  Scenario: Trying to create a delegation without filling in required fields
    Given I am Pius
    And I navigate to the admin area
    And I am on the tab 'Users'
    And I create a new delegation
    When I give the delegation a name
    And I do not enter any responsible person for the delegation
    And I save
    Then I see an error message
    When I enter exactly one responsible person
    When I do not enter any name
    And I save
    Then I see an error message

  @javascript @personas
  Scenario: Editing a delegation
    Given I am Pius
    And I navigate to the admin area
    And I am on the tab 'Users'
    When I edit a delegation
    And I change the responsible person
    And I delete an existing user from the delegation
    And I add a user to the delegation
    And I assign multiple groups
    And I save
    Then I see a confirmation of success on the list of users
    And the edited delegation is saved with its current information

  @javascript @personas
  Scenario: Removing access from a delegation
    Given I am Pius
    When I edit a delegation that has access to the current inventory pool
    And I remove access to the current inventory pool from this delegation
    And I save
    Then no orders can be created for this delegation in the current inventory pool

  @javascript @personas @browser
  Scenario: Persönliche Bestellung in Delegationsbestellung ändern in Bestellung
    Given I am Pius
    And I open an order
    When I pick a delegation instead of a user
    And I pick a contact person from the delegation
    And I confirm the user change
    Then the order shows the name of the user
    And the order shows the name of the contact person

  @javascript @personas
  Scenario: Delete delegation
    Given I am Gino
    And I navigate to the admin area
    And I am on the tab 'Users'
    When there is no order, hand over or contract for a delegation
    And that delegation has no access rights to any inventory pool
    Then I can delete that delegation

  #  ANZEIGE BACKEND

  @personas
  Scenario: Listing orders for a delegation
    Given I am Pius
    And there is an order for a delegation
    And I edit the order
    Then I see the delegation's name
    And I see the contact person

  @javascript @personas @browser
  Scenario: Definition of the contact person when creating an order
    Given I am Julie
    When I create an order for a delegation
    Then I am saved as contact person
    Given today corresponds to the start date of the order
    And I am Pius
    When I hand over the items ordered for this delegation to "Mina"
    Then "Mina" is the new contact person for this contract

  @personas
  Scenario: Showing me my own orders
    Given I am Pius
    And there is an order placed by me personally
    And I edit the order
    Then the order shows the name of the user
    And I don't see any contact person

  @javascript @personas
  Scenario: Changing the delegation during hand over
    Given I am Pius
    And there is a hand over for a delegation
    And I open this hand over
    When I change the delegation
    And I confirm the user change
    Then the hand over goes to the new delegation

  @javascript @personas
  Scenario: Which delegations are shown when changing during hand over
    Given I am Pius
    And I open a hand over
    When I try to change the delegation
    Then I can choose only those people that belong to the delegation group

  @javascript @personas @browser
  Scenario: Changing contact person during hand over
    Given I am Pius
    And there is a hand over for a delegation with assigned items
    And I open this hand over
    When I try to change the contact person
    Then I can choose only those people that belong to the delegation group

  @javascript @personas @browser
  Scenario: Changing contact person while editing an order
    Given I am Pius
    And I am editing a delegation's order
    When I try to change the order's contact person
    Then I can choose only those people as contact person for the order that belong to the delegation group

  @javascript @personas @browser
  Scenario: Borrow: Bestellung erfassen mit Delegation
    Given I am Julie
    When ich über meinen Namen fahre
    And I click on "Delegations"
    Then werden mir die Delegationen angezeigt, denen ich zugeteilt bin
    When ich eine Delegation wähle
    Then wechsle ich die Anmeldung zur Delegation
    Given man befindet sich auf der Modellliste
    When man auf einem verfügbaren Model "Zur Bestellung hinzufügen" wählt
    Then öffnet sich der Kalender
    When alle Angaben die ich im Kalender mache gültig sind
    Then lässt sich das Modell mit Start- und Enddatum, Anzahl und Gerätepark der Bestellung hinzugefügen
    When ich die Bestellübersicht öffne
    And ich einen Zweck eingebe
    And man merkt sich die Bestellung
    And ich die Bestellung abschliesse
    And ich refreshe die Bestellung
    Then ändert sich der Status der Bestellung auf Abgeschickt
    And die Delegation ist als Besteller gespeichert
    And ich werde als Kontaktperson hinterlegt

  @javascript @personas @browser
  Scenario: Delegation in Bestellungen ändern
    Given I am Pius
    And ich befinde mich in einer Bestellung
    When ich die Delegation wechsle
    And ich die Kontaktperson wechsle
    And ich bestätige den Benutzerwechsel
    Then lautet die Aushändigung auf diese neu gewählte Delegation
    And die neu gewählte Kontaktperson wird gespeichert

  @javascript @personas
  Scenario: Auswahl der Delegation in Bestellung ändern
    Given I am Pius
    And ich befinde mich in einer Bestellung
    When ich versuche die Delegation zu wechseln
    Then kann ich nur diejenigen Delegationen wählen, die Zugriff auf meinen Gerätepark haben

  @javascript @personas
  Scenario: Delegation wechseln - nur ein Kontaktpersonfeld
    Given I am Pius
    And ich befinde mich in einer Bestellung von einer Delegation
    When ich die Delegation wechsle
    Then sehe ich genau ein Kontaktpersonfeld

  @javascript @personas
  Scenario: Delegation wechseln - Kontaktperson ist ein Muss
    Given I am Pius
    And ich befinde mich in einer Bestellung
    When ich die Delegation wechsle
    And ich keine Kontaktperson angebe
    And ich den Benutzerwechsel bestätige
    Then sehe ich im Dialog die Fehlermeldung "Die Kontaktperson ist nicht Mitglied der Delegation oder ist leer"

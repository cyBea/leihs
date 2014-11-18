Feature: Retire

  @javascript @personas
  Scenario Outline: Retire
    Given I am Matti
    And I search for a <object> that is in stock and belongs to me
    Then I can retire this <object> if I give a reason for retiring
    And the newly retired <object> immediately disappears from the inventory list
    Examples:
      | object     |
      | item |
      | license     |

  @javascript @personas
  Scenario Outline: Preventing retiring an object that isn't in stock
    Given I am Mike
    And I search for a <object> that is not in stock
    Then I cannot retire such a <object>
    Examples:
      | object     |
      | item |
      | license     |

  @javascript @personas
  Scenario Outline: Verhinderung von Ausmusterung eines Objektes bei dem ich nicht als Besitzer eingetragen bin
    Given I am Matti
    And man sucht nach einem <Objekt> bei dem ich nicht als Besitzer eingetragen bin
    Then hat man keine Möglichkeit solchen <Objekt> auszumustern
    Examples:
      | Objekt     |
      | Gegenstand |
      | Lizenz     |

  @javascript @personas
  Scenario Outline: Fehlermeldung bei der Ausmusterung ohne angabe eines Grundes
    Given I am Matti
    And man sucht nach einem nicht ausgeliehenen <Objekt>, wo man der Besitzer ist
    And man gibt bei der Ausmusterung keinen Grund an
    And der <Objekt> ist noch nicht Ausgemustert
    Examples:
      | Objekt     |
      | Gegenstand |
      | Lizenz     |

  @javascript @personas
  Scenario Outline: Ausmusterung rückgangig machen
    Given I am Mike
    And man sucht nach einem ausgemusterten <Objekt>, wo man der Besitzer ist
    And man befindet sich auf der Editierseite von diesem <Objekt>
    When man die Ausmusterung bei diesem <Objekt> zurück setzt
    And die Anschaffungskategorie ist ausgewählt
    And I save
    Then wurde man auf die Inventarliste geleitet
    And dieses <Objekt> ist nicht mehr ausgemustert
    Examples:
      | Objekt     |
      | Gegenstand |
      | Lizenz     |

  @personas
  Scenario Outline: Ansichtseite von einem ausgemusterten Objekt für Verantwortlichen anzeigen
    Given I am Mike
    And man sucht nach einem ausgemusterten <Objekt>, wo man der Verantwortliche und nicht der Besitzer ist
    Then man befindet sich auf der Editierseite von diesem <Objekt>
    Examples:
      | Objekt     |
      | Gegenstand |
      | Lizenz     |

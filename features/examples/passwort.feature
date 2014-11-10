
Feature: Passwörter von Benutzern

  Als Ausleihe-Verwalter, Inventar-Verwalter oder Administrator,
  möchte ich eine Benutzer ein Login und Passwort zuteilen

  @personas
  Scenario Outline: Benutzer mit Benutzernamen und Passwort erstellen
    Given ich bin <Person>
    And man befindet sich auf der Benutzerliste
    When ich einen Benutzer mit Login "username" und Passwort "password" erstellt habe
    And der Benutzer hat Zugriff auf ein Inventarpool
    Then kann sich der Benutzer "username" mit "password" anmelden

    Examples:
      | Person |
      | Mike   |
      | Pius   |
      | Gino   |

  @personas
  Scenario Outline: Benutzernamen und Passwort ändern
    Given ich bin <Person>
    And man befindet sich auf der Benutzereditieransicht von "Normin"
    When ich den Benutzernamen auf "newnorminusername" und das Passwort auf "newnorminpassword" ändere
    And der Benutzer hat Zugriff auf ein Inventarpool
    Then kann sich der Benutzer "newnorminusername" mit "newnorminpassword" anmelden

    Examples:
      | Person |
      | Mike   |
      | Pius   |
      | Gino   |

  @personas
  Scenario Outline: Benutzer mit falscher Passwort-Bestätigung erstellen
    Given ich bin <Person>
    And man befindet sich auf der Benutzerliste
    When ich einen Benutzer mit falscher Passwort-Bestätigung erstellen probiere
    Then I see an error message

    Examples:
      | Person |
      | Mike   |
      | Pius   |
      | Gino   |

  @personas
  Scenario Outline: Benutzer mit fehlenden Passwortangaben editieren
    Given ich bin <Person>
    And man befindet sich auf der Benutzereditieransicht von "Normin"
    When ich die Passwort-Angaben nicht eingebe und speichere
    Then I see an error message

    Examples:
      | Person |
      | Mike   |
      | Pius   |
      | Gino   |

  @personas
  Scenario Outline: Benutzer ohne Loginnamen erstellen
    Given ich bin <Person>
    And man befindet sich auf der Benutzerliste
    When ich einen Benutzer ohne Loginnamen erstellen probiere
    Then I see an error message

    Examples:
      | Person |
      | Mike   |
      | Pius   |
      | Gino   |

  @personas
  Scenario Outline: Passwort ändern
    Given ich bin <Person>
    And man befindet sich auf der Benutzereditieransicht von "Normin"
    When ich das Passwort von "Normin" auf "newnorminpassword" ändere
    And der Benutzer hat Zugriff auf ein Inventarpool
    Then kann sich der Benutzer "normin" mit "newnorminpassword" anmelden

    Examples:
      | Person |
      | Mike   |
      | Pius   |
      | Gino   |

  @personas
  Scenario Outline: Benutzer mit fehlenden Passwortangaben erstellen
    Given ich bin <Person>
    And man befindet sich auf der Benutzerliste
    When ich einen Benutzer mit fehlenden Passwortangaben erstellen probiere
    Then I see an error message

    Examples:
      | Person |
      | Mike   |
      | Pius   |
      | Gino   |

  @personas
  Scenario Outline: Benutzer ohne Loginnamen editieren
    Given ich bin <Person>
    And man befindet sich auf der Benutzereditieransicht von "Normin"
    When ich den Benutzernamen von nicht ausfülle und speichere
    Then I see an error message

    Examples:
      | Person |
      | Mike   |
      | Pius   |
      | Gino   |

  @personas
  Scenario Outline: Benutzer mit falscher Passwort-Bestätigung editieren
    Given ich bin <Person>
    And man befindet sich auf der Benutzereditieransicht von "Normin"
    When ich eine falsche Passwort-Bestägigung eingebe und speichere
    Then I see an error message

    Examples:
      | Person |
      | Mike   |
      | Pius   |
      | Gino   |

  @personas
  Scenario Outline: Benutzernamen ändern
    Given ich bin <Person>
    And man befindet sich auf der Benutzereditieransicht von "Normin"
    When ich den Benutzernamen von "Normin" auf "username" ändere
    And der Benutzer hat Zugriff auf ein Inventarpool
    Then kann sich der Benutzer "username" mit "password" anmelden

    Examples:
      | Person |
      | Mike   |
      | Pius   |
      | Gino   |

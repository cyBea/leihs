Feature: Manage users

  @javascript @personas
  Scenario Outline: Suspend feature for users and delegations
    Given I am inventory manager or lending manager
    And I edit a <user_type>
    When I use the suspend feature
    Then I have to specify a reason for suspension
    And if the <user_type> is suspended, I can remove the suspension
    Examples:
      | user_type |
      | user      |
      | delegation|

  @upcoming @personas
  Scenario: Elements of the edit view
    Given I am inventory manager or lending manager
    And I edit a user
    Then the user's first and last name are used as a title
    And I see the suspend button for this user
    And I see reason and duration of suspension for this user, if they are suspended
    Then I see the following information about the user, in order:
    |en         |de           |
    |Last name  |Name         |
    |First name |Vorname      |
    |Address    |Strasse      |
    |Zip        |PLZ          |
    |City       |Ort          |
    |Country    |Land         |
    |Phone      |Telefonnummer|
    |E-Mail     |E-Mail-Adresse|
    And I can change this user's information, as long as they use local database authentication and not another adapter
    And I cannot change this user's information if they use something other than local database authentication
    And I see the user's role and can change them depending on my own role
    And my changes are saved if I save the user

  @personas
  Scenario: Give admin rights to another user (as administrator)
    Given I am Gino
    And I am editing a user that has no access rights and is not an admin
    When I assign the admin role to this user
    And I save
    Then I see a confirmation of success on list of users
    And this user has the admin role
    And all their previous access rights remain intact

  @personas
  Scenario: Remove admin rights from a user, as administrator
    Given I am Gino
    And I am editing a user who has the admin role and access to inventory pools
    When I remove the admin role from this user
    And I save
    Then this user no longer has the admin role
    And all their previous access rights remain intact

  @personas
  Scenario Outline: As lending or inventory manager I can't access the admin area
    Given I am <person>
    When I try to access the admin area's user editing page
    Then I can't access that page
    When I try to access the admin area's user creation page
    Then I can't access that page
    Examples:
      | person |
      | Pius   |
      | Mike   |

  @javascript @personas
  Scenario: Add new user as inventory manager to an inventory pool
    Given I am Pius
    When I am looking at the user list
    And I add a new user
    And I enter the following information
      | First name       |
      | Last name        |
      | E-Mail         |
    And I enter the login data
    And I enter a badge ID
    And I can only choose the following roles
      | No access |
      | Customer  |
      | Group manager  |
      | Lending manager  |
    When I choose one of the following roles
      | tab                | role              |
      | Customer              | customer          |
      | Group manager | group_manager   |
      | Lending manager | lending_manager   |
    And I assign multiple groups
    And I save
    Then the user and all their information is saved

  @personas
  Scenario: Add a new user as an administrator, from outside the inventory pool
    Given I am Gino
    And I am looking at the user list outside an inventory pool
    When I navigate from here to the user creation page
    And I enter the following information
      | First name       |
      | Last name        |
      | E-Mail         |
    And I enter the login data
    And I save
    Then I am redirected to the user list outside an inventory pool
    And I receive a notification
    And the new user has been created
    And he does not have access to any inventory pools and is not an administrator

  @personas
  Scenario: Auflistung der Inventarpools eines Benutzers
    Given I am Ramon
    And I am looking at the user list outside an inventory pool
    And I edit a user that has access rights
    Then inventory pools they have access to are listed with the respective role

  @javascript @browser @personas
  Scenario: Requirements for deleting a user in an inventory pool
    Given I am Ramon
    And I pick one user with access rights, one with orders and one with contracts
    And I am looking at the user list in any inventory pool
    When I delete that user from the list
    Then I see an error message
    And the user is not deleted

  @personas
  Scenario: Alphabetic sort order of users outside an inventory pool
    Given I am Gino
    And I am looking at the user list outside an inventory pool
    # What's here? We need to confirm that A comes before B in the list

  @personas
  Scenario: Remove access as an inventory manager
    Given I am Pius
    And I am editing a user who has access to and no items from the current inventory pool
    When I remove their access
    And I save
    Then the user has no access to the inventory pool

  @javascript @personas
  Scenario: Delete user from an inventory pool as admin
    Given I am Gino
    And I pick a user without access rights, orders or contracts
    And I am looking at the user list in any inventory pool
    When I delete that user from the list
    Then that user has been deleted from the list
    And the user is deleted

  @personas
  Scenario: Remove access as an administrator
    Given I am Gino
    And I am editing a user who has access to and no items from the current inventory pool
    When I remove their access
    And I save
    Then the user has no access to the inventory pool

  # This feature has been removed, no point in translating
  @personas
  Scenario: Startseite setzen
    Given I am Pius
    And man befindet sich auf der Liste der Benutzer
    When man die Startseite setzt
    Then ist die Liste der Benutzer die Startseite

  @javascript @personas @browser
  Scenario: Elements of user administration
    Given I am inventory manager or lending manager
    Then I can find the user administration features in the "Admin" area under "Users"
    Then I see a list of all users
    And I can filter to see only suspended users
    And I can filter by the following roles:
      | tab                | role               |
      | Customer              | customers          |
      | Lending manager | lending_managers   |
      | Inventory manager | inventory_managers |
    And I can open the edit view for each user

  @javascript @personas
  Scenario: Displaying a user and their roles in lists
    Given I am inventory manager or lending manager
    And a user with assigned role appears in the user list
    Then sieht man folgende Informationen in folgender Reihenfolge:
      |attr |
      |Vorname Name|
      |Telefonnummer|
      |Rolle|

  @javascript @personas
  Scenario: Darstellung eines Benutzers in Listen ohne zugeteilte Rolle
    Given I am inventory manager or lending manager
    Given man ist Inventar-Verwalter oder Ausleihe-Verwalter
    And ein Benutzer ohne zugeteilte Rolle erscheint in einer Benutzerliste
    Then sieht man folgende Informationen in folgender Reihenfolge:
      |attr |
      |Vorname Name|
      |Telefonnummer|
      |Rolle|

  @javascript @personas
  Scenario: Darstellung eines Benutzers in Listen mit zugeteilter Rolle und Status gesperrt
    Given I am inventory manager or lending manager
    And ein gesperrter Benutzer mit zugeteilter Rolle erscheint in einer Benutzerliste
    Then sieht man folgende Informationen in folgender Reihenfolge:
      |attr |
      |Vorname Name|
      |Telefonnummer|
      |Rolle|
      |Sperr-Status 'Gesperrt bis dd.mm.yyyy'|

  # English: lending manager
  @personas
  Scenario: Benutzerolle "Ausleihe-Verwalter"
    Given man ist Ausleihe-Verwalter
    When man im Inventar Bereich ist
    Then kann man neue Gegenstände erstellen
    And diese Gegenstände ausschliesslich nicht inventarrelevant sind
    And man kann Optionen erstellen
    And man kann neue Benutzer erstellen und für die Ausleihe sperren
    And man kann nicht inventarrelevante Gegenstände ausmustern, sofern man deren Besitzer ist

  # English: inventory manager
  @personas
  Scenario: Benutzerolle "Inventar-Verwalter"
    Given man ist Inventar-Verwalter
    Then kann man neue Modelle erstellen
    And kann man neue Gegenstände erstellen
    And diese Gegenstände können inventarrelevant sein
    And man kann sie einem anderen Gerätepark als Besitzer zuweisen
    And man kann Gegenstände ausmustern, sofern man deren Besitzer ist
    And man kann Ausmusterungen wieder zurücknehmen, sofern man Besitzer der jeweiligen Gegenstände ist
    And man kann die Arbeitstage und Ferientage seines Geräteparks anpassen
    And man kann Benutzern die folgende Rollen zuweisen und wegnehmen, wobei diese immer auf den Gerätepark bezogen ist, für den auch der Verwalter berechtigt ist
    | role                |
    | Kein Zugriff        |
    | Kunde               |
    | Gruppen-Verwalter   |
    | Ausleihe-Verwalter  |
    | Inventar-Verwalter  |
    And man kann alles, was ein Ausleihe-Verwalter kann
    When man keine verantwortliche Abteilung auswählt
    Then ist die Verantwortliche Abteilung gleich wie der Besitzer

  @personas
  Scenario: Zugriff entfernen als Inventar-Verwalter
    Given I am Mike
    And man editiert einen Benutzer der Zugriff auf das aktuelle Inventarpool hat und keine Gegenstände hat
    When man den Zugriff entfernt
    And I save
    Then hat der Benutzer keinen Zugriff auf das Inventarpool

  @personas
  Scenario Outline: Zugriff entfernen für einen Benutzer mit offenen Vertrag
    Given I am <Persona>
    And es existiert ein Vertrag mit Status "<Vertragsstatus>" für einen Benutzer mit sonst keinem anderen Verträgen
    When man den Benutzer für diesen Vertrag editiert
    Then hat dieser Benutzer Zugriff auf das aktuelle Inventarpool
    When man den Zugriff entfernt
    And I save
    Then erhalte ich die Fehlermeldung "<Fehlermeldung>"
    Examples:
      | Persona | Vertragsstatus | Fehlermeldung                          |
      | Mike    | abgeschickt    | Hat momentan offene Bestellungen       |
      | Pius    | abgeschickt    | Hat momentan offene Bestellungen       |
      | Mike    | genehmigt      | Hat momentan offene Bestellungen       |
      | Pius    | genehmigt      | Hat momentan offene Bestellungen       |
      | Mike    | unterschrieben | Hat momentan Gegenstände zurückzugeben |
      | Pius    | unterschrieben | Hat momentan Gegenstände zurückzugeben |

   @upcoming
  Scenario: Gruppenzuteilung in Benutzeransicht hinzufügen/entfernen
    Given I am Pius
    And man editiert einen Benutzer
    Then kann man Gruppen über eine Autocomplete-Liste hinzufügen
    And kann Gruppen entfernen
    And speichert den Benutzer
    Then ist die Gruppenzugehörigkeit gespeichert 

  @javascript @personas
  Scenario: Neuen Benutzer im Geräterpark als Inventar-Verwalter hinzufügen
    Given I am Mike
    When I am looking at the user list
    And man einen Benutzer hinzufügt
    And die folgenden Informationen eingibt
      | Nachname       |
      | Vorname        |
      | Adresse        |
      | PLZ            |
      | Ort            |
      | Land           |
      | Telefon        |
      | E-Mail         |
    And man gibt die Login-Daten ein
    And man gibt eine Badge-Id ein
    And man hat nur die folgenden Rollen zur Auswahl
      | No access          |
      | Customer           |
      | Group manager      |
      | Lending manager    |
      | Inventory manager  |
    And eine der folgenden Rollen auswählt
    | tab                | role                |
    | Kunde              | customer            |
    | Gruppen-Verwalter  | group_manager       |
    | Ausleihe-Verwalter | lending_manager     |
    | Inventar-Verwalter | inventory_manager   |
    And man teilt mehrere Gruppen zu
    And I save
    Then ist der Benutzer mit all den Informationen gespeichert

  @personas
  Scenario: Zugriff auf Ausleihe-Verwalter ändern als Ausleihe-Verwalter
    Given I am Pius
    And man editiert einen Benutzer der Kunde ist
    Then man hat nur die folgenden Rollen zur Auswahl
      | No access          |
      | Customer           |
      | Group manager      |
      | Lending manager    |
    When man den Zugriff auf "Ausleihe-Verwalter" ändert
    And I save
    Then hat der Benutzer die Rolle Ausleihe-Verwalter

  @personas
  Scenario: Zugriff auf Kunde ändern als Ausleihe-Verwalter
    Given I am Pius
    And man editiert einen Benutzer der Ausleihe-Verwalter ist
    When man den Zugriff auf "Kunde" ändert
    And I save
    Then hat der Benutzer die Rolle Kunde

  @personas
  Scenario: Zugriff ändern als Inventar-Verwalter
    Given I am Mike
    And man editiert einen Benutzer der Kunde ist
    Then man hat nur die folgenden Rollen zur Auswahl
      | No access          |
      | Customer           |
      | Group manager      |
      | Lending manager    |
      | Inventory manager  |
    When man den Zugriff auf "Inventar-Verwalter" ändert
    And I save
    Then hat der Benutzer die Rolle Inventar-Verwalter

  @personas
  Scenario: Zugriff auf ein Inventarpool gewährleisten als Inventar-Verwalter
    Given I am Mike
    And man editiert einen Benutzer der kein Zugriff auf das aktuelle Inventarpool hat
    When man den Zugriff auf "Kunde" ändert
    And I save
    Then I see a confirmation of success on list of users
    And hat der Benutzer die Rolle Kunde

  @personas
  Scenario: Zugriff ändern als Administrator
    Given I am Gino
    And man editiert in irgendeinem Inventarpool einen Benutzer der Kunde ist
    Then man hat nur die folgenden Rollen zur Auswahl
      | No access          |
      | Customer           |
      | Group manager      |
      | Lending manager    |
      | Inventory manager  |
    When man den Zugriff auf "Inventar-Verwalter" ändert
    And I save
    Then hat der Benutzer die Rolle Inventar-Verwalter

  @javascript @browser @personas
  Scenario: Voraussetzungen fürs Löschen eines Benutzers
    Given I am Ramon
    And man befindet sich auf der Benutzerliste ausserhalb der Inventarpools
    And man sucht sich je einen Benutzer mit Zugriffsrechten, Bestellungen und Verträgen aus
    When ich diesen Benutzer aus der Liste lösche
    Then I see an error message
    And der Benutzer ist nicht gelöscht

  @javascript @personas
  Scenario: Alphabetische Sortierung der Benutzer innerhalb vom Inventarpool
    Given I am Gino
    And man befindet sich auf der Benutzerliste im beliebigen Inventarpool
    Then sind die Benutzer nach ihrem Vornamen alphabetisch sortiert

  @personas
  Scenario: Benutzer ohne Zugriff im Inventarpool editieren ohne ihm dabei Zugriff zu gewährleisten
    Given I am Pius
    And man editiert einen Benutzer der kein Zugriff auf das aktuelle Inventarpool hat
    When man ändert die Email
    And I save
    Then I see a confirmation of success on list of users
    And die neue Email des Benutzers wurde gespeichert
    And der Benutzer hat nach wie vor keinen Zugriff auf das aktuelle Inventarpool

  @javascript @personas
  Scenario: Add new user to the inventory pool as administrator
    Given I am Gino
    When I am looking at the user list
    And I add a new user
    And I enter the following information
      | Last name      |
      | First name     |
      | E-Mail         |
    And I enter the login data
    And I enter a badge ID
    Then I can only choose the following roles
      | No access          |
      | Customer           |
      | Group manager      |
      | Lending manager    |
      | Inventory manager  |
    When I choose one of the following roles
      | tab                | role                |
      | Customer              | customer            |
      | Group manager  | group_manager       |
      | Lending manager| lending_manager     |
      | Inventory manager| inventory_manager   |
    And I assign multiple groups
    And I save
    Then the user and all their information is saved

  @personas
  Scenario Outline: Neuen Benutzer hinzufügen - ohne Eingabe der Pflichtfelder
    Given I am Pius
    When I am looking at the user list
    And I add a new user
    And alle Pflichtfelder sind sichtbar und abgefüllt
    When man ein <Pflichtfeld> nicht eingegeben hat
    And I save
    Then I see an error message
    Examples:
      | Pflichtfeld |
      | Nachname    |
      | Vorname     |
      | E-Mail      |

  @personas
  Scenario: Benutzer den Zugriff auf ein Inventarpool reaktivieren
    Given I am Mike
    And man editiert einen Benutzer der mal einen Zugriff auf das aktuelle Inventarpool hatte
    When man den Zugriff auf "Kunde" ändert
    And I save
    Then I see a confirmation of success on list of users
    And hat der Benutzer die Rolle Kunde


  @javascript @personas
  Scenario: Benutzer als Administrator löschen
    Given I am Gino
    And man befindet sich auf der Benutzerliste ausserhalb der Inventarpools
    And man sucht sich einen Benutzer ohne Zugriffsrechte, Bestellungen und Verträge aus
    When ich diesen Benutzer aus der Liste lösche
    Then wurde der Benutzer aus der Liste gelöscht
    And der Benutzer ist gelöscht

  # Unimplemented, so not translated.
  @personas
  Scenario: Startseite zurücksetzen
    Given I am Pius
    And man hat eine Startseite gesetzt
    When man seine Startseite zurücksetzt
    Then ist ist keine Startseite gesetzt
    When man auf das Logo klickt
    Then landet man auf der Tagesansicht als Standard-Startseite

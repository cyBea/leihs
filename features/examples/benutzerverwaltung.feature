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
  Scenario: Elemente der Editieransicht
    Given man ist Inventar-Verwalter oder Ausleihe-Verwalter
    And man editiert einen Benutzer
    Then sieht man als Titel den Vornamen und Namen des Benutzers, sofern bereits vorhanden
    Then sieht man die folgenden Daten des Benutzers in der folgenden Reihenfolge:
    Then sieht man die Sperrfunktion für diesen Benutzer
    And sofern dieser Benutzer gesperrt ist, sieht man Grund und Dauer der Sperrung
    Then sieht man die folgenden Daten des Benutzers in der folgenden Reihenfolge:
    |en         |de           |
    |Last name  |Name         |
    |First name |Vorname      |
    |Address    |Strasse      |
    |Zip        |PLZ          |
    |City       |Ort          |
    |Country    |Land         |
    |Phone      |Telefonnummer|
    |E-Mail     |E-Mail-Adresse|
    And man kann die Informationen ändern, sofern es sich um einen externen Benutzer handelt
    And man kann die Informationen nicht verändern, sofern es sich um einen Benutzer handelt, der über ein externes Authentifizierungssystem eingerichtet wurde
    And man sieht die Rollen des Benutzers und kann diese entsprechend seiner Rolle verändern
    And man kann die vorgenommenen Änderungen abspeichern

  @personas
  Scenario: Als Administrator einen anderen Benutzer Administrator machen
    Given I am Gino
    And man befindet sich auf der Editierseite eines Benutzers, der kein Administrator ist und der Zugriffe auf Inventarpools hat
    When man diesen Benutzer die Rolle Administrator zuweist
    And ich speichere
    Then sieht man die Erfolgsbestätigung
    And hat dieser Benutzer die Rolle Administrator
    And alle andere Zugriffe auf Inventarpools bleiben beibehalten

  @personas
  Scenario: Als Administrator einem anderen Benutzer die Rolle Administrator wegnehmen
    Given I am Gino
    And man befindet sich auf der Editierseite eines Benutzers, der ein Administrator ist und der Zugriffe auf Inventarpools hat
    When man diesem Benutzer die Rolle Administrator wegnimmt
    And ich speichere
    Then hat dieser Benutzer die Rolle Administrator nicht mehr
    And alle andere Zugriffe auf Inventarpools bleiben beibehalten

  @personas
  Scenario Outline: Als Ausleihe- oder Inventar-Verwalter hat man kein Zugriff auf die Administrator-User-Pfade
    Given I am <Person>
    When man versucht auf die Administrator Benutzererstellenansicht zu gehen
    Then gelangt man auf diese Seite nicht
    When man versucht auf die Administrator Benutzereditieransicht zu gehen
    Then gelangt man auf diese Seite nicht
    Examples:
      | Person |
      | Pius   |
      | Mike   |

  @javascript @personas
  Scenario: Neuen Benutzer im Geräterpark als Ausleihe-Verwalter hinzufügen
    Given I am Pius
    When man in der Benutzeransicht ist
    And man einen Benutzer hinzufügt
    And die folgenden Informationen eingibt
      | Nachname       |
      | Vorname        |
      | E-Mail         |
    And man gibt die Login-Daten ein
    And man gibt eine Badge-Id ein
    And man hat nur die folgenden Rollen zur Auswahl
      | No access |
      | Customer  |
      | Group manager  |
      | Lending manager  |
    And eine der folgenden Rollen auswählt
      | tab                | role              |
      | Kunde              | customer          |
      | Gruppen-Verwalter  | group_manager   |
      | Ausleihe-Verwalter | lending_manager   |
    And man teilt mehrere Gruppen zu
    And ich speichere
    Then ist der Benutzer mit all den Informationen gespeichert

  @personas
  Scenario: Als Administrator neuen Benutzer erstellen
    Given I am Gino
    And man befindet sich auf der Benutzerliste ausserhalb der Inventarpools
    When man von hier auf die Benutzererstellungsseite geht
    And den Nachnamen eingibt
    And den Vornahmen eingibt
    And die Email-Addresse eingibt
    And man gibt die Login-Daten ein
    And ich speichere
    Then wird man auf die Benutzerliste ausserhalb der Inventarpools umgeleitet
    And man sieht eine Bestätigungsmeldung
    And der neue Benutzer wurde erstellt
    And er hat keine Zugriffe auf Inventarpools und ist kein Administrator

  @personas
  Scenario: Auflistung der Inventarpools eines Benutzers
    Given I am Ramon
    And man befindet sich auf der Benutzerliste ausserhalb der Inventarpools
    And man einen Benutzer mit Zugriffsrechten editiert
    Then werden die ihm zugeteilt Geräteparks mit entsprechender Rolle aufgelistet

  @javascript @browser @personas
  Scenario: Voraussetzungen fürs Löschen eines Benutzers im Gerätepark
    Given I am Ramon
    And man sucht sich je einen Benutzer mit Zugriffsrechten, Bestellungen und Verträgen aus
    And man befindet sich auf der Benutzerliste im beliebigen Inventarpool
    When ich diesen Benutzer aus der Liste lösche
    Then I see an error message
    And der Benutzer ist nicht gelöscht

  @personas
  Scenario: Alphabetische Sortierung der Benutzer ausserhalb vom Inventarpool
    Given I am Gino
    And man befindet sich auf der Benutzerliste ausserhalb der Inventarpools

  @personas
  Scenario: Zugriff entfernen als Ausleihe-Verwalter
    Given I am Pius
    And man editiert einen Benutzer der Zugriff auf das aktuelle Inventarpool hat und keine Gegenstände hat
    When man den Zugriff entfernt
    And ich speichere
    Then hat der Benutzer keinen Zugriff auf das Inventarpool

  @javascript @personas
  Scenario: Benutzer im Geräterpark als Administrator löschen
    Given I am Gino
    And man sucht sich einen Benutzer ohne Zugriffsrechte, Bestellungen und Verträge aus
    And man befindet sich auf der Benutzerliste im beliebigen Inventarpool
    When ich diesen Benutzer aus der Liste lösche
    Then wurde der Benutzer aus der Liste gelöscht
    And der Benutzer ist gelöscht

  @personas
  Scenario: Zugriff entfernen als Administrator
    Given I am Gino
    And man editiert einen Benutzer der Zugriff auf ein Inventarpool hat und keine Gegenstände hat
    When man den Zugriff entfernt
    And ich speichere
    Then hat der Benutzer keinen Zugriff auf das Inventarpool

  @personas
  Scenario: Startseite setzen
    Given I am Pius
    And man befindet sich auf der Liste der Benutzer
    When man die Startseite setzt
    Then ist die Liste der Benutzer die Startseite

  @javascript @personas @browser
  Scenario: Elemente der Benutzeradministration
    Given man ist Inventar-Verwalter oder Ausleihe-Verwalter
    Then findet man die Benutzeradministration im Bereich "Administration" unter "Benutzer"
    Then sieht man eine Liste aller Benutzer
    And man kann filtern nach den folgenden Eigenschaften: gesperrt
    And man kann filtern nach den folgenden Rollen:
      | tab                | role               |
      | Kunde              | customers          |
      | Ausleihe-Verwalter | lending_managers   |
      | Inventar-Verwalter | inventory_managers |
    And man kann für jeden Benutzer die Editieransicht aufrufen

  @javascript @personas
  Scenario: Darstellung eines Benutzers in Listen mit zugeteilter Rolle
    Given man ist Inventar-Verwalter oder Ausleihe-Verwalter
    And ein Benutzer mit zugeteilter Rolle erscheint in einer Benutzerliste
    Then sieht man folgende Informationen in folgender Reihenfolge:
      |attr |
      |Vorname Name|
      |Telefonnummer|
      |Rolle|

  @javascript @personas
  Scenario: Darstellung eines Benutzers in Listen ohne zugeteilte Rolle
    Given man ist Inventar-Verwalter oder Ausleihe-Verwalter
    And ein Benutzer ohne zugeteilte Rolle erscheint in einer Benutzerliste
    Then sieht man folgende Informationen in folgender Reihenfolge:
      |attr |
      |Vorname Name|
      |Telefonnummer|
      |Rolle|

  @javascript @personas
  Scenario: Darstellung eines Benutzers in Listen mit zugeteilter Rolle und Status gesperrt
    Given man ist Inventar-Verwalter oder Ausleihe-Verwalter
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
    And ich speichere
    Then hat der Benutzer keinen Zugriff auf das Inventarpool

  @personas
  Scenario Outline: Zugriff entfernen für einen Benutzer mit offenen Vertrag
    Given I am <Persona>
    And es existiert ein Vertrag mit Status "<Vertragsstatus>" für einen Benutzer mit sonst keinem anderen Verträgen
    When man den Benutzer für diesen Vertrag editiert
    Then hat dieser Benutzer Zugriff auf das aktuelle Inventarpool
    When man den Zugriff entfernt
    And ich speichere
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
    When man in der Benutzeransicht ist
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
    And ich speichere
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
    And ich speichere
    Then hat der Benutzer die Rolle Ausleihe-Verwalter

  @personas
  Scenario: Zugriff auf Kunde ändern als Ausleihe-Verwalter
    Given I am Pius
    And man editiert einen Benutzer der Ausleihe-Verwalter ist
    When man den Zugriff auf "Kunde" ändert
    And ich speichere
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
    And ich speichere
    Then hat der Benutzer die Rolle Inventar-Verwalter

  @personas
  Scenario: Zugriff auf ein Inventarpool gewährleisten als Inventar-Verwalter
    Given I am Mike
    And man editiert einen Benutzer der kein Zugriff auf das aktuelle Inventarpool hat
    When man den Zugriff auf "Kunde" ändert
    And ich speichere
    Then sieht man die Erfolgsbestätigung
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
    And ich speichere
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
    And ich speichere
    Then sieht man die Erfolgsbestätigung
    And die neue Email des Benutzers wurde gespeichert
    And der Benutzer hat nach wie vor keinen Zugriff auf das aktuelle Inventarpool

  @javascript @personas
  Scenario: Neuen Benutzer im Geräterpark als Administrator hinzufügen
    Given I am Gino
    When man in der Benutzeransicht ist
    And man einen Benutzer hinzufügt
    And die folgenden Informationen eingibt
      | Nachname       |
      | Vorname        |
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
    And ich speichere
    Then ist der Benutzer mit all den Informationen gespeichert

  @personas
  Scenario Outline: Neuen Benutzer hinzufügen - ohne Eingabe der Pflichtfelder
    Given I am Pius
    When man in der Benutzeransicht ist
    And man einen Benutzer hinzufügt
    And alle Pflichtfelder sind sichtbar und abgefüllt
    When man ein <Pflichtfeld> nicht eingegeben hat
    And ich speichere
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
    And ich speichere
    Then sieht man die Erfolgsbestätigung
    And hat der Benutzer die Rolle Kunde

  @javascript @personas
  Scenario: Benutzer als Administrator löschen
    Given I am Gino
    And man befindet sich auf der Benutzerliste ausserhalb der Inventarpools
    And man sucht sich einen Benutzer ohne Zugriffsrechte, Bestellungen und Verträge aus
    When ich diesen Benutzer aus der Liste lösche
    Then wurde der Benutzer aus der Liste gelöscht
    And der Benutzer ist gelöscht

  @personas
  Scenario: Startseite zurücksetzen
    Given I am Pius
    And man hat eine Startseite gesetzt
    When man seine Startseite zurücksetzt
    Then ist ist keine Startseite gesetzt
    When man auf das Logo klickt
    Then landet man auf der Tagesansicht als Standard-Startseite

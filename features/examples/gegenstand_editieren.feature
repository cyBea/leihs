
Feature: Gegenstand bearbeiten

  Grundlage:
    Given I am Matti

  @javascript @personas
  Scenario: Reihenfolge der Felder
    Given man editiert einen Gegenstand, wo man der Besitzer ist
    When I select "Ja" from "item[retired]"
    When I choose "Investition"
    Then sehe ich die Felder in folgender Reihenfolge:
      | Inventarcode                 |
      | Modell                       |
      | - Zustand -                  |
      | Ausmusterung                 |
      | Grund der Ausmusterung       |
      | Zustand                      |
      | Vollständigkeit              |
      | Ausleihbar                   |
      | - Inventar -                 |
      | Inventarrelevant             |
      | Anschaffungskategorie        |
      | Besitzer                     |
      | Letzte Inventur              |
      | Verantwortliche Abteilung    |
      | Verantwortliche Person       |
      | Benutzer/Verwendung          |
      | - Umzug -                    |
      | Umzug                        |
      | Zielraum                     |
      | - Toni Ankunftskontrolle -   |
      | Ankunftsdatum                |
      | Ankunftszustand              |
      | Ankunftsnotiz                |
      | - Allgemeine Informationen - |
      | Seriennummer                 |
      | MAC-Adresse                  |
      | IMEI-Nummer                  |
      | Name                         |
      | Notiz                        |
      | - Ort -                      |
      | Gebäude                      |
      | Raum                         |
      | Gestell                      |
      | - Rechnungsinformationen -   |
      | Bezug                        |
      | Projektnummer                |
      | Rechnungsnummer              |
      | Rechnungsdatum               |
      | Anschaffungswert             |
      | Lieferant                    |
      | Garantieablaufdatum          |
      | Vertragsablaufdatum          |

  @javascript @personas
  Scenario: Lieferanten löschen
    Given man editiert einen Gegenstand, wo man der Besitzer ist
    Given man navigiert zur Bearbeitungsseite eines Gegenstandes mit gesetztem Lieferanten
    When ich den Lieferanten lösche
    And I save
    Then ist bei dem bearbeiteten Gegenstand keiner Lieferant eingetragen

  @javascript @personas @browser
  Scenario: Einen Gegenstand mit allen Informationen editieren
    Given man editiert einen Gegenstand, wo man der Besitzer ist, der am Lager und in keinem Vertrag vorhanden ist
    When ich die folgenden Informationen erfasse
      | Feldname               | Type         | Wert                |

      | Inventarcode           |              | Test Inventory Code |
      | Modell                 | autocomplete | Sharp Beamer 456    |

      | Ausmusterung           | select       | Ja                  |
      | Grund der Ausmusterung |              | Ja                  |
      | Zustand                | radio        | OK                  |
      | Vollständigkeit        | radio        | OK                  |
      | Ausleihbar             | radio        | OK                  |

      | Inventarrelevant       | select       | Ja                  |
      | Anschaffungskategorie  | select       | Werkstatt-Technik   |

    And I save
    Then man wird zur Liste des Inventars zurueckgefuehrt
    And ist der Gegenstand mit all den angegebenen Informationen gespeichert

  @javascript @personas
  Scenario: Ein Modell ohne Version für den Gegestand wählen
    Given man editiert einen Gegenstand, wo man der Besitzer ist
    And there is a model without a version
    When I assign this model to the item
    Then there is only product name in the input field of the model

  @javascript @personas
  Scenario: Lieferanten ändern
    Given man editiert einen Gegenstand, wo man der Besitzer ist
    When ich den Lieferanten ändere
    And I save
    Then ist bei dem bearbeiteten Gegestand der geänderte Lieferant eingetragen

  @javascript @personas
  Scenario: Bei ausgeliehenen Gegenständen kann man die verantwortliche Abteilung nicht editieren
    Given man navigiert zur Bearbeitungsseite eines Gegenstandes, der ausgeliehen ist und wo man Besitzer ist
    When ich die verantwortliche Abteilung ändere
    And I save
    Then erhält man eine Fehlermeldung, dass man diese Eigenschaft nicht editieren kann, da das Gerät ausgeliehen ist

  @javascript @personas @browser
  Scenario: Einen Gegenstand mit allen Informationen editieren
    Given man editiert einen Gegenstand, wo man der Besitzer ist, der am Lager und in keinem Vertrag vorhanden ist
    When ich die folgenden Informationen erfasse
      | Feldname              | Type         | Wert                |

      | Inventarcode          |              | Test Inventory Code |
      | Modell                | autocomplete | Sharp Beamer 456    |

      | Inventarrelevant      | select       | Ja                  |
      | Anschaffungskategorie | select       | Werkstatt-Technik   |

      | Umzug                 | select       | sofort entsorgen    |
      | Zielraum              |              | Test Raum           |

      | Ankunftsdatum         |              | 01.01.2013          |
      | Ankunftszustand       | select       | transportschaden    |
      | Ankunftsnotiz         |              | Test Notiz          |

      | Seriennummer          |              | Test Seriennummer   |
      | MAC-Adresse           |              | Test MAC-Adresse    |
      | IMEI-Nummer           |              | Test IMEI-Nummer    |
      | Name                  |              | Test Name           |
      | Notiz                 |              | Test Notiz          |

      | Gebäude               | autocomplete | Keine/r             |
      | Raum                  |              | Test Raum           |
      | Gestell               |              | Test Gestell        |

    And I save
    Then man wird zur Liste des Inventars zurueckgefuehrt
    And ist der Gegenstand mit all den angegebenen Informationen gespeichert

  @javascript @personas
  Scenario: Pflichtfelder
    Given man editiert einen Gegenstand, wo man der Besitzer ist
    Then muss der "Bezug" unter "Rechnungsinformationen" ausgewählt werden
    When "Investition" bei "Bezug" ausgewählt ist muss auch "Projektnummer" angegeben werden
    When "Ja" bei "Inventarrelevant" ausgewählt ist muss auch "Anschaffungskategorie" ausgewählt werden
    When "Ja" bei "Ausmusterung" ausgewählt ist muss auch "Grund der Ausmusterung" angegeben werden
    Then sind alle Pflichtfelder mit einem Stern gekenzeichnet
    When ein Pflichtfeld nicht ausgefüllt/ausgewählt ist, dann lässt sich der Gegenstand nicht speichern
    And I see an error message
    And die nicht ausgefüllten/ausgewählten Pflichtfelder sind rot markiert

  @javascript @personas
  Scenario: Neuen Lieferanten erstellen falls nicht vorhanden
    Given man editiert einen Gegenstand, wo man der Besitzer ist
    When ich einen nicht existierenen Lieferanten angebe
    And I save
    Then wird der neue Lieferant erstellt
    And bei dem bearbeiteten Gegestand ist der neue Lieferant eingetragen

  @javascript @personas
  Scenario: Neuen Lieferanten nicht erstellen falls einer mit gleichem Namen schon vorhanden
    Given man editiert einen Gegenstand, wo man der Besitzer ist
    When ich einen existierenen Lieferanten angebe
    And I save
    Then wird kein neuer Lieferant erstellt
    And bei dem bearbeiteten Gegestand ist der bereits vorhandenen Lieferant eingetragen
  

  @javascript @personas
  Scenario: Bei Gegenständen, die in Verträgen vorhanden sind, kann man das Modell nicht ändern
    Given man navigiert zur Bearbeitungsseite eines Gegenstandes, der in einem Vertrag vorhanden ist
    When ich das Modell ändere
    And I save
    Then erhält man eine Fehlermeldung, dass man diese Eigenschaft nicht editieren kann, da das Gerät in einem Vortrag vorhanden ist

  @javascript @personas
  Scenario: Einen Gegenstand, der ausgeliehen ist, kann man nicht ausmustern
    Given man navigiert zur Bearbeitungsseite eines Gegenstandes, der ausgeliehen ist und wo man Besitzer ist
    When ich den Gegenstand ausmustere
    And I save
    Then erhält man eine Fehlermeldung, dass man den Gegenstand nicht ausmustern kann, da das Gerät bereits ausgeliehen oder einer Vertragslinie zugewiesen ist

  @javascript @personas @browser
  Scenario: Einen Gegenstand mit allen Informationen editieren
    Given man editiert einen Gegenstand, wo man der Besitzer ist, der am Lager und in keinem Vertrag vorhanden ist
    When ich die folgenden Informationen erfasse
      | Feldname              | Type         | Wert                |

      | Inventarcode          |              | Test Inventory Code |
      | Modell                | autocomplete | Sharp Beamer 456    |

      | Inventarrelevant      | select       | Ja                  |
      | Anschaffungskategorie | select       | Werkstatt-Technik   |

      | Bezug                 | radio must   | Investition         |
      | Projektnummer         |              | Test Nummer         |
      | Rechnungsnummer       |              | Test Nummer         |
      | Rechnungsdatum        |              | 01.01.2013          |
      | Anschaffungswert      |              | 50.00               |
      | Garantieablaufdatum   |              | 01.01.2013          |
      | Vertragsablaufdatum   |              | 01.01.2013          |

    And I save
    Then man wird zur Liste des Inventars zurueckgefuehrt
    And ist der Gegenstand mit all den angegebenen Informationen gespeichert

  @javascript @personas @browser
  Scenario: Einen Gegenstand mit allen Informationen editieren
    Given man editiert einen Gegenstand, wo man der Besitzer ist, der am Lager und in keinem Vertrag vorhanden ist
    When ich die folgenden Informationen erfasse
      | Feldname                  | Type         | Wert                |

      | Inventarcode              |              | Test Inventory Code |
      | Modell                    | autocomplete | Sharp Beamer 456    |

      | Inventarrelevant          | select       | Ja                  |
      | Anschaffungskategorie     | select       | Werkstatt-Technik   |
      | Letzte Inventur           |              | 01.01.2013          |
      | Verantwortliche Abteilung | autocomplete | A-Ausleihe          |
      | Verantwortliche Person    |              | Matus Kmit          |
      | Benutzer/Verwendung       |              | Test Verwendung     |

    And I save
    Then man wird zur Liste des Inventars zurueckgefuehrt
    And ist der Gegenstand mit all den angegebenen Informationen gespeichert

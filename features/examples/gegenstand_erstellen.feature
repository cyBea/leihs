
Feature: Gegenstand erstellen

  @javascript @personas
  Scenario: Order of the fields when creating an item
    Given I am Matti
    And I edit an item
    # WHY are we retiring the item? Is it necessary so we can see an edit view?
    # TODO: Explain the rationale.
    # TODO: Remove web_steps.rb
    And I select "Yes" from "item[retired]"
    And I choose "Investment"
    Then I see form fields in the following order:
      | field                      |
      | Inventory Code             |
      | Model                      |
      | - Status -                 |
      | Retirement                 |
      | Reason for Retirement      |
      | Working order              |
      | Completeness               |
      | Borrowable                 |
      | - Inventory -              |
      | Relevant for inventory     |
      | Supply Category            |
      | Owner                      |
      | Last Checked               |
      | Responsible department     |
      | Responsible person         |
      | User/Typical usage         |
      | - Move -                   |
      | Move                       |
      | Target area                |
      | - Toni Ankunftskontrolle - |
      | Check-In Date              |
      | Check-In State             |
      | Check-In Note              |
      | - General Information -    |
      | Serial Number              |
      | MAC-Address                |
      | IMEI-Number                |
      | Name                       |
      | Note                       |
      | - Location -               |
      | Building                   |
      | Room                       |
      | Shelf                      |
      | - Invoice Information -    |
      | Reference                  |
      | Project Number             |
      | Invoice Number             |
      | Invoice Date               |
      | Initial Price              |
      | Supplier                   |
      | Warranty expiration        |
      | Contract expiration        |
  @javascript @personas @browser
  Scenario: Einen Gegenstand mit allen fehlenden Pflichtangaben erstellen
    Given I am Matti
    And man navigiert zur Gegenstandserstellungsseite
    And man setzt Bezug auf Investition
    And kein Pflichtfeld ist gesetzt
    | Modell        |
    | Inventarcode  |
    | Projektnummer |
    | Anschaffungskategorie  |
    Then kann das Modell nicht erstellt werden
    And I see an error message

  @javascript @personas
  Scenario: Einen Gegenstand mit einer fehlenden Pflichtangabe erstellen
    Given I am Matti
    And man navigiert zur Gegenstandserstellungsseite
    And man setzt Bezug auf Investition
    And jedes Pflichtfeld ist gesetzt
    | Modell        |
    | Inventarcode  |
    | Projektnummer |
    | Anschaffungskategorie |
    When ich das gekennzeichnete "Modell" leer lasse
    Then kann das Modell nicht erstellt werden
    And I see an error message
    And die anderen Angaben wurde nicht gelöscht

  @javascript @personas
  Scenario: Einen Gegenstand mit einer fehlenden Pflichtangabe erstellen
    Given I am Matti
    And man navigiert zur Gegenstandserstellungsseite
    And man setzt Bezug auf Investition
    And jedes Pflichtfeld ist gesetzt
    | Modell        |
    | Inventarcode  |
    | Projektnummer |
    | Anschaffungskategorie |
    When ich das gekennzeichnete "Inventarcode" leer lasse
    Then kann das Modell nicht erstellt werden
    And I see an error message
    And die anderen Angaben wurde nicht gelöscht

  @javascript @personas
  Scenario: Wo man einen Gegenstand erstellen kann
    Given I am Matti
    And man befindet sich auf der Liste des Inventars
    Then kann man einen Gegenstand erstellen

  @javascript @personas
  Scenario: Neuen Lieferanten erstellen falls nicht vorhanden
    Given I am Mike
    And ich befinde mich auf der Erstellungsseite eines Gegenstandes
    And jedes Pflichtfeld ist gesetzt
      | Modell        |
      | Inventarcode  |
      | Projektnummer |
      | Anschaffungskategorie |
    When ich einen nicht existierenen Lieferanten angebe
    And ich erstellen druecke
    Then wird der neue Lieferant erstellt
    And bei dem erstellten Gegestand ist der neue Lieferant eingetragen

  @javascript @personas @browser
  Scenario: Einen Gegenstand mit allen Informationen erstellen
    Given I am Matti
    And man navigiert zur Gegenstandserstellungsseite
    When ich die folgenden Informationen erfasse
    | Feldname                     | Type         | Wert                          |

    | Inventarcode                 |              | Test Inventory Code           |
    | Modell                       | autocomplete | Sharp Beamer 456              |

    | Inventarrelevant             | select       | Ja                            |
    | Anschaffungskategorie        | select       | Werkstatt-Technik             | 
    | Letzte Inventur              |              | 01.01.2013                    |
    | Verantwortliche Abteilung    | autocomplete | A-Ausleihe                    |
    | Verantwortliche Person       |              | Matus Kmit                    |
    | Benutzer/Verwendung          |              | Test Verwendung               |

    | Ankunftsdatum                |              | 01.01.2013                    |
    | Ankunftszustand              | select       | transportschaden              |
    | Ankunftsnotiz                |              | Test Notiz                    |

    And ich erstellen druecke
    Then man wird zur Liste des Inventars zurueckgefuehrt
    And ist der Gegenstand mit all den angegebenen Informationen erstellt

  @javascript @personas @browser
  Scenario: Einen Gegenstand mit allen Informationen erstellen
    Given I am Matti
    And man navigiert zur Gegenstandserstellungsseite
    When ich die folgenden Informationen erfasse
    | Feldname                     | Type         | Wert                          |

    | Inventarcode                 |              | Test Inventory Code           |
    | Modell                       | autocomplete | Sharp Beamer 456              |

    | Ausmusterung                 | select       | Nein                          |
    | Zustand                      | radio        | OK                            |
    | Vollständigkeit              | radio        | OK                            |
    | Ausleihbar                   | radio        | OK                            |

    | Inventarrelevant             | select       | Ja                            |
    | Anschaffungskategorie        | select       | Werkstatt-Technik             | 

    | Gebäude                      | autocomplete | Keine/r                       |
    | Raum                         |              | Test Raum                     |
    | Gestell                      |              | Test Gestell                  |

    And ich erstellen druecke
    Then man wird zur Liste des Inventars zurueckgefuehrt
    And ist der Gegenstand mit all den angegebenen Informationen erstellt

  @javascript @personas
  Scenario: Einen Gegenstand mit einer fehlenden Pflichtangabe erstellen
    Given I am Matti
    And man navigiert zur Gegenstandserstellungsseite
    And man setzt Bezug auf Investition
    And jedes Pflichtfeld ist gesetzt
    | Modell        |
    | Inventarcode  |
    | Projektnummer |
    | Anschaffungskategorie |
    When ich das gekennzeichnete "Projektnummer" leer lasse
    Then kann das Modell nicht erstellt werden
    And I see an error message
    And die anderen Angaben wurde nicht gelöscht

  @javascript @personas
  Scenario: Einen Gegenstand mit einer fehlenden Pflichtangabe erstellen
    Given I am Matti
    And man navigiert zur Gegenstandserstellungsseite
    And man setzt Bezug auf Investition
    And jedes Pflichtfeld ist gesetzt
    | Modell        |
    | Inventarcode  |
    | Projektnummer |
    | Anschaffungskategorie |
    When ich das gekennzeichnete "Anschaffungskategorie" leer lasse
    Then kann das Modell nicht erstellt werden
    And I see an error message
    And die anderen Angaben wurde nicht gelöscht

  @javascript @personas @browser
  Scenario: Einen Gegenstand mit allen Informationen erstellen
    Given I am Matti
    And man navigiert zur Gegenstandserstellungsseite
    When ich die folgenden Informationen erfasse
    | Feldname                     | Type         | Wert                          |

    | Inventarcode                 |              | Test Inventory Code           |
    | Modell                       | autocomplete | Sharp Beamer 456              |

    | Inventarrelevant             | select       | Ja                            |
    | Anschaffungskategorie        | select       | Werkstatt-Technik             | 

    | Bezug                        | radio must   | Investition                   |
    | Projektnummer                |              | Test Nummer                   |
    | Rechnungsnummer              |              | Test Nummer                   |
    | Rechnungsdatum               |              | 01.01.2013                    |
    | Anschaffungswert             |              | 50.00                         |
    | Garantieablaufdatum          |              | 01.01.2013                    |
    | Vertragsablaufdatum          |              | 01.01.2013                    |

    And ich erstellen druecke
    Then man wird zur Liste des Inventars zurueckgefuehrt
    And ist der Gegenstand mit all den angegebenen Informationen erstellt

  @javascript @personas @browser
  Scenario: Einen Gegenstand mit allen Informationen erstellen
    Given I am Matti
    And man navigiert zur Gegenstandserstellungsseite
    When ich die folgenden Informationen erfasse
    | Feldname                     | Type         | Wert                          |

    | Inventarcode                 |              | Test Inventory Code           |
    | Modell                       | autocomplete | Sharp Beamer 456              |

    | Inventarrelevant             | select       | Ja                            |
    | Anschaffungskategorie        | select       | Werkstatt-Technik             | 
    | Umzug                        | select       | sofort entsorgen              |
    | Zielraum                     |              | Test Raum                     |

    | Seriennummer                 |              | Test Seriennummer             |
    | MAC-Adresse                  |              | Test MAC-Adresse              |
    | IMEI-Nummer                  |              | Test IMEI-Nummer              |
    | Name                         |              | Test Name                     |
    | Notiz                        |              | Test Notiz                    |

    And ich erstellen druecke
    Then man wird zur Liste des Inventars zurueckgefuehrt
    And ist der Gegenstand mit all den angegebenen Informationen erstellt

  @javascript @personas
  Scenario: Wo man einen Gegenstand erstellen kann
    Given I am Matti
    And man befindet sich auf der Liste des Inventars
    Then kann man einen Gegenstand erstellen

  @javascript @personas
  Scenario: Felder die bereits vorausgefüllt sind
    Given I am Matti
    And man navigiert zur Gegenstandserstellungsseite
    Then ist der Barcode bereits gesetzt
    And Letzte Inventur ist das heutige Datum
    And folgende Felder haben folgende Standardwerte
    | Feldname         | Type             | Wert             |
    | Ausleihbar       | radio            | Nicht ausleihbar |
    | Inventarrelevant | select           | Ja               |
    | Zustand          | radio            | OK               |
    | Vollständigkeit  | radio            | OK               |
    | Anschaffungskategorie  | select     |                  |

  @javascript @personas
  Scenario: Werte für Anschaffungskategorie hinterlegen
    Given I am Matti
    And man navigiert zur Gegenstandserstellungsseite
    Then sind die folgenden Werte im Feld Anschaffungskategorie hinterlegt
    | Anschaffungskategorie |
    | Werkstatt-Technik     |
    | Produktionstechnik    |
    | AV-Technik            |
    | Musikinstrumente      |
    | Facility Management   |
    | IC-Technik/Software   |

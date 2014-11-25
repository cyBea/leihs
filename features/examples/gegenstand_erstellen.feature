
Feature: Gegenstand erstellen

  @javascript @personas
  Scenario: Order of the fields when creating an item
    Given I am Matti
    And I edit an item
    # WHY are we retiring the item? Is it necessary so we can see an edit view?
    # TODO: Explain the rationale.
    # TODO: Remove web_steps.rb
    And I select "Yes" from "item[retired]"
    And I choose "Investment" as reference
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
  Scenario: Forgetting to fill out the required fields when creating an item
    Given I am Matti
    And I edit an item
    And I choose "Investment" as reference
    And these required fields are blank:
    | Model           |
    | Inventory Code  |
    | Project Number  |
    | Supply Category |
    Then the model cannot be created
    And I see an error message

  @javascript @personas
  Scenario Outline: Forgetting to fill out just one required field when creating an item
    Given I am Matti
    And I edit an item
    And I choose "Investment" as reference
    And these required fields are filled in:
    | Model           |
    | Inventory Code  |
    | Project Number  |
    | Supply Category |
    When I leave the field "<required_field>" empty
    Then the model cannot be created
    And I see an error message
    And the other fields still contain their data
    Examples:
      | required_field  |
      | Model           |
      | Inventory Code  |
      | Project Number  |
      | Supply Category |

  @javascript @personas
  Scenario: Areas where you can create an item
    Given I am Matti
    And I open the inventory
    Then I can create an item

  @javascript @personas
  Scenario: Creating a new supplier if it does not already exist
    Given I am Mike
    And I edit an item
    And I choose "Investment" as reference
    And these required fields are filled in:
    | Model        |
    | Inventory Code|
    | Project Number |
    | Supply Category |
    When I enter a supplier that does not exist
    And I save
    Then a new supplier is created
    And the created item has the new supplier

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

    And I save
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

    And I save
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

    | Bezug                        | radio must   | Investition                   |
    | Projektnummer                |              | Test Nummer                   |
    | Rechnungsnummer              |              | Test Nummer                   |
    | Rechnungsdatum               |              | 01.01.2013                    |
    | Anschaffungswert             |              | 50.00                         |
    | Garantieablaufdatum          |              | 01.01.2013                    |
    | Vertragsablaufdatum          |              | 01.01.2013                    |

    And I save
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

    And I save
    Then man wird zur Liste des Inventars zurueckgefuehrt
    And ist der Gegenstand mit all den angegebenen Informationen erstellt

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

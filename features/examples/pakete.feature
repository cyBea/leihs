
Feature: Create model with packages

  Background:
    Given I am Mike
    And I open the inventory

  @javascript @browser @personas
  Scenario: Create model with package assignments
    When I add a new Model
    And I fill in at least the required fields
    And I add one or more packages
    And I add one or more items to this package
    And I save both package and model
    Then the model is created and the packages and their assigned items are saved
    And the packages have their own inventory codes

  @javascript @browser @personas
  Scenario: A model that already has items cannot be turned into a package
    When I edit a model that already has items

    Then I cannot assign packages to that model

  @javascript @browser @personas
  Scenario: Can't create package without items
    When I add a package to a model
    Then I can only save this package if I also assign items

  @javascript @browser @personas
  Scenario: Remove single item from a package
    When I edit a package
    Then I can remove items from the package
    And those items are no longer assigned to the package

  @javascript @browser @personas
  Scenario: Paketeigenschaften abfüllen bei existierendem Modell
    When ich ein Modell editiere, welches bereits Pakete hat
    And ich ein bestehendes Paket editiere
    And ich die folgenden Informationen erfasse
    | Feldname                     | Type         | Wert                          |
    | Zustand                      | radio        | OK                            |
    | Vollständigkeit              | radio        | OK                            |
    | Ausleihbar                   | radio        | OK                            |
    | Inventarrelevant             | select       | Ja                            |
    | Verantwortliche Abteilung    | autocomplete | A-Ausleihe                    |
    | Verantwortliche Person       |              | Matus Kmit                    |
    | Benutzer/Verwendung          |              | Test Verwendung               |
    | Name                         |              | Test Name                     |
    | Notiz                        |              | Test Notiz                    |
    | Gebäude                      | autocomplete | Keine/r                       |
    | Raum                         |              | Test Raum                     |
    | Gestell                      |              | Test Gestell                  |
    | Anschaffungswert             |              | 50.00                         |
    | Letzte Inventur              |              | 01.01.2013                    |
    And ich das Paket und das Modell speichere
    Then besitzt das Paket alle angegebenen Informationen

  @javascript @browser @personas
  Scenario: Modell mit Paketzuteilung erstellen und wieder editieren
    When ich ein neues Modell hinzufüge
    And ich mindestens die Pflichtfelder ausfülle
    And ich eine Paket hinzufüge
    And ich die Paketeigenschaften eintrage
    And ich diesem Paket eines oder mehrere Gegenstände hinzufügen
    And ich dieses Paket speichere
    And ich dieses Paket wieder editiere
    Then kann ich die Paketeigenschaften erneut bearbeiten
    And ich diesem Paket eines oder mehrere Gegenstände hinzufügen

  #74210792
  @javascript @browser @personas
  Scenario: Paketeigenschaften abfüllen bei neu erstelltem Modell
    When ich einem Modell ein Paket hinzufüge
    And ich diesem Paket eines oder mehrere Gegenstände hinzufügen
    And ich die folgenden Informationen erfasse
    | Feldname                     | Type         | Wert                          |
    | Zustand                      | radio        | OK                            |
    | Vollständigkeit              | radio        | OK                            |
    | Ausleihbar                   | radio        | OK                            |
    | Inventarrelevant             | select       | Ja                            |
    | Letzte Inventur              |              | 01.01.2013                    |
    | Verantwortliche Abteilung    | autocomplete | A-Ausleihe                    |
    | Verantwortliche Person       |              | Matus Kmit                    |
    | Benutzer/Verwendung          |              | Test Verwendung               |
    | Name                         |              | Test Name                     |
    | Notiz                        |              | Test Notiz                    |
    | Gebäude                      | autocomplete | Keine/r                       |
    | Raum                         |              | Test Raum                     |
    | Gestell                      |              | Test Gestell                  |
    | Anschaffungswert             |              | 50.00                         |
    And ich das Paket und das Modell speichere
    Then sehe ich die Meldung "Modell gespeichert / Pakete erstellt"
    And besitzt das Paket alle angegebenen Informationen
    And all the packaged items receive these same values store to this package
    | Feldname                   |
    | Verantwortliche Abteilung  |
    | Verantwortliche Person     |
    | Gebäude                    |
    | Raum                       |
    | Gestell                    |
    | Toni-Ankunftsdatum         |
    | Letzte Inventur            |


  @javascript @personas
  Scenario: Delete an item package that was never handed over
    Given a never handed over item package is currently in stock
    When edit the related model package
    When I delete that item package
    Then the item package is deleted
    And the packaged items are not part of that item package anymore
    When edit the related model package
    Then that item package is not listed

  @javascript @personas
  Scenario: Delete an item package related to a closed contract
    Given a once handed over item package is currently in stock
    When edit the related model package
    When I delete that item package
    Then the item package is retired
    And the packaged items are not part of that item package anymore
    When edit the related model package
    Then that item package is not listed

  @personas
  Scenario: Paket löschen schlägt fehl wenn das Paket gerade ausgeliehen ist
    When das Paket zurzeit ausgeliehen ist 
    Then kann ich das Paket nicht löschen

  @personas @javascript @browser
  Scenario: Nur meine Pakete werden im Modell angezeigt
    When ich ein Modell editiere, welches bereits Pakete in meine und andere Gerätepark hat
    Then I only see packages which I am responsible for

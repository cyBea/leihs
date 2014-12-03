
Feature: Software kopieren

  Background:
    Given I am Mike

  @personas @javascript @browser
  Scenario: Software kopieren
    Given a software license exists
    When I copy an existing software license
    Then it opens the edit view of the new software license
    And the title is labeled as "Neue Software-Lizenz erstellen"
    And the save button is labeled as "Lizenz speichern"
    And ein neuer Inventarcode vergeben wird
    When I save
    Then the new software license is created
    And the following fields were copied from the original software license
      | Software                  |
      | Bezug                     |
      | Besitzer                  |
      | Verantwortliche Abteilung |
      | Rechnungsdatum            |
      | Anschaffungswert          |
      | Lieferant                 |
      | Beschafft durch           |
      | Notiz                     |
      | Aktivierungstyp           |
      | Lizenztyp                 |
      | Gesamtanzahl              |
      | Betriebssystem            |
      | Installation              |
      | Lizenzablaufdatum         |
      | Maintenance-Vertrag       |
      | Maintenance-Ablaufdatum   |
      | Währung                   |
      | Preis                     |

  @personas @javascript @browser
  Scenario: Wo kann Software kopiert werden
    Given a software license exists
    When I open the Inventory
    Then I can copy an existing software license
    When ich mich in der Editieransicht einer Sofware-Lizenz befinde
    Then I can save and copy the existing software license

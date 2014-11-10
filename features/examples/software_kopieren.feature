
Feature: Software kopieren

  Grundlage:
    Given ich bin Mike

  @personas @javascript @browser
  Scenario: Software kopieren
    Given es existiert eine Software-Lizenz
    When ich eine bestehende Software-Lizenz kopiere
    Then wird die Editieransicht der neuen Software-Lizenz geöffnet
    And der Titel heisst "Neue Software-Lizenz erstellen"
    And der Speichern-Button heisst "Lizenz speichern"
    And ein neuer Inventarcode vergeben wird
    When ich speichere
    Then ist die neue Lizenz erstellt
    And wurden die folgenden Felder von der kopierten Lizenz übernommen
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

  @personas @javascript @browser
  Scenario: Wo kann Software kopiert werden
    Given es existiert eine Software-Lizenz
    When man im Inventar Bereich ist
    Then kann ich die bestehende Software-Lizenz kopieren
    When ich mich in der Editieransicht einer Sofware-Lizenz befinde
    Then kann ich die bestehende Software-Lizenz speichern und kopieren

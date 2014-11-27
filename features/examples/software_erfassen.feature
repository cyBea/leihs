
Feature: Software erfassen

  Grundlage:
    Given I am Mike

  @javascript @personas
  Scenario: Software-Produkt erfassen
    When ich eine neue Software hinzufüge
    And ich erfasse die folgenden Details
      | Feld                               | Wert                       |
      | Produkt                            | Test Software              |
      | Version                            | Test Version               |
      | Software Informationen             | Installationslink beachten: http://wwww.dokuwiki.ch\n\nDies ist nur ein Text |
    When there exists already a manufacturer
    Then the manufacturer can be selected from the list
    When I set a non existing manufacturer
    And I save
    Then ist die neue Software erstellt und unter Software auffindbar
    When I edit again this software product
    Then outside the the text field, they will additionally displayed lines with link only
    And the new manufacturer can be found in the manufacturer list

  # marked as upcoming due to ticket 71745006
  @upcoming @javascript @personas
  Scenario: Mögliche Werte in Software-Lizenz erfassen
    Given ich befinde mich auf der Lizenz-Erstellungsseite
    Then die mögliche Werte für Aktivierungstyp sind in der folgenden Reihenfolge:
      | Aktivierungstyp |
      | Keine/r |
      | Dongle |
      | Seriennummer |
      | Lizenzserver |
      | Challenge Response/System ID |
      Then die mögliche Werte für Lizenztyp sind in der folgenden Reihenfolge:
      | Lizenztyp |
      | Frei |
      | Einzelplatz |
      | Mehrplatz |
      | Site-Lizenz |
      | Konkurrent |
    Then die mögliche Werte für Ausleihbar sind in der folgenden Reihenfolge:
      | Ausleihbar |
      | OK |
      | Nicht ausleihbar |
    Then kann man als "Betriebssystem" keine, eine oder mehrere der folgenden Möglichkeiten in Form einer Checkbox auswählen:
      | Betriebssystem |
      | Windows |
      | Mac OS X |
      | Linux |
      | iOS |
    Then kann man als "Installation" keine, eine oder mehrere der folgenden Möglichkeiten in Form einer Checkbox auswählen:
      | Citrix |
      | Lokal |
      | Web |
    Then kann man als "Bezug" einen der folgenden Möglichkeiten anhand eines Radio-Buttons wählen:
      |laufende Rechnung|
      |Investition                 |
    Then kann man als "Lizenzablaufdatum" ein Datum auswählen
    Then for maintenance contract the available options are in the following order:
      | Nein |
      | Ja   |
    Then kann man als "Rechnungsdatum" ein Datum auswählen
    Then kann man als "Anschaffungswert" eine Zahl eingeben
    Then kann man als "Beschafft durch" einen Benutzer wählen
    Then kann man als "Lieferant" einen Lieferanten auswählen
    Then kann man als "Verantwortliche Abteilung" einen Gerätepark auswählen
    Then kann man als "Besitzer" einen Gerätepark auswählen
    Then kann man als "Notiz" einen Text eingeben
    And die Option "Ausleihbar" ist standardmässig auf "Nicht ausleihbar" gesetzt

  @javascript @personas @upcoming
  Scenario: Software-Lizenz erfassen
    Given es existiert ein Software-Produkt
    When ich eine neue Software-Lizenz hinzufüge
    And I fill in the software
    And ein neuer Inventarcode vergeben wird
    And ich eine Seriennummer eingebe
    When I choose dongle as activation type
    Then I have to provide a dongle id
    When I choose one of the following license types
      | Mehrplatz   |
      | Konkurrent  |
      | Site-Lizenz |
    And I fill in the value of total quantity
    And I add the quantity allocations
    And if I choose none, one or more of the available options for operating system
    And if I choose none, one or more of the available options for installation
    And I choose a date for license expiration
    When ich als Maintenance-Vertrag "Nein" auswähle
    Then I am not able to choose the maintenance expiration date
    And ich kann für den Maintenance-Vertrag kein Betrag eingeben
    And ich kann für den Maintenance-Vertrag keine Währung eingeben
    When ich als Maintenance-Vertrag "Ja" auswähle
    And I choose a date for the maintenance expiration
    When ich als Bezug "Investition" wähle
    Then I have to enter a project number
    And ich die den Wert "ausleihbar" setze
    And I save
    Then sind die Informationen dieser Software-Lizenz gespeichert

  @personas @javascript @browser
  Scenario: Lizenzanzahl bei Mehrplatz/Konkurrent/Site-Lizenzen
    Given es existiert ein Software-Produkt
    When ich eine neue Software-Lizenz hinzufüge
    And I fill in all the required fields for the license
    When I choose one of the following license types
      | Mehrplatz   |
      | Konkurrent  |
      | Site-Lizenz |
    And I fill in total quantity with value "50"
    Then I see the remaining number of licenses shown as follows "verbleibend 50"
    And I add the following quantity allocations:
      | Anzahl   | Text | 
      | 1        | Christina Meier| 
      | 10       | Raum ITZ.Z40| 
    Then I see the remaining number of licenses shown as follows "verbleibend 39"
    And I add the following quantity allocations:
      | Anzahl   | Text | 
      | 40       | Raum Z50 | 
    Then I see the remaining number of licenses shown as follows "verbleibend -1"
    When I delete the following quantity allocations:
      | Anzahl   | Text | 
      | 1        | Christina Meier| 
    Then I see the remaining number of licenses shown as follows "verbleibend 0"

  @javascript @personas
  Scenario: Software-Lizenz Anschaffungswert mit 2 Dezimalstellen erfassen
    Given es existiert ein Software-Produkt
    When ich eine neue Software-Lizenz hinzufüge
    And I fill in all the required fields for the license
    And I fill in the field "Anschaffungswert" with the value "1200"
    And I save
    Then "Anschaffungswert" is saved as "1'200.00"


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
    When der Hersteller bereits existiert
    Then kann der Hersteller aus der Liste ausgewählt werden
    When ich einen nicht existierenden Hersteller eingebe
    And ich speichere
    Then ist die neue Software erstellt und unter Software auffindbar
    When ich das Software-Produkt wieder editiere
    Then werden nur die Linien mit Links zusätzlich ausserhalb des Textfeldes angezeigt
    And der neue Hersteller ist in der Herstellerliste auffindbar

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
    Then die mögliche Werte für Maintenance-Vertrag sind in der folgenden Reihenfolge:
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

  @javascript @personas
  Scenario: Software-Lizenz erfassen
    Given es existiert ein Software-Produkt
    When ich eine neue Software-Lizenz hinzufüge
    And ich die Software setze
    And ein neuer Inventarcode vergeben wird
    And ich eine Seriennummer eingebe
    When ich als Aktivierungsart Dongle wähle
    Then muss ich eine Dongle-ID eingeben
    When ich einen der folgenden Lizenztypen wähle:
      | Mehrplatz   |
      | Konkurrent  |
      | Site-Lizenz |
    And ich eine Gesamtanzahl eingebe
    And ich die Anzahl-Zuteilungen hinzufüge
    And ich als Betriebssystem keine, eine oder mehrere der vorhandenen Möglichkeiten auswähle
    And ich als Installation keine, eine oder mehrere der vorhandenen Möglichkeiten auswähle
    And ich als Lizenzablaufdatum ein Datum auswähle
    When ich als Maintenance-Vertrag "Nein" auswähle
    Then kann ich für den Maintenance-Vertrag kein Ablaufdatum wählen
    When ich als Maintenance-Vertrag "Ja" auswähle
    And ich für den Maintenance-Vertrag ein Ablaufdatum wähle
    When ich als Bezug "Investition" wähle
    Then muss ich eine Projektnummer eingeben
    And ich die den Wert "ausleihbar" setze
    And ich speichere
    Then sind die Informationen dieser Software-Lizenz gespeichert

  @personas @javascript @browser
  Scenario: Lizenzanzahl bei Mehrplatz/Konkurrent/Site-Lizenzen
    Given es existiert ein Software-Produkt
    When ich eine neue Software-Lizenz hinzufüge
    And ich alle Pflichtfelder für die Lizenz ausfülle
    When ich einen der folgenden Lizenztypen wähle:
      | Mehrplatz   |
      | Konkurrent  |
      | Site-Lizenz |
    And ich die Gesamtanzahl "50" eingebe
    Then wird mir die verbleibende Anzahl der Lizenzen wie folgt angezeigt "verbleibend 50"
    And ich die folgenden Anzahl-Zuteilungen hinzufüge
      | Anzahl   | Text | 
      | 1        | Christina Meier| 
      | 10       | Raum ITZ.Z40| 
    Then wird mir die verbleibende Anzahl der Lizenzen wie folgt angezeigt "verbleibend 39"
    And ich die folgenden Anzahl-Zuteilungen hinzufüge
      | Anzahl   | Text | 
      | 40       | Raum Z50 | 
    Then wird mir die verbleibende Anzahl der Lizenzen wie folgt angezeigt "verbleibend -1"
    When ich die folgenden Anzahl-Zuteilungen lösche
      | Anzahl   | Text | 
      | 1        | Christina Meier| 
    Then wird mir die verbleibende Anzahl der Lizenzen wie folgt angezeigt "verbleibend 0" 

  @javascript @personas
  Scenario: Software-Lizenz Anschaffungswert mit 2 Dezimalstellen erfassen
    Given es existiert ein Software-Produkt
    When ich eine neue Software-Lizenz hinzufüge
    And ich alle Pflichtfelder für die Lizenz ausfülle
    And ich im Feld "Anschaffungswert" den Wert "1200" eingebe
    And ich speichere
    Then ist der "Anschaffungswert" als "1'200.00" gespeichert

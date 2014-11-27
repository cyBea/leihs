
Feature: Software editieren

  Grundlage:
    Given I am Mike

  @javascript @personas
  Scenario: Software-Produkt editieren
    When ich eine Software editiere
    And ich ändere die folgenden Details
      | Feld                   | Wert                                                           |
      | Produkt                | Test Software I                                                |
      | Version                | Test Version I                                                 |
      | Hersteller             | Neuer Hersteller                                               |
      | Software Informationen | Installationslink beachten: http://wwww.dokuwiki.ch/neue_seite |
    When I save
    And ich mich auf der Softwareliste befinde
    Then die Informationen sind gespeichert
    And die Daten wurden entsprechend aktualisiert

  #73278586
  @javascript @personas
  Scenario: Grösse des Software Informationen-Felds
    Given a software product with more than 6 text rows in field "Software Informationen" exists
    When I edit this software
    And I click in the field "Software Informationen"
    Then this field grows up till showing the complete text
    When I release the focus from this field
    Then this field shrinks back to the original size

  @javascript @personas
  Scenario: Software-Lizenz editieren
    When I edit an existing software license with software information, quantity allocations and attachments
    Then I see the "Software Information"
    And the software information is not editable
    And the links of software information open in a new tab upon clicking
    Then I see the attachments of the software
    And I can open the attachments in a new tab
    When ich eine andere Software auswähle
    And ich eine andere Seriennummer eingebe
    And ich einen anderen Aktivierungstyp wähle
    And ich den Wert "Ausleihbar" ändere
    And I change the options for operating system
    And I change the options for installation
    And I change the license expiration date
    And I change the value for maintenance contract
    And I change the value for reference
    And I change the value of the note
    And I change the value of dongle id
    And I choose one of the following license types
      | Mehrplatz   |
      | Konkurrent  |
      | Site-Lizenz |
    And I change the value of total quantity
    And I change the quantity allocations
    #But ich kann den Inventarcode nicht ändern # really? inventory manager can change the inventory number of an item right now...
    When I save
    Then sind die Informationen dieser Software-Lizenz erfolgreich aktualisiert worden

  @javascript @personas
  Scenario: Software-Lizenz editieren - Werte der Datenfelder löschen
    When I edit a license with set dates for maintenance expiration, license expiration and invoice date
    And I delete the data for the following fields:
      | Maintenance-Ablaufdatum |
      | Lizenzablaufdatum       |
      | Rechnungsdatum          |
    And I save
    Then I receive a notification of success
    When I edit the same license
    Then the following fields of the license are empty:
      | Maintenance-Ablaufdatum |
      | Lizenzablaufdatum       |
      | Rechnungsdatum          |

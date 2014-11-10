Feature: Edit order

  @javascript @personas
  Scenario: Sperrstatus des Benutzers anzeigen
    Given I am Pius
    And I open a take back for a suspended user
    Then I see the note 'Suspended!' next to their name

  @javascript @personas
  Scenario: Prevent 'approve anyway' for group managers
    Given I am Andi
    And an order contains overbooked models
    When I edit the order
    And I approve the order
    Then I cannot force the order to be approved

  @personas
  Scenario: Keine leeren Bestellungen in der Liste der Bestellungen
    Given ich bin Pius
    And es existiert eine leere Bestellung
    Then sehe ich diese Bestellung nicht in der Liste der Bestellungen

  @personas
  Scenario: Sichtbare Reiter
    Given ich bin Andi
    When ich mich auf der Liste der Bestellungen befinde
    Then sehe ich die Reiter "Alle, Offen, Genehmigt, Abgelehnt"

  @personas
  Scenario: Definition visierpflichtige Bestellungen
    Given es existiert eine visierpflichtige Bestellung
    Then wurde diese Bestellung von einem Benutzer aus einer visierpflichtigen Gruppe erstellt
    And diese Bestellung beinhaltet ein Modell aus einer visierpflichtigen Gruppe

  @javascript @personas
  Scenario: Alle Bestellungen anzeigen - Reiter Alle Bestellungen
    Given ich bin Andi
    And ich befinde mich im Gerätepark mit visierpflichtigen Bestellungen
    And ich mich auf der Liste der Bestellungen befinde
    When ich den Reiter "Alle" einsehe
    Then sehe ich alle visierpflichtigen Bestellungen
    And diese Bestellungen sind nach Erstelltdatum aufgelistet

  @javascript @browser @personas
  Scenario: Reiter Offene Bestellungen Darstellung
    Given ich bin Andi
    And ich befinde mich im Gerätepark mit visierpflichtigen Bestellungen
    And ich mich auf der Liste der Bestellungen befinde
    When ich den Reiter "Offen" einsehe
    Then sehe ich alle offenen visierpflichtigen Bestellungen
    And ich sehe auf der Bestellungszeile den Besteller mit Popup-Ansicht der Benutzerinformationen
    And ich sehe auf der Bestellungszeile das Erstelldatum
    And ich sehe auf der Bestellungszeile die Anzahl Gegenstände mit Popup-Ansicht der bestellten Gegenstände
    And ich sehe auf der Bestellungszeile die Dauer der Bestellung
    And ich sehe auf der Bestellungszeile den Zweck
    And ich kann die Bestellung genehmigen
    And ich kann die Bestellung ablehnen
    And ich kann die Bestellung editieren
    And ich kann keine Bestellungen aushändigen

  @javascript @browser @personas
  Scenario: Reiter "Genehmigt" Darstellung
    Given ich bin Andi
    And ich befinde mich im Gerätepark mit visierpflichtigen Bestellungen
    And ich mich auf der Liste der Bestellungen befinde
    When ich den Reiter "Genehmigt" einsehe
    Then sehe ich alle genehmigten visierpflichtigen Bestellungen
    And ich sehe auf der Bestellungszeile den Besteller mit Popup-Ansicht der Benutzerinformationen
    And ich sehe auf der Bestellungszeile das Erstelldatum
    And ich sehe auf der Bestellungszeile die Anzahl Gegenstände mit Popup-Ansicht der bestellten Gegenstände
    And ich sehe auf der Bestellungszeile die Dauer der Bestellung
    And ich sehe auf der Bestellungszeile den Status
    And ich eine bereits gehmigte Bestellung editiere
    And gelange ich in die Ansicht der Aushändigung
    But ich kann nicht aushändigen

  @javascript @browser @personas
  Scenario: Reiter "Abgelehnt" Darstellung
    Given ich bin Andi
    And ich befinde mich im Gerätepark mit visierpflichtigen Bestellungen
    And ich mich auf der Liste der Bestellungen befinde
    When ich den Reiter "Abgelehnt" einsehe
    Then sehe ich alle abgelehnten visierpflichtigen Bestellungen
    And ich sehe auf der Bestellungszeile den Besteller mit Popup-Ansicht der Benutzerinformationen
    And ich sehe auf der Bestellungszeile das Erstelldatum
    And ich sehe auf der Bestellungszeile die Anzahl Gegenstände mit Popup-Ansicht der bestellten Gegenstände
    And ich sehe auf der Bestellungszeile die Dauer der Bestellung
    And ich sehe auf der Bestellungszeile den Status

  @javascript @personas
  Scenario: Filter zum visieren aufheben
    Given ich bin Andi
    And ich befinde mich im Gerätepark mit visierpflichtigen Bestellungen
    And ich mich auf der Liste der Bestellungen befinde
    And sehe ich alle visierpflichtigen Bestellungen
    When ich den Filter "Zu prüfen" aufhebe
    Then sehe ich alle Bestellungen, welche von Benutzern der visierpflichtigen Gruppen erstellt wurden

  @javascript @browser @personas
  Scenario: Bereits genehmigte Bestellung zurücksetzen
    Given ich bin Andi
    And ich befinde mich im Gerätepark mit visierpflichtigen Bestellungen
    And ich mich auf der Liste der Bestellungen befinde
    When ich den Reiter "Genehmigt" einsehe
    And ich eine bereits gehmigte Bestellung editiere
    Then gelange ich in die Ansicht der Aushändigung
    And ich kann Modelle hinzufügen
    And ich kann Optionen hinzufügen
    But ich kann keine Gegenstände zuteilen
    And ich kann nicht aushändigen


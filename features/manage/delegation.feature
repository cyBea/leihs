
Feature: Delegation

  @javascript @personas
  Scenario: Einer Delegation einen gesperrten Verantwortlichen zuteilen
    Given ich bin Pius
    And ich befinde mich in der Editieransicht einer Delegation
    When ich einen Verantwortlichen zuteile, der für diesen Gerätepark gesperrt ist
    Then ist dieser bei der Auswahl rot markiert
    And hinter dem Namen steht in rot 'Gesperrt!'

  @javascript @personas
  Scenario: Einer Delegation einen gesperrten Benutzer hinzufügen
    Given ich bin Pius
    And ich befinde mich in der Editieransicht einer Delegation
    When ich einen Benutzer hinzufüge, der für diesen Gerätepark gesperrt ist
    Then ist er bei der Auswahl rot markiert
    And in der Auwahl steht hinter dem Namen in rot 'Gesperrt!'
    And in der Auflistung der Benutzer steht hinter dem Namen in rot 'Gesperrt!'

  @javascript @personas @browser
  Scenario: Kontaktperson bei Aushändigung wählen
    Given ich bin Pius
    And es existiert eine Aushändigung für eine Delegation mit zugewiesenen Gegenständen
    And ich öffne diese Aushändigung
    When ich die Aushändigung abschliesse
    Then muss ich eine Kontaktperson auswählen

  @javascript @personas @browser
  Scenario: Anzeige einer gesperrten Kontaktperson in Aushändigung
    Given ich bin Pius
    And es existiert eine Aushändigung für eine Delegation mit zugewiesenen Gegenständen
    And ich öffne diese Aushändigung
    When ich die Aushändigung abschliesse
    And ich eine gesperrte Kontaktperson wähle
    Then ist diese Kontaktperson bei der Auswahl rot markiert
    And in der Auwahl steht hinter dem Namen in rot 'Gesperrt!'

  @javascript @personas @browser
  Scenario: Auswahl einer gesperrten Kontaktperson in Bestellung
    Given ich bin Pius
    And ich befinde mich in einer Bestellung
    And ich wechsle den Benutzer
    And ich wähle eine Delegation
    When ich eine Kontaktperson wähle, der für diesen Gerätepark gesperrt ist
    Then ist er bei der Auswahl rot markiert
    And in der Auwahl steht hinter dem Namen in rot 'Gesperrt!'

  @javascript @personas @browser
  Scenario: Delegation in persönliche Bestellungen ändern in Aushändigung
    Given ich bin Pius
    And ich öffne eine Aushändigung für eine Delegation
    When ich statt einer Delegation einen Benutzer wähle
    Then ist in der Aushändigung der Benutzer aufgeführt

  @javascript @personas
  Scenario: Persönliche Bestellung in Delegationsbestellung ändern in Aushändigung
    Given ich bin Pius
    And ich öffne eine Aushändigung
    When ich statt eines Benutzers eine Delegation wähle
    Then ist in der Bestellung der Name der Delegation aufgeführt

  @javascript @personas
  Scenario: Anzeige des Tooltipps
    Given ich bin Pius
    When ich nach einer Delegation suche
    And ich über den Delegationname fahre
    Then werden mir im Tooltipp der Name und der Verantwortliche der Delegation angezeigt

  @javascript @personas
  Scenario: Globale Suche
    Given ich bin Pius
    And I search for 'Julie'
    When Julie in einer Delegation ist
    Then werden mir im alle Suchresultate von Julie oder Delegation mit Namen Julie angezeigt
    And mir werden alle Delegationen angezeigt, den Julie zugeteilt ist

  @personas
  Scenario: Gesperrte Benutzer können keine Bestellungen senden
    Given ich bin Julie
    When ich von meinem Benutzer zu einer Delegation wechsle
    And die Delegation ist für einen Gerätepark freigeschaltet
    But ich bin für diesen Gerätepark gesperrt
    Then kann ich keine Gegenstände dieses Geräteparks absenden

  @javascript @personas
  Scenario: Filter der Delegationen
    Given ich bin Pius
    When ich in den Admin-Bereich wechsel
    And man befindet sich auf der Benutzerliste
    Then kann ich in der Benutzerliste nach Delegationen einschränken
    And ich kann in der Benutzerliste nach Benutzer einschränken

  @javascript @personas
  Scenario: Erfassung einer Delegation
    Given ich bin Pius
    And ich in den Admin-Bereich wechsel
    And ich befinde mich im Reiter 'Benutzer'
    When ich eine neue Delegation erstelle
    And ich der Delegation Zugriff für diesen Pool gebe
    And ich dieser Delegation einen Namen gebe
    And ich dieser Delegation keinen, einen oder mehrere Personen zuteile
    And ich dieser Delegation keinen, einen oder mehrere Gruppen zuteile
    And ich kann dieser Delegation keine Delegation zuteile
    And ich genau einen Verantwortlichen eintrage
    And ich speichere
    Then ist die neue Delegation mit den aktuellen Informationen gespeichert

  @javascript @personas
  Scenario: Delegation erhält Zugriff als Kunde
    Given ich bin Pius
    And ich in den Admin-Bereich wechsel
    And ich befinde mich im Reiter 'Benutzer'
    When ich eine neue Delegation erstelle
    Then kann ich dieser Delegation ausschliesslich Zugriff als Kunde zuteilen

  @javascript @personas @browser
  Scenario: Delegation in persönliche Bestellungen ändern in Bestellung
    Given ich bin Pius
    And es wurde für eine Delegation eine Bestellung erstellt
    And ich befinde mich in dieser Bestellung
    When ich statt einer Delegation einen Benutzer wähle
    Then ist in der Bestellung der Benutzer aufgeführt
    And es ist keine Kontaktperson aufgeführt

  @javascript @personas
  Scenario: Delegation erfassen ohne Pflichtfelder abzufüllen
    Given ich bin Pius
    And ich in den Admin-Bereich wechsel
    And ich befinde mich im Reiter 'Benutzer'
    And ich eine neue Delegation erstelle
    When ich dieser Delegation einen Namen gebe
    And ich keinen Verantwortlichen zuteile
    And ich speichere
    Then I see an error message
    When ich genau einen Verantwortlichen eintrage
    And ich keinen Namen angebe
    And ich speichere
    Then I see an error message

  @javascript @personas
  Scenario: Delegation editieren
    Given ich bin Pius
    And ich in den Admin-Bereich wechsel
    And ich befinde mich im Reiter 'Benutzer'
    When ich eine Delegation editiere
    And ich den Verantwortlichen ändere
    And ich einen bestehenden Benutzer lösche
    And ich der Delegation einen neuen Benutzer hinzufüge
    And man teilt mehrere Gruppen zu
    And ich speichere
    Then sieht man die Erfolgsbestätigung
    And ist die bearbeitete Delegation mit den aktuellen Informationen gespeichert

  @javascript @personas
  Scenario: Delegation Zugriff entziehen
    Given ich bin Pius
    When ich eine Delegation mit Zugriff auf das aktuelle Gerätepark editiere
    And ich dieser Delegation den Zugriff für den aktuellen Gerätepark entziehe
    And ich speichere
    Then können keine Bestellungen für diese Delegation für dieses Gerätepark erstellt werden

  @javascript @personas @browser
  Scenario: Persönliche Bestellung in Delegationsbestellung ändern in Bestellung
    Given ich bin Pius
    And ich befinde mich in einer Bestellung
    When ich statt eines Benutzers eine Delegation wähle
    And ich eine Kontaktperson aus der Delegation wähle
    And ich bestätige den Benutzerwechsel
    Then ist in der Bestellung der Name der Delegation aufgeführt
    And ist in der Bestellung der Name der Kontaktperson aufgeführt

  @javascript @personas
  Scenario: Delegation löschen
    Given ich bin Gino
    And ich in den Admin-Bereich wechsle
    And ich befinde mich im Reiter 'Benutzer'
    When keine Bestellung, Aushändigung oder ein Vertrag für eine Delegation besteht
    And wenn für diese Delegation keine Zugriffsrechte für irgendwelches Gerätepark bestehen
    Then kann ich diese Delegation löschen

  #  ANZEIGE BACKEND

  @personas
  Scenario: Anzeige der Bestellungen für eine Delegation
    Given ich bin Pius
    And es wurde für eine Delegation eine Bestellung erstellt
    And ich befinde mich in dieser Bestellung
    Then sehe ich den Namen der Delegation
    And ich sehe die Kontaktperson

  @javascript @personas @browser
  Scenario: Definition Kontaktperson auf Auftragserstellung
    Given ich bin Julie
    When ich eine Bestellung für eine Delegationsgruppe erstelle
    Then bin ich die Kontaktperson für diesen Auftrag
    Given heute entspricht dem Startdatum der Bestellung
    And ich bin Pius
    When ich die Gegenstände für die Delegation an "Mina" aushändige
    Then ist "Mina" die neue Kontaktperson dieses Auftrages

  @personas
  Scenario: Anzeige der Bestellungen einer persönlichen Bestellung
    Given ich bin Pius
    And es existiert eine persönliche Bestellung
    And ich befinde mich in dieser Bestellung
    Then ist in der Bestellung der Name des Benutzers aufgeführt
    And ich sehe keine Kontatkperson

  @javascript @personas
  Scenario: Delegation in Aushändigung ändern
    Given ich bin Pius
    And es existiert eine Aushändigung für eine Delegation
    And ich öffne diese Aushändigung
    When ich die Delegation wechsle
    And ich bestätige den Benutzerwechsel
    Then lautet die Aushändigung auf diese neu gewählte Delegation

  @javascript @personas
  Scenario: Auswahl der Delegation in Aushändigung ändern
    Given ich bin Pius
    And ich öffne eine Aushändigung
    When ich versuche die Delegation zu wechseln
    Then kann ich nur diejenigen Delegationen wählen, die Zugriff auf meinen Gerätepark haben

  @javascript @personas @browser
  Scenario: Auswahl der Kontaktperson in Aushändigung ändern
    Given ich bin Pius
    And es existiert eine Aushändigung für eine Delegation mit zugewiesenen Gegenständen
    And ich öffne diese Aushändigung
    When ich versuche die Kontaktperson zu wechseln
    Then kann ich nur diejenigen Personen wählen, die zur Delegationsgruppe gehören

  @javascript @personas @browser
  Scenario: Auswahl der Kontaktperson in Bestellung ändern
    Given ich bin Pius
    And ich befinde mich in einer Bestellung von einer Delegation
    When ich versuche bei der Bestellung die Kontaktperson zu wechseln
    Then kann ich bei der Bestellung als Kontaktperson nur diejenigen Personen wählen, die zur Delegationsgruppe gehören

  @javascript @personas @browser
  Scenario: Borrow: Bestellung erfassen mit Delegation
    Given ich bin Julie
    When ich über meinen Namen fahre
    And I click on "Delegations"
    Then werden mir die Delegationen angezeigt, denen ich zugeteilt bin
    When ich eine Delegation wähle
    Then wechsle ich die Anmeldung zur Delegation
    Given man befindet sich auf der Modellliste
    When man auf einem verfügbaren Model "Zur Bestellung hinzufügen" wählt
    Then öffnet sich der Kalender
    When alle Angaben die ich im Kalender mache gültig sind
    Then lässt sich das Modell mit Start- und Enddatum, Anzahl und Gerätepark der Bestellung hinzugefügen
    When ich die Bestellübersicht öffne
    And ich einen Zweck eingebe
    And man merkt sich die Bestellung
    And ich die Bestellung abschliesse
    And ich refreshe die Bestellung
    Then ändert sich der Status der Bestellung auf Abgeschickt
    And die Delegation ist als Besteller gespeichert
    And ich werde als Kontaktperson hinterlegt

  @javascript @personas @browser
  Scenario: Delegation in Bestellungen ändern
    Given ich bin Pius
    And ich befinde mich in einer Bestellung
    When ich die Delegation wechsle
    And ich die Kontaktperson wechsle
    And ich bestätige den Benutzerwechsel
    Then lautet die Aushändigung auf diese neu gewählte Delegation
    And die neu gewählte Kontaktperson wird gespeichert

  @javascript @personas
  Scenario: Auswahl der Delegation in Bestellung ändern
    Given ich bin Pius
    And ich befinde mich in einer Bestellung
    When ich versuche die Delegation zu wechseln
    Then kann ich nur diejenigen Delegationen wählen, die Zugriff auf meinen Gerätepark haben

  @javascript @personas
  Scenario: Delegation wechseln - nur ein Kontaktpersonfeld
    Given ich bin Pius
    And ich befinde mich in einer Bestellung von einer Delegation
    When ich die Delegation wechsle
    Then sehe ich genau ein Kontaktpersonfeld

  @javascript @personas
  Scenario: Delegation wechseln - Kontaktperson ist ein Muss
    Given ich bin Pius
    And ich befinde mich in einer Bestellung
    When ich die Delegation wechsle
    And ich keine Kontaktperson angebe
    And ich den Benutzerwechsel bestätige
    Then sehe ich im Dialog die Fehlermeldung "Die Kontaktperson ist nicht Mitglied der Delegation oder ist leer"

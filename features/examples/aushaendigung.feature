
Feature: Aushändigung editieren

  Grundlage:
    Given ich bin Pius

  @javascript @browser @personas
  Scenario: Systemfeedback bei erfolgreicher manueller Interaktion bei Aushändigung
    Given es gibt eine Aushändigung mit mindestens einem nicht problematischen Modell
    And ich die Aushändigung öffne
    When ich dem nicht problematischen Modell einen Inventarcode zuweise
    Then wird der Gegenstand der Zeile zugeteilt
    And die Zeile wird selektiert
    And die Zeile wird grün markiert
    And ich erhalte eine Erfolgsmeldung
    When ich die Zeile deselektiere
    Then ist die Zeile nicht mehr grün eingefärbt
    When ich die Zeile wieder selektiere
    Then wird die Zeile grün markiert
    When ich den zugeteilten Gegenstand auf der Zeile entferne
    Then ist die Zeile nicht mehr grün markiert

  @javascript @browser @personas
  Scenario: Systemfeedback bei Zuteilen eines Gegenstandes zur problematischen Linie
    Given es gibt eine Aushändigung mit mindestens einer problematischen Linie
    And ich die Aushändigung öffne
    Then wird das Problemfeld für das problematische Modell angezeigt
    When ich dieser Linie einen Inventarcode manuell zuweise
    And die Zeile wird selektiert
    Then wird die Zeile grün markiert
    And die problematischen Auszeichnungen bleiben bei der Linie bestehen

  @personas @javascript
  Scenario: Sperrstatus des Benutzers anzeigen
    Given I open a hand over
    And der Benutzer für die Aushändigung ist gesperrt
    Then sehe ich neben seinem Namen den Sperrstatus 'Gesperrt!'

  @javascript @browser @personas
  Scenario: Systemfeedback bei Zuteilen einer Option
    Given ich öffne eine Aushändigung
    When ich eine Option hinzufüge
    Then wird die Zeile selektiert
    And die Zeile wird grün markiert
    And ich erhalte eine Meldung

  @javascript @personas
  Scenario: Aushändigung eines bereits zugeteilten Gegenstandes
    Given ich öffne eine Aushändigung mit mindestens einem zugewiesenen Gegenstand
    When ich einen bereits hinzugefügten Gegenstand zuteile
    Then erhalte ich eine entsprechende Info-Meldung 'XY ist bereits diesem Vertrag zugewiesen'
    And die Zeile bleibt selektiert
    And die Zeile bleibt grün markiert

  @javascript @personas
  Scenario: Standard-Vertragsnotiz
    Given für den Gerätepark ist eine Standard-Vertragsnotiz konfiguriert
    And ich öffne eine Aushändigung mit mindestens einem zugewiesenen Gegenstand
    When ich die Gegenstände aushändige
    Then erscheint ein Aushändigungsdialog
    And diese Standard-Vertragsnotiz erscheint im Textfeld für die Vertragsnotiz

  @javascript @personas
  Scenario: Vertragsnotiz
    When I open a hand over
    When ich aushändige
    Then erscheint ein Dialog
    And ich kann eine Notiz für diesen Vertrag eingeben
    When ich eine Notiz für diesen Vertrag eingebe
    Then erscheint diese Notiz auf dem Vertrag

  @javascript @browser @personas
  Scenario: Optionen mit einer Mindestmenge 1 ausgeben
    Given ich öffne eine Aushändigung
    When ich eine Option hinzufüge
    And ich die Anzahl "0" in das Mengenfeld schreibe
    Then wird die Menge mit dem ursprünglichen Wert überschrieben
    When ich die Anzahl "-1" in das Mengenfeld schreibe
    Then wird die Menge mit dem ursprünglichen Wert überschrieben
    When ich die Anzahl "abc" in das Mengenfeld schreibe
    Then wird die Menge mit dem ursprünglichen Wert überschrieben
    When ich die Anzahl "2" in das Mengenfeld schreibe
    Then wird die Menge mit dem Wert "2" gespeichert

  @javascript @browser @personas
  Scenario: Anzeige der Seriennummer bei Zuteilung der Software-Lizenz
    Given ich öffne eine Aushändigung mit einer Software
    When ich in das Zuteilungsfeld links vom Software-Namen klicke
    Then wird mir der Inventarcode sowie die vollständige Seriennummer angezeigt

  @javascript @browser @personas
  Scenario: Listung von problematischen Gegenständen
    Given es existiert ein Modell mit einem problematischen Gegenstand
    And ich öffne eine Aushändigung für irgendeinen Benutzer
    When ich diesen Modell der Aushändigung hinzufüge
    And ich auf der Modelllinie die Gegenstandsauswahl öffne
    Then wird der problematische Gegenstand in rot aufgelistet

  @javascript @browser @personas
  Scenario: Keine Auflistung von ausgemusterten Gegenständen
    Given es existiert ein Modell mit einem ausgemusterten und einem ausleihbaren Gegenstand
    And ich öffne eine Aushändigung für irgendeinen Benutzer
    When ich diesen Modell der Aushändigung hinzufüge
    And ich auf der Modelllinie die Gegenstandsauswahl öffne
    Then wird der ausgemusterte Gegenstand nicht aufgelistet

  @personas @javascript @browser
  Scenario: Anzeige von bereits zugewiesenen Gegenständen
    Given es besteht bereits eine Aushändigung mit mindestens 21 zugewiesenen Gegenständen für einen Benutzer
    When ich die Aushändigung öffne
    Then sehe ich all die bereits zugewiesenen Gegenstände mittels Inventarcodes

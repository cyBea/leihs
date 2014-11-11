
Feature: Verfügbarkeit

  Grundlage:
    Given I am Normin
    And ich habe eine offene Bestellung mit Modellen
    And die Bestellung Timeout ist 30 Minuten

  @personas
  Scenario: Überbuchung durch Ausleih-Manager
    When ich ein Modell der Bestellung hinzufüge
    Given I am Pius
    When ich dasselbe Modell einer Bestellung hinzufüge
    And die maximale Anzahl der Gegenstände überschritten ist
    Given I am Normin
    When ich die Bestellübersicht öffne
    And ich die Bestellung abschliesse
    Then wird die Bestellung nicht abgeschlossen
    And ich lande auf der Seite der Bestellübersicht
    And ich erhalte eine Fehlermeldung

  @personas
  Scenario: Blockieren der Modelle
    When ich eine Aktivität ausführe
    Then bleiben die Modelle in der Bestellung blockiert

  @personas
  Scenario: Freigabe der Modelle
    When ich länger als 30 Minuten keine Aktivität ausgeführt habe
    Then werden die Modelle meiner Bestellung freigegeben

  @personas
  Scenario: Erneutes Blockieren nach Inaktivität
    Given ich länger als 30 Minuten keine Aktivität ausgeführt habe
    And alle Modelle verfügbar sind
    When ich eine Aktivität ausführe
    Then kann man sein Prozess fortsetzen
    And die Modelle werden blockiert

  @personas
  Scenario: Modelle nach langer Inaktivität nicht mehr verfügbar
    Given ein Modell ist nicht verfügbar
    And ich länger als 30 Minuten keine Aktivität ausgeführt habe
    When ich eine Aktivität ausführe
    Then werde ich auf die Timeout Page geleitet
    
    
    
    
    
    

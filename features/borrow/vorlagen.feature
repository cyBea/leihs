
Feature: Vorlagen

  Grundlage:
    Given ich bin Normin

  @personas
  Scenario: Liste der Vorlagen finden
    Given man befindet sich auf der Seite der Hauptkategorien
    Then sehe ich unterhalb der Kategorien einen Link zur Liste der Vorlagen

  @personas
  Scenario: Liste der Vorlagen
    Given ich schaue mir die Liste der Vorlagen an
    Then sehe ich die Vorlagen
    And die Vorlagen sind alphabetisch nach Namen sortiert
    And ich kann eine der Vorlagen detailliert betrachten

  @javascript @browser @personas
  Scenario: Betrachten einer Vorlage
    Given ich sehe mir eine Vorlage an
    Then sehe ich alle Modelle, die diese Vorlage beinhaltet
    And die Modelle in dieser Vorlage sind alphabetisch sortiert
    And ich sehe für jedes Modell die Anzahl Gegenstände dieses Modells, welche die Vorlage vorgibt
    And ich kann die Anzahl jedes Modells verändern, bevor ich den Prozess fortsetze
    And ich kann höchstens die maximale Anzahl an verfügbaren Geräten eingeben
    And ich muss den Prozess zur Datumseingabe fortsetzen

  @personas
  Scenario: Warnung bei nicht erfüllbaren Vorlagen
    Given ich sehe mir eine Vorlage an
    And in dieser Vorlage hat es Modelle, die nicht genügeng Gegenstände haben, um die in der Vorlage gewünschte Anzahl zu erfüllen
    Then sehe ich eine auffällige Warnung sowohl auf der Seite wie bei den betroffenen Modellen

  @javascript @personas
  Scenario: Datumseingabe nach Mengenangabe
    Given ich habe die Mengen in der Vorlage gewählt
    Then ist das Startdatum heute und das Enddatum morgen 
    And ich kann das Start- und Enddatum einer potenziellen Bestellung ändern
    And ich muss im Prozess weiterfahren zur Verfügbarkeitsanzeige der Vorlage
    And alle Einträge erhalten das ausgewählte Start- und Enddatum

  @javascript @browser @personas
  Scenario: Verfügbarkeitsansicht der Vorlage
    Given ich sehe die Verfügbarkeit einer Vorlage, die nicht verfügbare Modelle enthält
    Then sind diejenigen Modelle hervorgehoben, die zu diesem Zeitpunkt nicht verfügbar sind
    And die Modelle sind innerhalb eine Gruppe alphabetisch sortiert
    And ich kann Modelle aus der Ansicht entfernen
    And ich kann die Anzahl der Modelle ändern
    And ich kann das Zeitfenster für die Verfügbarkeitsberechnung einzelner Modelle ändern
    When ich sämtliche Verfügbarkeitsprobleme gelöst habe
    Then kann ich im Prozess weiterfahren und alle Modelle gesamthaft zu einer Bestellung hinzufügen

  @personas
  Scenario: Nur verfügbaren Modelle aus Vorlage in Bestellung übernehmen
    Given ich sehe die Verfügbarkeit einer nicht verfügbaren Vorlage
    And einige Modelle sind nicht verfügbar
    Then kann ich diejenigen Modelle, die verfügbar sind, gesamthaft einer Bestellung hinzufügen
    And die restlichen Modelle werden verworfen

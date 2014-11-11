
Feature: Modellübersicht

  Um ausführliche Informationen über ein Modell zu erhalten
  möchte ich als Ausleihender
  die Möglichkeit haben ausführliche Informationen über ein Modell zu sehen

  @personas
  Scenario: Modellübersicht
    Given I am Normin
    And man befindet sich auf der Liste der Modelle
    When ich ein Modell auswähle
    Then lande ich auf der Modellübersicht
    And ich sehe die folgenden Informationen
    | Modellname         |  
    | Hersteller         |  
    | Bilder             |  
    | Beschreibung       |  
    | Anhänge            |  
    | Eigenschaften      |  
    | Ergänzende Modelle |

  @javascript @personas
  Scenario: Bilder vergrössern
    Given I am Normin
    And man befindet sich in einer Modellübersicht mit Bildern
    When ich über ein solches Bild hovere
    Then wird das Bild zum Hauptbild
    When ich über ein weiteres Bild hovere
    Then wird dieses zum Hauptbild
    When ich ein Bild anklicke
    Then wird das Bild zum Hauptbild auch wenn ich das hovern beende

  @javascript @personas
  Scenario: Eigenschaften anzeigen
    Given I am Normin
    And man befindet sich in einer Modellübersicht mit Eigenschaften
    Then werden die ersten fünf Eigenschaften mit Schlüssel und Wert angezeigt
    And wenn man 'Alle Eigenschaften anzeigen' wählt
    Then werden alle weiteren Eigenschaften angezeigt
    And man kann an derselben Stelle die Eigenschaften wieder zuklappen

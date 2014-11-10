
Feature: Geräteparks

  @personas
  Scenario: Gerätepark Informationen
    Given ich bin Normin
    When ich den Gerätepark Link drücke
    Then sehe ich die Geräteparks für die ich berechtigt bin
    And ich sehe nur die Geräteparks, die ausleihbare Gegenstände enthalten
    And sehe die Beschreibung für jeden Gerätepark
    And die Geräteparks sind auf dieser Seite alphabetisch sortiert

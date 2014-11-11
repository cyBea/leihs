
Feature: Explorative Suche

  Um Modelle anhand von Kategorien explorativ zu entdecken
  möchte ich als Ausleihender
  eine entsprehende Interaktionsmöglichkeit haben

  Grundlage:
    Given I am Normin

  @personas
  Scenario: Explorative Suche in Modellliste
    Given man sich auf der Modellliste befindet
    Then sehe ich die explorative Suche
    And sie beinhaltet die direkten Kinder und deren Kinder gemäss aktuell ausgewählter Kategorie
    And diejenigen Kategorien, die oder deren Nachfolger keine ausleihbare Gegenstände beinhalten, werden nicht angezeigt

  @personas
  Scenario: Wahl einer Subkategorie
    Given man sich auf der Modellliste befindet
    When ich eine Kategorie wähle
    Then werden die Modelle der aktuell angewählten Kategorie angezeigt

  @personas
  Scenario: Unterstes Blatt erreicht
    Given man befindet sich auf der Modellliste einer Kategorie ohne Kinder
    Then ist die explorative Suche nicht sichtbar und die Modellliste ist erweitert

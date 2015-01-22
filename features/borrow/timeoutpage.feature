Feature: Timeout page

  @personas
  Scenario: Order timed out
    Given I am Normin
    And I hit the timeout page with a model that has conflicts
    And I have added items to an order
    And the last activity on my order was more than 30 minutes ago
    When I am listing the root categories
    Then I am redirected to the timeout page
    And I am informed that my items are no longer reserved for me
  @personas
  Scenario: Ansicht
    Given I am Normin
    And I hit the timeout page with a model that has conflicts
    Then I see my order
    And the no longer available items are highlighted
    And I can delete entries
    And I can edit entries
    And I can return to the main order overview

  @javascript @browser @personas
  Scenario: Eintrag löschen
    Given I am Normin
    And I hit the timeout page with a model that has conflicts
    And ich lösche einen Eintrag
    Then wird der Eintrag aus der Bestellung gelöscht

  @javascript @browser @personas
  Scenario: In Bestellung übernehmen nicht möglich
    Given I am Normin
    And I hit the timeout page with 2 models that have conflicts
    When I click on "Continue this order"
    Then I am redirected to the timeout page
    And ich erhalte einen Fehler
    When ich einen der Fehler korrigiere
    When I click on "Continue this order"
    Then I am redirected to the timeout page
    And ich erhalte einen Fehler
    When ich alle Fehler korrigiere
    Then verschwindet die Fehlermeldung

  @personas
  Scenario: Bestellung löschen
    Given I am Normin
    And I hit the timeout page with a model that has conflicts
    When ich die Bestellung lösche
    Then werden die Modelle meiner Bestellung freigegeben
    And wird die Bestellung des Benutzers gelöscht
    And I am on the root category list

  @personas
  Scenario: Nur verfügbare Modelle aus Bestellung übernehmen
    Given I am Normin
    And I hit the timeout page with a model that has conflicts
    When ein Modell nicht verfügbar ist
    And I click on "Continue with available models only"
    Then werden die nicht verfügbaren Modelle aus der Bestellung gelöscht
    And ich lande auf der Seite der Bestellübersicht
    And ich sehe eine Information, dass alle Geräte wieder verfügbar sind

  @javascript @browser @personas
  Scenario: Eintrag ändern
    Given I am Normin
    And I hit the timeout page with a model that has conflicts
    And ich einen Eintrag ändere
    Then werden die Änderungen gespeichert
    And I am redirected to the timeout page

  @javascript @browser @personas
  Scenario: Die Menge eines Eintrags heruntersetzen
    Given I am Normin
    And I hit the timeout page with a model that has conflicts
    When ich die Menge eines Eintrags heraufsetze
    Then werden die Änderungen gespeichert
    When ich die Menge eines Eintrags heruntersetze
    Then werden die Änderungen gespeichert
    And I am redirected to the timeout page

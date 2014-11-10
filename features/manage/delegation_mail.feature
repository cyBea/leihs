
Feature: Mailversand bei Delegationsbestellungen und -besuchen

  @javascript @personas
  Scenario: Handhabung der Genehmigungsmails
    Given ich bin Pius
    And es existiert eine Bestellung von einer Delegation die nicht von einem Delegationsverantwortlichen erstellt wurde
    When I edit the order
    And die Bestellung genehmige
    Then ich erhalte eine Erfolgsmeldung
    And wird das Genehmigungsmail an den Besteller versendet
    And das Genehmigungsmail wird nicht an den Delegationsverantwortlichen versendet

  @javascript @personas
  Scenario: Handhabung der Erinnerungsmails
    Given ich bin Pius
    And es existiert eine Rücknahme von einer Delegation
    When ich bei dieser Rücknahme eine Erinnerung sende
    Then wird das Erinnerungsmail an den Abholenden versendet
    And das Erinnerungsmail wird nicht an den Delegationsverantwortlichen versendet

  @javascript @personas
  Scenario: Mail an Delegation senden
    Given ich bin Pius
    When ich nach einer Delegation suche
    And ich die Mailfunktion wähle
    Then wird das Mail an den Delegationsverantwrotlichen verschickt

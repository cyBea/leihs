# language: de

Funktionalität: Ausleihe

  Grundlage:
    Angenommen ich bin Pius

  @javascript @personas
  Szenario: Selektion bei manueller Interaktion bei Rücknahme
    Wenn ich eine Rücknahme mache die Optionen beinhaltet
    Und die Anzahl einer zurückzugebenden Option manuell ändere
    Dann wird die Option ausgewählt und der Haken gesetzt

  @javascript @personas
  Szenario: Suche innerhalb Bestellungen
    Angenommen es existieren Bestellungen
    Wenn ich mich auf der Liste der Bestellungen befinde
    Und ich nach einer Bestellung suche
    Dann werden mir alle Bestellungen aufgeführt, die zu meinem Suchbegriff passen

  @javascript @personas
  Szenario: Suche innerhalb Verträgen
    Angenommen es existieren Verträge
    Wenn ich mich auf der Liste der Verträge befinde
    Und ich nach einem Vertrag suche
    Dann werden mir alle Verträge aufgeführt, die zu meinem Suchbegriff passen

  @javascript @personas
  Szenario: Suche innerhalb Besuche
    Angenommen es existieren Besuche
    Wenn ich mich auf der Liste der Besuche befinde
    Und ich nach einem Besuch suche
    Dann werden mir alle Besuche aufgeführt, die zu meinem Suchbegriff passen

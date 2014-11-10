# language: de

Funktionalität: Ausleihe

  Grundlage:
    Angenommen ich bin Pius

  @javascript @personas @browser
  Szenario: Zusammenziehen der Anzahlen im Item-Popup
    Angenommen man fährt über die Anzahl von Gegenständen in einer Zeile
    Dann werden alle diese Gegenstände aufgelistet
    Und man sieht pro Modell eine Zeile
    Und man sieht auf jeder Zeile die Summe der Gegenstände des jeweiligen Modells

  @javascript @personas
  Szenario: Klick auf Letzten Besucher nach Editieren einer Bestellung
    Angenommen I open the daily view
    Und ich öffne eine Bestellung
    Dann I return to the daily view
    Dann sehe ich die letzten Besucher
    Und ich sehe den Benutzer der vorher geöffneten Bestellung als letzten Besucher
    Wenn ich auf den Namen des letzten Benutzers klicke
    Dann wird mir ich ein Suchresultat nach dem Namen des letzten Benutzers angezeigt

  @javascript @personas
  Szenario: Autocomplete bei der Rücknahme
    Wenn ich eine Rücknahme mache
    Und etwas in das Feld "Inventarcode/Name" schreibe
    Dann werden mir diejenigen Gegenstände vorgeschlagen, die in den dargestellten Rücknahmen vorkommen
    Wenn ich etwas zuweise, das nicht in den Rücknahmen vorkommt
    Dann I see an error message
    Und die Fehlermeldung lautet "In dieser Rücknahme nicht gefunden"

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

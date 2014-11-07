# language: de

Funktionalität: Hinzufügen von Modellen

  Grundlage:
    Angenommen ich bin Pius

  @javascript @browser @personas
  Szenario: Verfügbarkeitsanzeige beim Hinzufügen zu einer Bestellung
    Angenommen ich editiere eine Bestellung
      Und ich suche ein Modell um es hinzuzufügen
    Dann sehe ich die Verfügbarkeit innerhalb der gefundenen Modelle im Format: "2(3)/7 Modelname Typ"

  @javascript @browser @personas
  Szenario: Verfügbarkeitsanzeige beim Hinzufügen zu einer Aushändigung
    Angenommen I am doing a hand over
      Und ich suche ein Modell um es hinzuzufügen
    Dann sehe ich die Verfügbarkeit innerhalb der gefundenen Modelle im Format: "2(3)/7 Modelname Typ"

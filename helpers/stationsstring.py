# encoding=utf-8

txt = ''' Hallo  und herzlich  willkommen in   Knechtsteden!  Wir   freuen   uns, Ihnen  diesen besonderenwie geschichtsträchtigenOrt vorstellen und bekannt machen zu dürfen. In gewisser Weise halten Sie jeneBesonderheit bereits in Ihren Händen –schließlich ist dieser  appbasierte  Klosterführer  im  Rahmen eines  Schülerprojektes  am  Norbert-GymnasiumKnechtstedenentstanden. Erist einBeispiel für die vielen Kooperationen und Projekte, die Knechtsteden anzuziehenscheint und als spirituellen wie kulturellen Ort so attraktiv macht.Beginnen  wir zunächst  mit  einigen  Hinweisen  zur  Benutzung  der  App. 2Auf  Ihrem digitalen Endgerät hören Sie den Audioguide, 3begleitend können Sie auf dem Displayaber  auch Hinweise und  Bilder  einsehen.Neben  diesen  audiovisuellen  Angeboten 4bieten  wir  Ihnen  zusätzlichdie  Textfassung des  Audioguides  an.  So  können  Sie  dasGehörte in Ruhe noch einmal lesen.Sollten Sie einmal Eindrücke auf sich wirken lassen wollen,  können  Sie  den  Audioguide  auch  einfach  pausieren.NachMöglichkeit möchten  wir  Sie  bitten, insbesondere  in  der  Basilika Kopfhörer oder  hilfsweise die Textfassung der   Führung zu   benutzen5, schließlich befinden   Sie   sich   an   einemspirituellen  Ort.Folgen  Sie  den  Hinweisen  und  Wegbeschreibungen  der  Führung. 6Nach   jeder   Station   werden   Sie   zur   nächsten   navigiert.   Nutzen   Sie   hierfür   die Standortdaten in der App und lokalisieren Sie auf der Karte die nächste Station.
'''

x = txt.replace("  ", " ")

x = x.replace("\n ", "\n")

print(x) 
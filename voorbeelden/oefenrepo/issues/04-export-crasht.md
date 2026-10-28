## 04 Een order exporteren naar CSV geeft een geldige regel

Klanten krijgen een foutmelding als ze een order naar CSV exporteren, bij elke order. Ze verwachten één regel per order.

Klaar als
- [ ] `OrderExporter::toCsvRow()` geeft voor een gewone order `nummer;klant;totaal in centen;aantal regels`, zonder foutmelding
- [ ] er is een test voor `OrderExporter` die op de huidige code rood is en na de fix groen
- [ ] `bin/meting --poort` is groen

Niet doen
- `toArray()` niet wijzigen
- geen tests aanpassen om ze groen te krijgen
- niet zelf beslissen wat er moet gebeuren met een puntkomma of aanhalingsteken in een veld: vraag het de mens

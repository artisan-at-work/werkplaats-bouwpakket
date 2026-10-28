# Werkplaats-bouwpakket

De harness uit De Werkplaats, om in je eigen repo te zetten. Er zit geen app in en geen nieuwe agent: die heb je al, dat is Claude Code. Wat hier staat, bepaalt wat de agent weet, wat hij nooit mag, wanneer hij klaar is en wie zijn werk nakijkt.

Deze README heeft twee delen:

1. **In je eigen repo.** Installeren, de agent een eerste versie laten schrijven, beoordelen en testen.
2. **Naslag.** Per bestand wat het doet, en voorbeelden van een ingevulde meting.

---

## 1. In je eigen repo

### Installeren

Ga naar de map van je applicatie, waar `composer.json` of `package.json` staat, en maak een branch:

```
git switch -c werkplaats
curl -fsSL https://raw.githubusercontent.com/artisan-at-work/werkplaats-bouwpakket/main/installeer | bash
```

Het script haalt het bouwpakket op naar `.werkplaats/`, een map die git negeert. Je hoeft dus niets te clonen. Het zet alleen bestanden neer die er nog niet zijn, en opent daarna het stappenplan (`docs/agents/stappenplan.html`) in je browser. Daarin staan alle stappen hieronder, met commando's die je kunt kopiëren.

Had je al een `CLAUDE.md`, `AGENTS.md` of `.claude/settings.json`, dan blijven die staan en zegt het script dat.

### De agent schrijft de eerste versie

```
claude
```

Typ in Claude Code: `/inrichten`

De agent leest je repo: je stack, je tests, PHPStan, Rector, je CI en je bestaande `CLAUDE.md` en `AGENTS.md`. Daarna schrijft hij concepten voor de bestanden van het pakket en voegt hij ze samen met wat er al stond. Hij legt geen nulmeting vast en commit niets.

### Jullie keuren het goed

Loop de bestanden samen langs. Per bestand drie vragen:

| Bestand | Vragen |
| --- | --- |
| `AGENTS.md` | Staan de regels erin die een nieuwe collega op dag één moet weten? Klopt er iets niet? Is het kort genoeg? |
| `meting.txt` | Kloppen de checks met wat jullie nu draaien? Missen we er een? Is het eigen risico het goede? |
| `docs/agents/risico.md` | Is dit de plek waar het bij jullie stil misgaat? Wat weet het team dat niet in de code staat? |
| `REVIEW.md` | Is dit wat jullie bij een review zoeken? Waar moet hij juist niet op letten? |
| `.claude/hooks/grens.sh` | Is de voorgestelde regel goed? Wat mag een agent bij jullie nog meer nooit doen? |

Pas aan wat niet klopt. Daarna leg je de nulmeting vast:

```
bin/meting --nulmeting
git add -A && git commit -m "Harness van De Werkplaats"
```

Vanaf nu staat de klaar-hook aan: de agent kan niet stoppen zolang de meting rood is.

### Twee proeven

Start `claude` opnieuw, want hooks worden bij de start gelezen.

- **Grens.** Vraag de agent iets wat jullie eigen regel verbiedt, of *"Doe een force-push naar deze branch."* De hook weigert.
- **Meting.** Maak zelf een test kapot en vraag de agent iets kleins. Als hij wil stoppen, krijgt hij de rode tabel en moet hij het oplossen of jou vragen. Zet de test daarna terug.

### Eén echt geval

Neem een geval waarvan jullie het antwoord kennen.

- **Een oude pull request waar achteraf een bug in zat.** Vraag in een nieuwe sessie: *"Laat de reviewer-subagent de wijzigingen in `git diff <commit-ervoor>...<commit-van-de-pr>` reviewen."* Vond hij het?
- **Een ticket met een bekende oplossing.** Zet het in een issue met het sjabloon uit `issues/sjabloon.md` en vraag: *"Pak issues/<bestand> op."* Kijk wat er gebeurt als hij denkt dat hij klaar is.

Commit, push de branch en open een pull request. Of jullie hem mergen, beslissen jullie zelf.

### De matrix

Vul `docs/agents/autonomie.md` in met tien echte wijzigingen van de afgelopen weken. Per wijziging: zie je het als het misgaat, kun je terug, en welke check vangt het?

### Huiswerk

- **Een evalset.** Maak van je echte geval een bestand in `evals/`, zoals `evals/voorbeeld.md`, en voeg er twee aan toe. Draai ze opnieuw als je AGENTS.md, REVIEW.md of het model verandert, en houd de uitkomst bij in `evals/scores.md`.
- **De reviewer in CI.** Laat hem bij elke pull request commentaar geven.

---

## 2. Naslag

| Bestand | Wat het doet |
| --- | --- |
| `CLAUDE.md` | Eén regel: `@AGENTS.md`. Claude Code leest dit bij elke sessie. |
| `AGENTS.md` | Wat een nieuwe collega moet weten: commando's, regels, waar de context staat. Maximaal een scherm. |
| `docs/agents/risico.md` | Eén plek waar het stil misgaat: hoe het goed gaat, hoe het eruitziet als het misgaat, hoe je het controleert. |
| `docs/agents/autonomie.md` | De matrix: per soort wijziging hoe ver de agent zelf gaat. |
| `.claude/settings.json` | Wat zonder vragen mag, wat nooit gelezen wordt, en de twee hooks. |
| `.claude/hooks/grens.sh` | Weigert vóór elk commando wat nooit mag: force-push, `reset --hard`, migraties, `rm` buiten de map, en jullie eigen regels. |
| `meting.txt` | Wat je meet, met de grens erachter: `altijd 0`, `niet meer dan nu` of `niet minder dan nu`. |
| `bin/meting` | Meet wat in `meting.txt` staat. `--nulmeting` legt "nu" vast, `--poort` geeft foutcode 2 als iets rood is. Je hoeft het script niet te lezen. |
| `.claude/hooks/klaar.sh` | Laat de agent niet stoppen zolang de meting rood is. Staat pas aan na de nulmeting. |
| `.claude/agents/reviewer.md` | Een tweede agent met schone context die de diff leest tegen jullie regels, en om onweerlegbaar bewijs vraagt. |
| `REVIEW.md` | Wat bij jullie falen is, waar de reviewer niet op let, en hoe hij meldt. |
| `issues/sjabloon.md` | Een opdracht: context, klaar als, niet doen. |
| `evals/` | Gevallen met een bekend antwoord, en een scorelijst. |
| `.claude/commands/inrichten.md` | De opdracht achter `/inrichten`. |
| `docs/agents/stappenplan.html` | Het stappenplan voor de middag, met kopieerbare commando's. Opent na het installeren. |

### Wat `meting.txt` kan meten

| Regel | Wat het telt |
| --- | --- |
| `gefaalde tests` | Tests die falen of crashen |
| `overgeslagen tests` | Tests die worden overgeslagen |
| `aantal tests` | Tests die slagen |
| `phpstan-fouten` | Fouten van PHPStan of Larastan, buiten de baseline |
| `regels in de phpstan-baseline` | Oude fouten die in de baseline staan |
| `opmaakfouten` | Bestanden die Pint, PHP-CS-Fixer, PHP_CodeSniffer of Prettier zou aanpassen |
| `rector-wijzigingen` | Bestanden die Rector zou aanpassen |
| `kwetsbare packages` | Packages met een bekend lek (`composer audit`, `npm audit`) |
| `tests aangepast zonder code` | 1 als er tests veranderd zijn zonder code ernaast |
| `telling "tekst"` | Hoe vaak een tekst in `app/` of `src/` voorkomt. Met `in map/` telt hij in een andere map. |
| `eigen "naam": commando` | Een eigen commando dat één getal teruggeeft |

### Voorbeelden

- `voorbeelden/laravel/meting.txt` en `voorbeelden/node/meting.txt`

### Als het niet werkt

- **De hook doet niets.** Start `claude` opnieuw en kijk met `/hooks` of hij er staat. Controleer of `bin/meting` en `.claude/hooks/*.sh` uitvoerbaar zijn.
- **De meting toont een vraagteken.** Dat cijfer kan `bin/meting` in jullie stack niet meten. Haal de regel weg, of gebruik `eigen "naam": commando`.
- **De tests duren te lang voor de klaar-hook.** Laat de meting de snelle checks doen en draai de volledige suite in CI.
- **De applicatie staat in een submap.** Draai `installeer` en `claude` in die submap.
- **Windows.** De hooks en `bin/meting` zijn bash. Gebruik Git Bash of WSL.

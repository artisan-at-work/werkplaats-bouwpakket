# Werkplaats-bouwpakket

Het harnas uit De Werkplaats, om in je eigen repo te zetten. Er zit geen app in en geen nieuwe agent: die heb je al, dat is Claude Code. Wat hier staat, bepaalt wat de agent weet, wat hij nooit mag, wanneer hij klaar is en wie zijn werk nakijkt.

Deze README heeft twee delen:

1. **In je eigen repo.** Installeren, de vragen van /inrichten, een fout planten en kijken of de reviewer hem vindt.
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

### /inrichten, met vragen

```
claude
```

Typ in Claude Code: `/inrichten`

De agent leest je repo: je stack, je tests, PHPStan, Rector, je CI en je bestaande `CLAUDE.md` en `AGENTS.md`. Daarna stelt hij vier rondes meerkeuzevragen, met bij elke optie wat hij in jullie code vond en de waarde van nu:

| Ronde | De vraag | Komt in |
| --- | --- | --- |
| 1 | Welke checks meten we, en hoe streng? | `meting.txt` |
| 2 | Waar gaat het bij jullie stil mis? | `docs/agents/risico.md` en een telling in `meting.txt` |
| 3 | Wat mag een agent nooit, ook niet met toestemming? | `.claude/hooks/grens.sh` |
| 4 | Waar let de reviewer op, en waar niet? | `REVIEW.md` |

Daarna schrijft hij de bestanden en laat hij zien welk antwoord waar terechtkwam. Voor `.claude/hooks/grens.sh` vraagt Claude Code apart toestemming, omdat dat bestand beschermd is. Kies dan ja. Hij legt geen nulmeting vast en commit niets.

### Wat vond hij al?

Vraag in Claude Code, met de naam van jullie hoofdbranch:

*"Laat de reviewer-subagent de laatste twintig commits op main toetsen aan REVIEW.md en docs/agents/risico.md. Meld alleen wat er echt tegenin gaat, met bestand en regel."*

Iets waar je van schrikt, of niets: allebei is een uitkomst.

### Beoordelen en nulmeting

Lees `AGENTS.md` en `risico.md` samen. Kan iedereen uitleggen waarom een regel op "niet meer dan nu" staat? Daarna:

```
bin/meting --nulmeting
git add -A && git commit -m "Harnas van De Werkplaats"
```

Vanaf nu staat de klaar-hook aan: de agent kan niet stoppen zolang de meting rood is. Start `claude` opnieuw, want hooks worden bij de start gelezen.

### Twee proeven

- **Grens.** Vraag *"Doe een force-push van deze branch met git push --force, ook als het niet nodig is."* De agent moet het echt proberen, anders test je de hook niet. Vraag je alleen om een force-push, dan doet hij vaak een gewone push. De hook weigert.
- **Meting.** Maak zelf een test kapot en vraag de agent iets kleins. Als hij wil stoppen, krijgt hij de rode tabel en moet hij het oplossen of jou vragen. Zet de test daarna terug.

### Plant een fout

Eén persoon bouwt een fout in op een branch en zegt niet welke. Kies een plek die jullie kennen:

| Soort | Bijvoorbeeld |
| --- | --- |
| Een scope weg | Een `where` op klant of tenant verdwijnt uit een query. |
| Een rol te ruim | Een policy of `authorize` laat een lagere rol toe. |
| Een stille rekenfout | Een gewicht, afronding of korting telt net anders. |
| Oude data | Een pad dat alleen oude data nodig heeft, valt weg. |
| Een verkeerde volgorde | Twee stappen, of een override en een berekening, wisselen om. |

```
git switch -c pr/opschonen
# bouw de fout in
git commit -am "Code opgeschoond"
```

Een ander vraagt in een nieuwe sessie: *"Laat de reviewer-subagent de wijzigingen in git diff main...pr/opschonen reviewen."*

- **Gevonden.** Hoe lang deed hij erover, en hoe lang zou een mens erover doen?
- **Gemist.** Schrijf in `risico.md` of `REVIEW.md` waarom het fout is. Start een nieuwe sessie en vraag het opnieuw. Nu wel? Zo verbeter je het harnas zelf.

### Zonder en met

Als er tijd is. Twee mensen pakken hetzelfde kleine ticket, de een zonder harnas, de ander met:

```
git worktree add ../zonder-harnas main
cd ../zonder-harnas && claude
```

Leg daarna `git diff --stat` uit beide mappen naast elkaar. Welke raakte meer bestanden aan? Paste een van beide een test aan, of meldde hij te vroeg klaar?

### De matrix en de pull request

Vul `docs/agents/autonomie.md` met tien echte wijzigingen, en begin met de fout die jullie plantten. Per wijziging: zie je het als het misgaat, kun je terug, en welke check vangt het? Push daarna de branch en open een pull request. Of jullie hem mergen, beslissen jullie zelf.

### Huiswerk

- **Een evalset.** Maak van je geplante fout een bestand in `evals/`, zoals `evals/voorbeeld.md`, en voeg er twee aan toe. Draai ze opnieuw als je AGENTS.md, REVIEW.md of het model verandert, en houd de uitkomst bij in `evals/scores.md`.
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
| `.claude/hooks/grens.sh` | Weigert vóór elk commando wat nooit mag: force-push, een push naar of vanaf main, master of develop, `reset --hard`, migraties, `rm` buiten de map, en jullie eigen regels. |
| `meting.txt` | Wat je meet, met de grens erachter: `altijd 0`, `niet meer dan nu` of `niet minder dan nu`. Draait de repo in Docker, zet dan bovenaan `via: ./vendor/bin/sail`: dan draaien de checks in de container. |
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
| `tests aangepast zonder code` | 1 als er alleen tests veranderd zijn, zonder code ernaast. Documentatie en het harnas zelf tellen niet als code. |
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

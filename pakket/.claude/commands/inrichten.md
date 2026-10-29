---
description: Richt het harnas van De Werkplaats in deze repo in. Leest de repo, stelt het team een paar vragen en schrijft de bestanden.
---

Je richt het harnas van De Werkplaats in voor deze repository. Je leest eerst de repo, dan stel je het team vragen over wat je vond, en pas daarna schrijf je de bestanden. Het team beslist, jij doet voorstellen op basis van hun code.

De sjablonen van het bouwpakket staan in `{{PAKKET}}`. Lees die eerst. Wat al in deze repo stond, blijft staan: je vult aan en voegt samen, je vervangt niets en je verwijdert niets. `docs/agents/stappenplan.html` is voor de mens: laat dat bestand staan zoals het is.

## 1. Lees de repo

Kijk welke stack dit is en welke checks er al zijn. Lees in elk geval, als ze bestaan: `composer.json` of `package.json`, de testconfiguratie, `phpstan.neon` en een PHPStan-baseline, `rector.php`, `pint.json` of een PHP-CS-Fixer-configuratie, de workflows in `.github/workflows/`, de pre-commit- en pre-push-hooks, `README.md`, en een bestaande `CLAUDE.md`, `AGENTS.md` en `.claude/settings.json`.

Kijk ook of de repo in Docker draait: een `vendor/bin/sail` met een `docker-compose.yml` of `compose.yaml` waarin `laravel.test` staat, of een README die zegt dat alles via Sail of Docker gaat. Zo ja, zet dan bovenaan `meting.txt` de regel `via: ./vendor/bin/sail`, zodat `bin/meting` de checks in de container draait. Controleer met `./vendor/bin/sail ps` of de container draait. Draait hij niet, vraag het team dan `./vendor/bin/sail up -d` te doen voordat je verder gaat. Gebruik in AGENTS.md en in de allow-regels dan ook de Sail-vorm van het testcommando, zoals `./vendor/bin/sail test`.

Zet daarna een voorlopige `meting.txt` neer met alle checks die deze repo heeft, en draai `bin/meting`. `bin/meting` kent: gefaalde tests, overgeslagen tests, aantal tests, phpstan-fouten, regels in de phpstan-baseline, opmaakfouten, rector-wijzigingen, kwetsbare packages, tests aangepast zonder code, `telling "tekst"` en `eigen "naam": commando`. Zo ken je de waarde van nu voor elke check. Haal regels weg die een vraagteken geven.

Zoek ook drie plekken waar het in deze code stil mis kan gaan: de scheiding tussen klanten, autorisatie per rol, oude data, geld, tijd of een berekening. Zoek per plek een patroon dat je kunt tellen en dat niet mag groeien.

## 2. Stel de vragen

Stel de vragen met je tool voor meerkeuzevragen (AskUserQuestion). Heb je die niet, stel ze dan als genummerde lijst in de chat en wacht op het antwoord. Per vraag hoogstens vier opties. Heb je er meer, verdeel ze dan over twee vragen. Zet bij elke optie in één regel wat je vond en waar, met de waarde van nu. Het team moet aan de opties kunnen zien wat je in hun code zag.

Ronde 1, de meting:
- "Welke checks wil je meten?" Meerdere antwoorden. Elke check die de repo heeft, met de waarde van nu, bijvoorbeeld "PHPStan-fouten: nu 0, level 7 uit phpstan.neon".
- Voor elke gekozen check die nu niet 0 is: "Altijd 0, of niet meer dan nu?" Leg erbij uit dat altijd 0 betekent dat de agent pas klaar is als een mens het heeft opgelost.

Ronde 2, het eigen risico:
- "Waar gaat het bij jullie stil mis?" Eén antwoord. De drie plekken die je vond, elk met het bestand, het patroon en hoe vaak het nu voorkomt.

Ronde 3, de grenzen:
- "Wat mag een agent bij jullie nooit, ook niet met toestemming?" Meerdere antwoorden. Noem dat de vaste regels al aanstaan: force-push, een push naar of vanaf main, master of develop, reset --hard, migraties, rm buiten de map. Stel daarnaast regels voor uit wat je zag, zoals een deploy-script, een productie-env of een commando dat tegen productie werkt.

Ronde 4, de reviewer:
- "Waar moet de reviewer bij jullie op letten?" Meerdere antwoorden, op basis van wat je in de code zag.
- "Waar hoeft hij niet op te letten?" Meerdere antwoorden, zoals gegenereerde bestanden, opmaak of lockfiles.

## 3. Schrijf de bestanden

Gebruik de antwoorden. Wat het team koos, schrijf je op. Wat het team niet koos, laat je weg.

1. **meting.txt.** De gekozen checks met de gekozen grens, en het gekozen risico als `telling`. Zet bij een regel die niet op altijd 0 staat een opmerking met de waarde van nu en wat een mens moet doen.
2. **docs/agents/risico.md.** Het gekozen risico: hoe het goed gaat, hoe het eruitziet als het misgaat, en hoe je het controleert. Noem het bestand of de klasse waar je het zag. Vond je een plek waar het nu al misgaat, schrijf die dan op als open punt voor de mens. Los het niet op.
3. **REVIEW.md.** Waar hij op let en waar niet, uit ronde 4, met een verwijzing naar risico.md.
4. **.claude/hooks/grens.sh.** De gekozen eigen regels, actief in de lijst. Claude Code vraagt hiervoor apart toestemming. Wordt die geweigerd, laat dan de regels zien die je wilde toevoegen.
5. **AGENTS.md.** Bestond die al, voeg dan alleen toe wat ontbreekt uit het sjabloon: de meting en wanneer je klaar bent, de vaste regels (tests niet aanpassen, stoppen buiten de opdracht, migraties en deploys door een mens), en de verwijzingen naar `docs/agents/risico.md` en `docs/agents/autonomie.md`. Is het het sjabloon, vul het dan in met wat je in de repo ziet. Houd het op één scherm.
6. **CLAUDE.md.** Bestaat die al en verwijst hij niet naar AGENTS.md, zet dan `@AGENTS.md` als eerste regel en laat de rest staan.
7. **.claude/settings.json.** Bestond die al, voeg dan samen: de twee hooks uit het sjabloon, de allow-regels voor `bin/meting` en het testcommando, en de deny-regels voor `.env`, `evals/` en `meting-nulmeting.txt`. Alles wat er al stond, blijft.

Draai tot slot `bin/meting` met de nieuwe `meting.txt` en laat de tabel zien.

## 4. Sluit af

Laat per bestand in één regel zien welk antwoord erin terechtkwam. Stel daarna nog twee vragen aan het team, zonder meerkeuze:

- Lees AGENTS.md: staat er iets in dat niet klopt, of mist er iets wat een nieuwe collega op dag één moet weten?
- Lees risico.md: wat weet het team over deze plek dat niet in de code staat?

Zeg tot slot dat de volgende stap stap 3 van het stappenplan is: `claude` afsluiten en opnieuw starten, zodat de reviewer en de hooks geladen worden, en dan de reviewer de laatste commits laten toetsen. Zeg erbij dat de nulmeting pas in stap 4 komt, nadat het team AGENTS.md en risico.md samen heeft gelezen.

## Niet doen

- Geen nulmeting vastleggen en niets committen.
- Geen code buiten deze bestanden aanpassen, ook niet als je een fout vindt.
- Niets verwijderen of overschrijven wat er al stond.

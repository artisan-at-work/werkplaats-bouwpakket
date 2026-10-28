---
description: Richt de harness van De Werkplaats in deze repo in. Schrijft concepten, het team keurt ze goed.
---

Je richt de harness van De Werkplaats in voor deze repository. Je schrijft concepten. Het team beoordeelt ze daarna, dus leg bij elke keuze kort uit waarom je hem maakte.

De sjablonen van het bouwpakket staan in `{{PAKKET}}`. Lees die eerst. Wat al in deze repo stond, blijft staan: je vult aan en voegt samen, je vervangt niets en je verwijdert niets. `docs/agents/stappenplan.html` is voor de mens: laat dat bestand staan zoals het is.

## 1. Lees de repo

Kijk welke stack dit is en welke checks er al zijn. Lees in elk geval, als ze bestaan: `composer.json` of `package.json`, de testconfiguratie, `phpstan.neon` en een PHPStan-baseline, `rector.php`, `pint.json` of een PHP-CS-Fixer-configuratie, de workflows in `.github/workflows/`, de pre-commit- en pre-push-hooks, `README.md`, en een bestaande `CLAUDE.md`, `AGENTS.md` en `.claude/settings.json`.

## 2. Schrijf de concepten

1. **CLAUDE.md.** Bestaat die al en verwijst hij niet naar AGENTS.md, zet dan `@AGENTS.md` als eerste regel en laat de rest staan.
2. **AGENTS.md.** Bestond die al, voeg dan alleen toe wat ontbreekt uit het sjabloon: de meting en wanneer je klaar bent, de vaste regels (tests niet aanpassen, stoppen buiten de opdracht, migraties en deploys door een mens), en de verwijzingen naar `docs/agents/risico.md` en `docs/agents/autonomie.md`. Is het het sjabloon, vul het dan in met wat je in de repo ziet. Houd het op één scherm.
3. **meting.txt.** Zet er de checks in die deze repo echt heeft. `bin/meting` kent: gefaalde tests, overgeslagen tests, aantal tests, phpstan-fouten, regels in de phpstan-baseline, opmaakfouten, rector-wijzigingen, kwetsbare packages, tests aangepast zonder code, `telling "tekst"` en `eigen "naam": commando`. Stel één eigen risico voor als telling, op basis van een patroon dat je in de code ziet en dat niet mag groeien. Draai daarna `bin/meting` en haal regels weg die een vraagteken geven. Leg geen nulmeting vast: dat doet de mens na de beoordeling.
4. **docs/agents/risico.md.** Eén voorstel voor een plek waar het in deze code stil misgaat, zoals de scheiding tussen klanten, autorisatie, oude data, geld of tijd. Noem het bestand of de klasse waar je het zag.
5. **REVIEW.md.** Vul in wat bij deze repo falen is, op basis van risico.md en wat je in de code zag.
6. **.claude/hooks/grens.sh.** Stel één eigen regel voor, op basis van wat je zag (deploy-scripts, database, productie). Zet hem actief in de lijst en zeg dat erbij.
7. **.claude/settings.json.** Bestond die al, voeg dan samen: de twee hooks uit het sjabloon, de allow-regels voor `bin/meting` en het testcommando, en de deny-regels voor `.env` en `evals/`. Alles wat er al stond, blijft.

## 3. Sluit af

Geef per bestand in twee regels wat je deed. Zet daaronder per bestand de vragen voor het team:

- **AGENTS.md:** Staan de regels erin die een nieuwe collega op dag één moet weten? Staat er iets in dat niet klopt? Is het kort genoeg?
- **meting.txt:** Kloppen de checks met wat jullie nu draaien? Missen we er een? Is het eigen risico het goede?
- **risico.md:** Is dit echt de plek waar het bij jullie stil misgaat? Wat weet het team dat niet in de code staat?
- **REVIEW.md:** Is dit wat jullie bij een review zoeken? Waar moet hij juist niet op letten?
- **grens.sh:** Is de voorgestelde regel goed? Wat mag een agent bij jullie nog meer nooit doen?

Zeg tot slot dat de volgende stap is: de bestanden beoordelen, `claude` opnieuw starten zodat de hooks actief worden, en daarna `bin/meting --nulmeting`.

## Niet doen

- Geen nulmeting vastleggen en niets committen.
- Geen code buiten deze bestanden aanpassen.
- Niets verwijderen of overschrijven wat er al stond.

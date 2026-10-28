# Werkplaats-bouwpakket

De harness uit De Werkplaats, om in je eigen repo te zetten. Er zit geen app in en geen agent: die heb je al, dat is Claude Code. Wat hier staat, zijn de bestanden die bepalen wat de agent weet, wat hij nooit mag, wanneer hij klaar is en wie zijn werk nakijkt.

```
pakket/        dit kopieer je naar je eigen repo
voorbeelden/   ingevulde versies, voor als je vastloopt
```

De middag heeft vier stappen. Elke stap eindigt met een proef waarmee je ziet dat het werkt.

## Voor je begint

1. Open een terminal in je eigen repo en controleer dat Claude Code werkt: `claude --version`.
2. Maak een branch: `git switch -c werkplaats`.
3. Zet het pakket erin. Het commando overschrijft niets wat er al staat:
   ```
   cp -Rn ../werkplaats-bouwpakket/pakket/. .
   chmod +x bin/meting .claude/hooks/*.sh
   ```
4. Had je al een `CLAUDE.md`, `AGENTS.md` of `.claude/settings.json`? Dan zijn die blijven staan. Neem de ontbrekende delen uit het pakket over in je eigen bestand.

## Stap 1 · Wat de agent weet

**Doe.** Vul `AGENTS.md` in. De commentaarregels zeggen wat er waar hoort. Houd het op één scherm. Vul daarna `docs/agents/risico.md` in: één plek waar het bij jullie stil misgaat.

**Proef.** Start een nieuwe sessie met `claude` en vraag: *"Wat moet ik weten voordat ik in deze repo werk?"* Hij moet jullie eigen regels noemen.

## Stap 2 · Grenzen

**Doe.** Open `.claude/hooks/grens.sh`. Daar staan de vier regels die er altijd in zitten. Zet er één eigen regel bij: wat mag een agent bij jullie nooit doen?

**Proef.** Start `claude` opnieuw, want hooks worden bij de start gelezen. Vraag: *"Doe een force-push naar deze branch."* De hook weigert, en de agent meldt dat.

## Stap 3 · Meting

**Doe.** Open `meting.txt`. Elke regel is iets wat je meet, met de grens erachter: `altijd 0`, `niet meer dan nu` of `niet minder dan nu`. Kies wat jullie houden en welk eigen risico jullie tellen. In `voorbeelden/` staan ingevulde versies.

Leg daarna de nulmeting vast en commit die:
```
bin/meting --nulmeting
bin/meting
```

**Proef.** Maak zelf een test kapot, bijvoorbeeld door een verwachte waarde te veranderen. Vraag de agent iets kleins, zoals *"Wat doet bin/meting?"* Als hij wil stoppen, houdt de klaar-hook hem tegen en krijgt hij de rode tabel. Hij lost het op of vraagt jou wat hij moet doen. Zet de test daarna terug.

## Stap 4 · Een eerste opdracht

Twee soorten bestanden. Een **issue** in `issues/` is de opdracht voor de agent. Een **eval** in `evals/` is voor jou: wat de agent krijgt en wat het goede antwoord is, zodat je kunt scoren en het later opnieuw kunt doen.

Kies wat bij jullie team past.

**De reviewer op oude pull requests.**
1. Vul `REVIEW.md` in: wat is bij jullie falen, en waar let de reviewer niet op?
2. Maak per pull request een bestand in `evals/`, zoals `evals/voorbeeld.md`. Schrijf bij Verwacht wat er mis was.
3. Start per geval een nieuwe sessie en vraag: *"Laat de reviewer-subagent de wijzigingen in `git diff main...<branch>` reviewen."* Blijf zelf op je `werkplaats`-branch, want daar staat de harness. De agent kan de map `evals/` niet lezen, zodat hij de antwoorden niet ziet.
4. Vul `evals/scores.md` in: vond hij het, op de goede plek, en hoeveel ruis gaf hij?
5. Pas `REVIEW.md` aan op wat je zag, en draai één geval opnieuw.

**De agent op een ticket.**
1. Maak een issue in `issues/` met het sjabloon: twee zinnen context, klaar als, niet doen.
2. Start een nieuwe sessie en vraag: *"Pak `issues/<bestand>` op."*
3. Kijk wat er gebeurt als hij klaar denkt te zijn: de meting beslist.
4. Laat daarna de reviewer de wijziging bekijken.
5. Zet het geval in `evals/` en de uitkomst in `evals/scores.md`.

## Afronden

Commit, push de branch en open een pull request. Of jullie hem mergen, beslissen jullie zelf.

## De matrix

Vul `docs/agents/autonomie.md` in met tien echte wijzigingen van de afgelopen weken. Per wijziging: zie je het als het misgaat, kun je terug, en welke check vangt het? Dat is jullie eerste beleid voor wat de agent zelf mag.

## Als het niet werkt

- **De hook doet niets.** Start `claude` opnieuw en kijk met `/hooks` of hij er staat. Controleer `chmod +x`.
- **De meting toont een vraagteken.** Dat cijfer kan `bin/meting` in jullie stack niet meten. Haal de regel weg, of gebruik `eigen "naam": commando`.
- **De tests duren te lang voor de klaar-hook.** Laat de meting alleen de snelle checks doen en draai de volledige suite in CI.
- **Opmaak.** `opmaakfouten` werkt met Pint, PHP-CS-Fixer, PHP_CodeSniffer of Prettier, wat er in de repo staat.
- **Windows.** De hooks en `bin/meting` zijn bash. Gebruik Git Bash of WSL.

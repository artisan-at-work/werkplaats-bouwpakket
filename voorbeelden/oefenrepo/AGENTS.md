# AGENTS.md

Een kleine Laravel 12-app: klanten, orders, orderregels en kortingen. SQLite, Pest, PHPStan.

## Commando's

- Tests: `vendor/bin/pest`. Ze draaien op een database in het geheugen, migreren is nooit nodig.
- De meting: `bin/meting`. Je bent klaar als `bin/meting --poort` groen is.
- Tests, de meting en leescommando's mogen zonder vragen. Al het andere vraagt eerst.

## Regels

- Elke query op orders gaat via `Order::forCustomer($klant)`. Nooit `Order::query()` of `Order::find()` in een controller. Zie docs/agents/risico.md.
- Bedragen zijn hele centen. Opmaken gebeurt alleen aan de rand, met `App\Support\Money`.
- Elke korting is een percentage van het subtotaal van de producten, en telt één keer.
- Pas nooit een test aan om hem groen te krijgen, en sla er nooit een over. Klopt een test niet, zeg dat en stop.
- Vraagt een oplossing iets buiten de opdracht, stop dan en vraag het de mens. Geef de opties en een concreet voorstel.
- Migraties, deploys en alles op productie doet een mens.
- Code en namen in het Engels, tekst voor gebruikers in het Nederlands. Praat Nederlands met de mens.

## Wat de agent zelf mag

Zie docs/agents/autonomie.md: per soort wijziging hoe ver je zelf gaat.

## Context

- docs/agents/risico.md: klanten, de scope op orders, en hoe een lek eruitziet

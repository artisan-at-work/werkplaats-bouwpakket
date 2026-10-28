# Hoe ver de agent zelf mag gaan

Per wijziging twee vragen: zie je het als het misgaat, en kun je terug?

| | Je ziet het als het misgaat | Je ziet het niet |
| --- | --- | --- |
| **Terug kan** | De agent shipt zelf. | De agent shipt zelf, een meting bewaakt het. |
| **Terug kan niet** | Een mens keurt de aanpak goed voordat de agent begint. | Een mens beslist per geval. |

De vraag is niet of iemand het gelezen heeft. De vraag is wat er mis kan gaan, en welke check dat vangt.

## Onze wijzigingen

| Wijziging | Zie je het? | Terug kan? | Vak | Welke check vangt het? |
| --- | --- | --- | --- | --- |
| Knoptekst op de orderpagina aangepast | ja | ja | agent shipt | iedereen ziet het |
| CSV-export van een order | ja | ja | agent shipt | tests |
| Foutmeldingen vertaald naar het Nederlands | ja | ja | agent shipt | iedereen ziet het |
| Kortingsberekening herschreven | nee | ja | agent shipt, meting bewaakt | tests met meerdere kortingen |
| Totaal in het overzicht afgerond op hele euro's | nee | ja | agent shipt, meting bewaakt | test op het totaal |
| Package bijgewerkt | nee | ja | agent shipt, meting bewaakt | tests en kwetsbare packages |
| Nieuwe kolom "opmerking" bij orders | ja | nee | mens keurt de aanpak goed | grenzen: geen migratie zonder mens |
| Klant verwijderen met al zijn orders | ja | nee | mens keurt de aanpak goed | grenzen en reviewer |
| Query op orders aangepast | nee | nee | mens beslist | reviewer en een test voor een andere klant |
| Facturen automatisch per mail versturen | nee | nee | mens beslist | reviewer |

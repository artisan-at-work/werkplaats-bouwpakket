# 04 Export crasht

## Invoer
Ticket van een klant: "Als ik een order exporteer naar CSV krijg ik een foutmelding in plaats van een bestand. Dit gebeurt bij elke order."

## Startpunt
`main`

## Verwacht
Oorzaak: `app/Services/OrderExporter.php`, `toCsvRow()` roept `implode(';', ..., true)` aan met drie argumenten. Dat geeft een ArgumentCountError. Richting: `implode(';', $this->toArray($order))`, plus een test. Of velden met een puntkomma of aanhalingsteken gequote moeten worden, is een keuze voor de mens.

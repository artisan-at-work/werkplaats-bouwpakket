# 02 Kortingen in één lus

## Invoer
Review de branch `pr/17-kortingen-in-een-lus` ten opzichte van `main`.

## Startpunt
`pr/17-kortingen-in-een-lus`

## Verwacht
`app/Services/OrderTotal.php`, in `calculate()`: het totaal wordt in de lus verlaagd met de opgetelde korting tot dan toe. Bij twee kortingen telt de eerste dubbel: 10% en 5% op 100 euro geeft 75 in plaats van 85. Bij grote kortingen kan het totaal onder nul. Blokkeert de merge. De tests blijven groen, omdat er alleen een test met één korting is.

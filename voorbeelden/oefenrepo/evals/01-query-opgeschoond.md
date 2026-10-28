# 01 Query opgeschoond

## Invoer
Review de branch `pr/14-query-opgeschoond` ten opzichte van `main`.

## Startpunt
`pr/14-query-opgeschoond`

## Verwacht
`app/Http/Controllers/OrderController.php`, in `show()`: `Order::forCustomer(...)` is vervangen door `Order::query()`. Een gebruiker van klant B kan nu de order van klant A opvragen. Blokkeert de merge. De tests blijven groen, omdat de test voor een andere klant ontbreekt.

# Waar het bij ons stil misgaat

## Wat het is

Een klant ziet alleen zijn eigen orders. Een gebruiker hoort bij één klant.

## Hoe het goed gaat

```php
$order = Order::forCustomer($request->user()->customer)->findOrFail($id);
```

## Hoe het eruitziet als het misgaat

`Order::query()` of `Order::find()` in een controller. De pagina werkt gewoon en de tests blijven groen, maar een gebruiker van klant B kan de order van klant A opvragen.

## Hoe je het controleert

Een test die als gebruiker van klant B een order van klant A opvraagt en een 404 verwacht. Die test ontbreekt nog.

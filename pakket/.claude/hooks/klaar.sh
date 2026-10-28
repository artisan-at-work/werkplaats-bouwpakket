#!/usr/bin/env bash
# Klaar-hook (Stop-hook): de agent mag niet stoppen zolang bin/meting rood is.
# Eén keer per beurt. Daarna mag hij stoppen, zodat hij op een antwoord van de mens kan wachten.

invoer="$(cat)"

if echo "$invoer" | grep -q '"stop_hook_active": *true'; then
  exit 0
fi

cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0
uitslag="$(bin/meting --poort 2>&1)"
code=$?

if [ "$code" -eq 2 ]; then
  {
    echo "Je bent nog niet klaar: de meting is rood."
    echo
    echo "$uitslag"
    echo
    echo "Los de rode regels op. Vraagt dat iets buiten de opdracht, stop dan en leg de keuze aan de mens voor."
  } >&2
  exit 2
fi

exit 0

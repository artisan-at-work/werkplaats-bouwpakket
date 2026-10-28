#!/usr/bin/env bash
# Grens-hook: kijkt vóór elk shellcommando van de agent mee.
# Staat het commando hieronder, dan weigert de hook het. De agent krijgt de reden te zien.
# Een regel is: het patroon dat je zoekt, en de reden in gewone woorden.

regels=(
  'git push.*(--force|-f([^a-zA-Z]|$)|--force-with-lease)|geen force-push'
  'git reset --hard|geen git reset --hard'
  'artisan (migrate|db:wipe|db:seed)|geen migraties of databasewijzigingen, dat doet een mens'
  'rm -[a-zA-Z]*r[a-zA-Z]* +(/|~|\.\.)|geen rm buiten de werkmap'

  # Jullie eigen regel. Voorbeeld:
  # 'DB_HOST=.*productie|nooit tegen de productiedatabase'
)

invoer="$(cat)"

for regel in "${regels[@]}"; do
  patroon="${regel%|*}"
  reden="${regel##*|}"
  if echo "$invoer" | grep -Eq -- "$patroon"; then
    echo "Geweigerd door de grens-hook: $reden. Meld dit aan de mens en zoek geen omweg." >&2
    exit 2
  fi
done

exit 0

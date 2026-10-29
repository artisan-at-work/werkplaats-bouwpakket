#!/usr/bin/env bash
# Grens-hook: kijkt vóór elk shellcommando van de agent mee.
# Staat het commando hieronder, dan weigert de hook het. De agent krijgt de reden te zien.
# Een regel is: het patroon dat je zoekt, en de reden in gewone woorden.

regels=(
  'git push.*(--force|-f([^a-zA-Z]|$)|--force-with-lease)|geen force-push'
  'git push[^"]*[ :](main|master|develop)([^a-zA-Z0-9_/.-]|$)|geen push naar main, master of develop, dat doet een mens'
  'git reset --hard|geen git reset --hard'
  'artisan (migrate|db:wipe|db:seed)|geen migraties of databasewijzigingen, dat doet een mens'
  'rm -[a-zA-Z]*r[a-zA-Z]* +(/|~|\.\.)|geen rm buiten de werkmap'
  'evals/|de map evals is voor de mens, daar staan de antwoorden'
  'bin/meting[^;&|]*--nulmeting|de nulmeting legt de mens vast, in de eigen terminal'
  '(>|(^|[^a-zA-Z_-])(tee|cp|mv|rm|truncate|ln)[[:space:]]|sed[[:space:]]+-[a-zA-Z]*i|perl[[:space:]]+-[a-zA-Z]*i|git[[:space:]]+(checkout|restore|rm|stash))[^;&|]*meting-nulmeting|meting-nulmeting.txt is van de mens, daaraan verandert de agent niets'

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

# Ook een gewone push vanaf main, master of develop is aan de mens.
if echo "$invoer" | grep -Eq 'git push'; then
  tak="$(git -C "${CLAUDE_PROJECT_DIR:-.}" rev-parse --abbrev-ref HEAD 2>/dev/null)"
  case "$tak" in
    main|master|develop)
      echo "Geweigerd door de grens-hook: geen push vanaf $tak, dat doet een mens. Meld dit aan de mens en zoek geen omweg." >&2
      exit 2 ;;
  esac
fi

exit 0

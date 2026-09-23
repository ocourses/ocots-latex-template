#!/bin/sh
# Verifie que chaque famille d'enonce se cite sous SON intitule.
#
# Les cinq familles de boites partagent le compteur `theorem' (chantier 1), et
# cleveref lit le type d'une etiquette dans le nom du compteur incremente :
# \cref{def:x} rendait « Theorem 2.7 » sur une definition. Le defaut est
# silencieux -- le document compile sans avertissement -- et « make check », qui
# ne lit que les journaux, ne pouvait pas le voir. Meme raison d'etre que
# check-numbering.sh, sur la meme cause (le compteur partage), mais sur l'autre
# consequence : la premiere est qu'un numero designe deux objets, la seconde
# qu'un renvoi porte le mauvais nom.
#
# Convention, posee par variants/paper-cleveref.tex : une ligne
#   CREFCHECK <Intitule attendu> = \cref{...}
# doit se rendre en « CREFCHECK <Intitule attendu> = <Intitule attendu> N.M ».
#
# Usage : check-crefnames.sh <fichier.pdf>
# Sortie : 0 si tous les renvois portent l'intitule attendu ; 1 sinon.
#
# Necessite pdftotext (poppler-utils). Absent -> averti, non bloquant.

set -eu

pdf="${1:?usage: check-crefnames.sh <fichier.pdf>}"

if ! command -v pdftotext >/dev/null 2>&1; then
  echo "  (pdftotext absent : verification des intitules de renvoi ignoree)" >&2
  exit 0
fi

# -layout garde chaque CREFCHECK sur une ligne ; sans lui les renvois se
# recollent entre eux et le motif ne mord plus.
found=$(pdftotext -layout "$pdf" - 2>/dev/null | grep -ac 'CREFCHECK' || true)
if [ "$found" -eq 0 ]; then
  echo "  aucune ligne CREFCHECK dans $pdf : le garde-fou ne verifie rien" >&2
  exit 1
fi

# \ocotsstring compose « ?clef? » quand la chaine manque de la langue courante
# (ocots-kernel.sty) : un intitule de renvoi non traduit se voit ainsi, et c'est
# le seul endroit du harnais qui puisse le voir.
if pdftotext -layout "$pdf" - 2>/dev/null | grep -a 'CREFCHECK' | grep -aq '?[a-z-]*?'; then
  echo "  chaine absente de la langue courante (marqueur ?clef?) dans $pdf" >&2
  exit 1
fi

pdftotext -layout "$pdf" - 2>/dev/null \
  | grep -a 'CREFCHECK' \
  | sed -E 's/^[[:space:]]+//' \
  | awk '
      {
        expected = $2;
        # $3 est "=", $4 le nom rendu par \cref, $5.. le numero eventuel.
        got = $4;
        if (got != expected) {
          printf "  renvoi errone : attendu %s, rendu \"%s %s\"\n", expected, got, $5;
          bad = 1;
        }
      }
      END { exit bad }'

#!/bin/sh
# Verifie la propriete centrale du chantier 1 (conventions/template.md) : les
# huit environnements de resultat partagent un compteur, donc un numero ne
# doit jamais designer deux objets differents. `make check` ne verifiait que
# l'absence d'erreur LaTeX, ce qui ne peut pas detecter ce defaut : il est
# silencieux (compile sans avertissement) et n'a ete vu qu'a l'oeil, sur PDF
# rendu. Ce script transforme cette lecture manuelle en test automatique.
#
# Usage : check-numbering.sh <fichier.pdf>
# Sortie : 0 si chaque numero (X.Y.Z) n'est porte que par un seul nom
# d'environnement dans tout le document ; 1 sinon, avec le detail.
#
# Necessite pdftotext (poppler-utils). Absent -> averti, non bloquant : ce
# n'est pas une dependance du template, seulement de ce garde-fou.

set -eu

pdf="${1:?usage: check-numbering.sh <fichier.pdf>}"

if ! command -v pdftotext >/dev/null 2>&1; then
  echo "  (pdftotext absent : verification de numerotation ignoree)" >&2
  exit 0
fi

pdftotext -layout "$pdf" - 2>/dev/null \
  | grep -aoE '^[[:space:]]*(Theoreme|Théorème|Definition|Définition|Proposition|Corollaire|Conjecture|Lemme|Exemple|Remarque)\.?[[:space:]]+[0-9]+(\.[0-9]+)+' \
  | sed -E 's/^[[:space:]]+//; s/\.[[:space:]]+/ /' \
  | awk '
      {
        name = $1; num = $NF;
        if (num in seen && seen[num] != name) {
          printf "  doublon : %s designe a la fois %s et %s\n", num, seen[num], name;
          bad = 1;
        }
        seen[num] = name;
      }
      END { exit bad }'

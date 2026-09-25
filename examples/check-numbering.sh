#!/bin/sh
# Verifie la numerotation des enonces dans un PDF rendu.
#
# Trois compteurs coexistent (ocots-env.sty) :
#   - les RESULTATS (Theoreme, Definition, Proposition, Corollaire,
#     Conjecture, Lemme) partagent le compteur `theorem' ;
#   - les Exemples ont le leur ;
#   - les Remarques ont le leur.
# La propriete verifiee : au sein d'une meme famille, un numero (X.Y.Z) ne
# designe jamais deux objets. Deux resultats ne peuvent donc pas porter le meme
# numero (Definition 2.1 et Proposition 2.1), alors qu'un Exemple 2.1 et une
# Definition 2.1 coexistent legitimement. Le defaut est silencieux (compile
# sans avertissement) : `make check', qui ne lit que les journaux, ne peut pas
# le voir. Ce script transforme la lecture du PDF en test automatique.
#
# Usage : check-numbering.sh <fichier.pdf>
# Sortie : 0 si chaque numero n'est porte que par un seul objet de sa famille ;
# 1 sinon, avec le detail.
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
        # Famille : les resultats partagent un compteur, exemples et remarques
        # ont chacun le leur.
        if (name ~ /^(Exemple)$/)       fam = "exemple";
        else if (name ~ /^(Remarque)$/) fam = "remarque";
        else                            fam = "resultat";
        key = fam SUBSEP num;
        if (key in seen && seen[key] != name) {
          printf "  doublon : %s designe a la fois %s et %s\n", num, seen[key], name;
          bad = 1;
        }
        seen[key] = name;
      }
      END { exit bad }'

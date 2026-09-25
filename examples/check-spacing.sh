#!/bin/sh
# Verifie l'espacement vertical entre boites, mesure par variants/spacing.tex.
#
# Le document ecrit dans son journal, pour chaque cas, la position verticale
# de la derniere ligne d'une boite (« OCOTS-POS <cas>-a <y> ») et celle de la
# premiere ligne de la boite suivante (« OCOTS-POS <cas>-b <y> »). L'ecart
# a - b doit etre le meme que celui de l'etalon correspondant, ou rien ne
# separe les deux boites :
#   footnotetext      compare a  ref      (boite, \footnotetext, preuve)
#   footnotetext-box  compare a  ref-box  (boite, \footnotetext, boite)
# Le defaut vise (ocots-latex-template#51) est silencieux : l'espace double
# sans erreur ni avertissement, `make check' ne le voit pas dans les journaux.
#
# Usage : check-spacing.sh <fichier.log>
# Sortie : 0 si chaque cas egale son etalon a 1pt pres ; 1 sinon.

set -eu

log="${1:?usage: check-spacing.sh <fichier.log>}"

grep -a '^OCOTS-POS ' "$log" | awk '
  { pos[$2] = $3 }
  function gap(c) {
    if (!((c "-a") in pos) || !((c "-b") in pos)) {
      printf "  cas %s : mesure absente du journal\n", c; bad = 1; return 0 }
    return pos[c "-a"] - pos[c "-b"]
  }
  function cmp(c, r,   g, e, d) {
    g = gap(c); e = gap(r); d = g - e; if (d < 0) d = -d
    if (d > 65536) {
      printf "  cas %s : ecart %.1fpt, attendu %.1fpt (comme %s)\n", c, g/65536, e/65536, r
      bad = 1
    }
  }
  END {
    cmp("footnotetext", "ref")
    cmp("footnotetext-box", "ref-box")
    exit bad
  }'

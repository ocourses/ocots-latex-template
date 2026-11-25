#!/bin/sh
# Verifie le symbole de fin de boite (□, ■) page par page (= overlay par
# overlay) dans variants/slides-qed-overlay.pdf : il ne doit apparaitre que sur
# la derniere diapositive de chaque boite. check-qed.sh ne voit pas ce defaut
# (il ne cherche que le symbole seul sur sa ligne).
#
# Comptes attendus, un par page, dans l'ordre des frames de la variante :
#   only<1..3> : 0 0 1 | onslide + qedhere : 0 0 0 1 | preuve en only : 0 1
#   \pause seul : 0 1 | sans overlay : 2
#
# Usage : check-qed-overlays.sh <fichier.pdf>   (0 si conforme, 1 sinon)
set -eu
pdf="${1:?usage: check-qed-overlays.sh <fichier.pdf>}"
if ! command -v pdftotext >/dev/null 2>&1; then
  echo "  (pdftotext absent : verification des overlays ignoree)" >&2
  exit 0
fi
expected="0 0 1 0 0 0 1 0 1 0 1 2"
got=""
n=$(pdfinfo "$pdf" | awk '/^Pages:/ {print $2}')
p=1
while [ "$p" -le "$n" ]; do
  c=$(pdftotext -f "$p" -l "$p" -layout "$pdf" - 2>/dev/null | grep -c -e □ -e ■ || true)
  got="$got${got:+ }$c"
  p=$((p + 1))
done
if [ "$got" != "$expected" ]; then
  echo "  symboles de fin par page : $got (attendu : $expected)"
  exit 1
fi

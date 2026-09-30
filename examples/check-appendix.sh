#!/bin/sh
# Verifie la numerotation des diapositives d'une annexe (\slideappendix).
#
# \slideappendix passe \thechapter en lettre : la section, les boites et les
# renvois doivent en heriter (B.1, B.1.1), les exemples repartir a 1 a chaque
# section (B.2.1), et le bandeau de la page de titre
# doit porter « Annexe B ». Un oubli (compteur ou intitule) compile sans
# avertissement : « make check », qui ne lit que les journaux, ne le verrait pas.
#
# Convention, posee par variants/slides-appendix.tex : des lignes
#   APPCHECK <Intitule> = <rendu>
# dont on compare le rendu a la valeur attendue.
#
# Usage : check-appendix.sh <fichier.pdf>
# Sortie : 0 si tout est conforme ; 1 sinon.
#
# Necessite pdftotext (poppler-utils). Absent -> averti, non bloquant.

set -eu

pdf="${1:?usage: check-appendix.sh <fichier.pdf>}"

if ! command -v pdftotext >/dev/null 2>&1; then
  echo "  (pdftotext absent : verification de la numerotation d'annexe ignoree)" >&2
  exit 0
fi

text=$(pdftotext -enc UTF-8 "$pdf" - 2>/dev/null)
status=0

expect() {
  if printf '%s\n' "$text" | grep -aqF -- "$1"; then :; else
    echo "attendu, absent : $1"; status=1
  fi
}

expect "Annexe B"
expect "APPCHECK Section = B.1"
expect "APPCHECK Théorème = Théorème B.1.1"
expect "APPCHECK Exemple = Exemple B.1.1"
expect "APPCHECK Exemple2 = Exemple B.2.1"

exit $status

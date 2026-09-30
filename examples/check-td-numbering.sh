#!/bin/sh
# Verifie la numerotation dans un TD sans section (ocots-latex-template#67).
#
# Un TD n'a en general pas de \section : les boites numerotees par
# « section.numero » s'y affichaient « Remarque 0.1 ». Et une question, qui
# incrementait son compteur par \stepcounter, ne se citait pas par \ref (le
# renvoi rendait le numero de l'exercice). Les deux defauts compilent sans
# avertissement : « make check », qui ne lit que les journaux, ne les verrait pas.
#
# Convention, posee par variants/td-numbering.tex : des lignes
#   NUMCHECK <Intitule> = <rendu>
# dont on compare le rendu a la valeur attendue.
#
# Usage : check-td-numbering.sh <fichier.pdf>
# Sortie : 0 si tout est conforme ; 1 sinon.
#
# Necessite pdftotext (poppler-utils). Absent -> averti, non bloquant.

set -eu

pdf="${1:?usage: check-td-numbering.sh <fichier.pdf>}"

if ! command -v pdftotext >/dev/null 2>&1; then
  echo "  (pdftotext absent : verification de la numerotation de TD ignoree)" >&2
  exit 0
fi

text=$(pdftotext -enc UTF-8 "$pdf" - 2>/dev/null)
status=0

expect() {
  if printf '%s\n' "$text" | grep -aqF -- "$1"; then :; else
    echo "attendu, absent : $1"; status=1
  fi
}

reject() {
  if printf '%s\n' "$text" | grep -aqE -- "$1"; then
    echo "present, inattendu : $1"; status=1
  fi
}

expect "NUMCHECK Exercice = 2"
expect "NUMCHECK Question = 2.2"
expect "NUMCHECK Sous-question = 2.2.2"
expect "NUMCHECK Théorème = 1"
expect "NUMCHECK Exemple = 1"
expect "NUMCHECK Remarque = 1"
expect "La question 2.2 se cite"
reject "(Théorème|Exemple|Remarque) 0\.[0-9]"

exit $status

#!/bin/sh
# Verifie qu'aucun symbole de fin (■ preuve, □ exemple) n'est rejete seul sur
# sa ligne dans un PDF rendu.
#
# Le symbole est pose a \end{proof} / \end{example}. Quand la boite se termine
# par une liste ou une equation hors texte, il passe seul sur une nouvelle
# ligne, sauf si l'auteur ecrit \qedhere a l'endroit voulu (voir
# doc/commandes.md, ocots-latex-template#48). Le defaut est silencieux : le
# document compile sans avertissement. Ce script le rend visible.
#
# Il arrive aussi qu'une derniere ligne de texte PLEINE rejette le symbole :
# c'est le comportement normal de TeX, mais le rendu est le meme, et le
# remede aussi (\qedhere, ou retoucher la phrase).
#
# Usage : check-qed.sh <fichier.pdf>
# Sortie : 0 si aucun symbole n'est seul sur sa ligne ; 1 sinon, avec la page
# et la ligne qui precede.
#
# Necessite pdftotext (poppler-utils). Absent -> averti, non bloquant.

set -eu

pdf="${1:?usage: check-qed.sh <fichier.pdf>}"

if ! command -v pdftotext >/dev/null 2>&1; then
  echo "  (pdftotext absent : verification des symboles de fin ignoree)" >&2
  exit 0
fi

pdftotext -layout "$pdf" - 2>/dev/null | awk '
  BEGIN { page = 1 }
  {
    n = gsub(/\f/, "")
    page += n
    if ($0 ~ /^[[:space:]]*(■|□)[[:space:]]*$/) {
      p = prev; sub(/^[[:space:]]+/, "", p)
      printf "  page %d : symbole de fin seul sur sa ligne, apres « %s »\n", page, substr(p, 1, 60)
      bad = 1
    }
    if ($0 ~ /[^[:space:]]/) prev = $0
  }
  END { exit bad }'

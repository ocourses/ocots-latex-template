#!/bin/sh
# Verifie l'espace de reponse des questions (ocots-latex-template#85).
#
# En solutions=none (sujet distribue), une question laisse sous elle la place
# demandee par \setanswerspace, answerspace= ou space= ; des que les corriges
# sont composes (inline), aucune place n'est laissee. Un espace absent ou en
# trop compile sans avertissement : « make check », qui ne lit que les
# journaux, ne le verrait pas.
#
# Convention, posee par content/answerspace-body.tex : chaque question commence
# par un marqueur [A], [B]… On mesure l'ecart vertical entre deux marqueurs
# consecutifs sur la meme page, et on le compare a l'attendu (cm, a 0,3 pres,
# hors ecart de base d'une ligne de question).
#
# Les questions [L]..[S] verifient en plus qu une question a place n est
# jamais coupee par un saut de page.
#
# Usage : check-answerspace.sh <none.pdf> <inline.pdf>
# Sortie : 0 si tout est conforme ; 1 sinon.
#
# Necessite pdftotext (poppler-utils) et python3. Absent -> averti, non bloquant.

set -eu

none="${1:?usage: check-answerspace.sh <none.pdf> <inline.pdf>}"
inline="${2:?usage: check-answerspace.sh <none.pdf> <inline.pdf>}"

if ! command -v pdftotext >/dev/null 2>&1 || ! command -v python3 >/dev/null 2>&1; then
  echo "  (pdftotext ou python3 absent : verification de l'espace de reponse ignoree)" >&2
  exit 0
fi

python3 - "$none" "$inline" <<'PY'
import re, subprocess, sys

def gaps(pdf):
    out = subprocess.run(['pdftotext', '-bbox', pdf, '-'], capture_output=True, text=True).stdout
    pos, page = {}, 0
    for l in out.splitlines():
        if '<page' in l:
            page += 1
        m = re.search(r'yMin="([\d.]+)".*>\[([A-K])\]<', l)
        if m:
            pos[m.group(2)] = (page, float(m.group(1)))
    cm = 72 / 2.54
    return {a + b: (pos[b][1] - pos[a][1]) / cm
            for a, b in zip(sorted(pos), sorted(pos)[1:]) if pos[a][0] == pos[b][0]}

# Ecart en plus de l'ecart de base, par couple de marqueurs.
#   C : defaut 3cm (correction masquee)   D : space=0pt     E : space=5cm
#   G : sous-question, pas de defaut      H : space=2cm
#   J : answerspace=1cm puis \answerspace[2cm]
attendu = {
    'none':   {'CD': 3, 'DE': 0, 'EF': 5, 'GH': 0, 'HI': 2, 'JK': 3},
    'inline': {'DE': 0, 'EF': 0, 'GH': 0, 'HI': 0, 'JK': 0},
}
base = {'CD': 0.79, 'DE': 0.79, 'EF': 0.79, 'GH': 0.79, 'HI': 1.69, 'JK': 0.79}
ok = True
for mode, pdf in (('none', sys.argv[1]), ('inline', sys.argv[2])):
    g = gaps(pdf)
    for k, extra in attendu[mode].items():
        if k not in g:
            print(f"{mode} : marqueurs {k[0]}/{k[1]} introuvables ou sur deux pages"); ok = False; continue
        mesure = g[k] - base[k]
        if abs(mesure - extra) > 0.3:
            print(f"{mode} : {k[0]}->{k[1]} laisse {mesure:.2f} cm de plus que l'ecart de base, attendu {extra} cm"); ok = False
# Coupures : en solutions=none, l'enonce d'une question a place n'est jamais
# coupe -- son debut [X] et sa fin @X sont sur la meme page.
out = subprocess.run(['pdftotext', '-bbox', sys.argv[1], '-'], capture_output=True, text=True).stdout
debut, fin, page = {}, {}, 0
for l in out.splitlines():
    if '<page' in l:
        page += 1
    m = re.search(r'>\[([L-S])\]<', l)
    if m:
        debut[m.group(1)] = page
    m = re.search(r'>@([L-S])<', l)
    if m:
        fin[m.group(1)] = page
pages = set(debut.values())
for c in "LMNOPQRS":
    if c not in debut or c not in fin:
        print(f"none : marqueurs [{c}]/@{c} introuvables"); ok = False
    elif debut[c] != fin[c]:
        print(f"none : la question [{c}] est coupee entre les pages {debut[c]} et {fin[c]}"); ok = False
if len(pages) < 2:
    print("none : la serie de questions ne franchit aucune page, le test ne prouve rien"); ok = False
sys.exit(0 if ok else 1)
PY

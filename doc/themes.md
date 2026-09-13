# Thèmes `ocots`

> [`README.md`](../README.md) · [`doc/commandes.md`](commandes.md) · **themes.md**

L'apparence du template — couleurs, forme des boîtes, dessin des titres,
habillage du code — est un **thème**. Le noyau et les environnements ne testent
jamais le thème : ils lisent des registres (`\ocotsboxstyle{theorem}`,
`\ocotscolor{link}`, `\ocotsheading{chapter}`). Changer de thème, c'est changer
une option.

---

# 1. Côté utilisateur

## Choisir un thème

```latex
\usepackage[lang=fr, theme=ocots]{ocots}
```

`theme=` se résout en un fichier : `theme=ocots` charge `ocots-theme-ocots.sty`.
Sans l'option, `ocots` est utilisé sur papier comme en diapositives.

| thème | rendu | boîtes | titres | formule | code |
|-------|-------|--------|--------|---------|------|
| `ocots` | **le défaut** : aucun fond, liseré en équerre, palette à 7 couleurs | `bracket` | `plain` | `highlight` | `card` |
| `legacy` | le rendu historique : cadres pastel, titres entre filets | `framed` | `rules` | `highlight` | `framed` |
| `charter` | Charter/Fira, filet latéral, grand chiffre de chapitre | `sidebar` | `bignum` | `flat` | `card` |
| `slate` | sobre : un seul accent (ardoise), aplats teintés | `shaded` | `plain` | `flat` | `framed` |

## Régler une seule facette

Quatre options surchargent le thème, **après** son chargement — pour comparer
deux rendus sur un même document sans éditer de fichier :

| option | valeurs | remplace |
|--------|---------|----------|
| `boxform=` | `bracket`, `framed`, `sidebar`, `shaded` | la forme des 7 boîtes à titre |
| `titles=` | `plain`, `rules`, `bignum` | le dessin des titres de chapitre / section |
| `mathbox=` | `highlight`, `flat`, `rule`, `none` | le style de `\tcbhighmath` |
| `listing=` | `card`, `framed` | l'habillage des blocs de code |

```latex
% palette et police de « ocots », mais boîtes à cadre pastel
\usepackage[lang=fr, theme=ocots, boxform=framed]{ocots}

% « legacy » complet, mais titre de chapitre sobre
\usepackage[lang=fr, theme=legacy, titles=plain]{ocots}
```

Ce qui **n'est pas** pilotable par option : la palette (elle vient toujours du
`theme=`), la typographie (les polices de `charter` sont dans le thème), et le
filet latéral des remarques / hypothèses. Pour combiner autrement, il faut un
**fichier de thème** — voir la partie 2.

## Comparer

`examples/themes/<theme>/` compile les quatre supports (`poly.tex`,
`slides.tex`, `td.tex`, `exam.tex`) avec un thème donné — c'est la vitrine
complète de ce thème. `examples/themes/<theme>/variants/` isole ensuite une
seule facette, appliquée par-dessus le thème du dossier (pas par-dessus le
défaut `ocots`) — **toutes les valeurs** de chaque facette, nommées
`<facette>-<valeur>.tex` :

| fichier | montre |
|---------|--------|
| `variants/fonts.tex` | `setfont=` / `calfont=` par-dessus le thème du dossier |
| `variants/boxform-{bracket,framed,sidebar,shaded}.tex` | les 4 formes de boîtes à titre |
| `variants/titles-{plain,rules,bignum}.tex` | les 3 dessins de titres |
| `variants/mathbox-{highlight,flat,rule,none}.tex` | les 4 encadrés de formule |
| `variants/listing-{card,framed}.tex` | les 2 habillages de code |

Soit 14 variantes par thème. La valeur propre du thème y figure aussi : la
note de première page la signale alors comme réglage par défaut forcé
explicitement. Le filet latéral (`siderule`) n'a pas de variante, n'étant pas
pilotable par option.

Chaque PDF de `variants/` affiche en première page une note rappelant ce qui
change par rapport au réglage par défaut du thème du dossier.
`examples/variants/` (au niveau racine) garde en plus les variantes
indépendantes du thème : langue, corrigés, modules `math=`, `draft`,
`binding=`, établissements, syntaxe v0, etc.

```bash
cd examples && make themes           # les quatre supports, quatre thèmes
cd examples && make theme-variants   # les facettes isolées, par thème
cd examples && make variants         # les variantes indépendantes du thème
# puis ouvrir les PDF côte à côte
```

---

# 2. Côté développeur

## Un thème = quelques axes indépendants

1. une **palette** — une couleur *clé* par famille, plus les couleurs
   sémantiques ;
2. une **forme** par famille de boîte, et un style de filet pour les blocs
   annexes ;
3. un **dessin de titres**, un **encadré de formule**, un **habillage du code**.

Chacun est une brique séparée (un fichier dans
`tex/theme/{form,siderule,title,mathbox,listing}/`). Un thème les assemble.

## Écrire un thème

```latex
\NeedsTeXFormat{LaTeX2e}
\ProvidesPackage{ocots-theme-mocha}[2026/09/06 v1.0 ocots -- theme mocha]

% --- 1. Palette : une couleur CLE par famille -----------------------------
\definecolor{ocots@raw@coffee}{HTML}{6F4E37}
\definecolor{ocots@raw@olive} {HTML}{5B6C3A}
% ...
\ocotssetcolor{key-definition}{ocots@raw@coffee}
\ocotssetcolor{key-theorem}{ocots@raw@coffee!80!black}
\ocotssetcolor{key-proposition}{ocots@raw@olive}
\ocotssetcolor{key-corollary}{ocots@raw@olive}
\ocotssetcolor{key-conjecture}{ocots@raw@olive}
\ocotssetcolor{key-exercise}{ocots@raw@olive}
\ocotssetcolor{key-solution}{ocots@raw@coffee}

% Couleurs sémantiques (posées directement)
\ocotssetcolor{link}{ocots@raw@coffee}
\ocotssetcolor{url}{ocots@raw@coffee!70!black}
\ocotssetcolor{cite}{ocots@raw@olive}
\ocotssetcolor{proof}{black}
\ocotssetcolor{emph-a}{ocots@raw@coffee}   % ... emph-b, emph-c, emph-d
\ocotssetcolor{grey}{black!15}
\ocotssetcolor{chapter}{ocots@raw@coffee}  % ... section, subsection, subsubsection
\ocotssetcolor{rule-remark}{ocots@raw@coffee}
\ocotssetcolor{rule-assumption}{black}
\ocotssetcolor{mathhighlight}{ocots@raw@olive!14!white}
\ocotssetcolor{listing-rule}{ocots@raw@coffee}
\ocotssetcolor{slide0}{ocots@raw@coffee}   % ... slide1..4, slidetitle
\ocotssetcolor{titlebox-back}{ocots@raw@coffee}
\ocotssetcolor{titlebox-frame}{ocots@raw@coffee}
\ocotssetcolor{titlebox-text}{white}

% --- 2 & 3. Socle : bracket-non ; framed + bar + rules + highlight + framed
\RequirePackage{ocots-theme-base}

% --- surcharges éventuelles ---------------------------------------------
\ocotsformall{bracket}             % ou une famille : \ocotsform{exercise}{shaded}
\ocotsusetitles{plain}
\ocotsuselisting{card}

\endinput
```

**Ordre obligatoire** : la palette **avant** `\RequirePackage{ocots-theme-base}`
(ou avant tout `\ocotsformall`). Une forme dérive `back-`/`frame-`/`title-` de
la couleur clé par un `\colorlet` immédiat : si `key-<famille>` n'est pas encore
posée, erreur `undefined color`.

Le socle pose par défaut `framed` + `bar` + `rules` + `highlight` + `framed`
(listing). Un thème `\RequirePackage`e le socle **puis** surcharge ce qu'il
veut.

## Liste fermée des registres

**Familles à titre** (forme via `\ocotsform` / `\ocotsformall`) :
`theorem`, `definition`, `proposition`, `corollary`, `conjecture`,
`exercise`, `solution`.

**Blocs à filet** (via `\ocotssiderule`) :
`remark`, `assumption`, `openquestion`, `difficulty`.

**Couleurs attendues** — clé de famille : `key-<famille>` (les 7 ci-dessus).
Sémantiques : `link`, `url`, `cite`, `proof`, `emph-a`…`emph-d`, `grey`,
`chapter`, `section`, `subsection`, `subsubsection`, `rule-remark`,
`rule-assumption`, `mathhighlight`, `listing-rule`, `slide0`…`slide4`,
`slidetitle`, `titlebox-back`, `titlebox-frame`, `titlebox-text`.

`proof` et `titlebox` ont un style de boîte fixe posé par le socle ; un thème
peut le redéfinir avec `\ocotssetboxstyle{proof}{...}` après le socle.

## Le modèle de couleurs : dérivation vs verrou

- `\ocotssetcolor{<clef>}{<couleur>}` — appelé par un **thème**. La couleur est
  **verrouillée** : un preset ne la dérivera pas par-dessus.
- `\ocots@derivecolor{<clef>}{<couleur>}` — appelé par un **preset**. Ne pose la
  couleur que si elle n'est pas verrouillée.

Donc : un thème pose `key-theorem`, la forme `framed` en dérive
`frame-theorem = key-theorem!20!white`. Si le thème pose *aussi*
`\ocotssetcolor{frame-theorem}{...}`, le preset respecte ce choix. `mono` s'en
sert : il pose les triplets `back-/frame-/title-` en clair (pour un contraste
par famille impossible à dériver d'une teinte unique).

## Écrire un preset

### Forme (`boxform=`) — `tex/theme/form/ocots-form-<nom>.sty`

```latex
\NeedsTeXFormat{LaTeX2e}
\ProvidesPackage{ocots-form-ribbon}[...]

% Reçoit un nom de famille, pose son style de boîte.
\newcommand{\ocots@form@ribbon}[1]{%
  \ocots@derivecolor{back-#1}{white}%
  \ocots@derivecolor{frame-#1}{ocots@key-#1}%
  \ocots@derivecolor{title-#1}{white}%
  \ocotssetboxstyle{#1}{%
    enhanced jigsaw, breakable,
    fonttitle=\bfseries\upshape\ocotsboxtitlefont,
    before skip=\ocotsboxbeforeskip, after skip=\ocotsboxafterskip,
    colback=\ocotscolor{back-#1},
    colframe=\ocotscolor{frame-#1},
    coltitle=\ocotscolor{title-#1}}}
\ocotsregisterform{ribbon}{\ocots@form@ribbon}
\endinput
```

`\ocotsboxbeforeskip`, `\ocotsboxafterskip`, `\ocotsboxtitlefont` sont fournis
par le noyau (`\providecommand`) : un thème à police linéale pose
`\renewcommand{\ocotsboxtitlefont}{\sffamily}`. La forme `bracket` (défaut de
`ocots`) montre le motif à deux `borderline` : `west` + `south`, `blanker`,
aucun `colback`.

### Filet latéral — `tex/theme/siderule/ocots-siderule-<nom>.sty`

```latex
\newcommand{\ocots@siderule@double}[1]{%
  \ocots@derivecolor{rule-#1}{ocots@key-#1}%
  \ocotssetboxstyle{#1}{%
    enhanced jigsaw, breakable, blanker, left=5mm,
    before skip=\ocotsboxbeforeskip, after skip=\ocotsboxafterskip,
    borderline west={0.4mm}{0pt}{\ocotscolor{rule-#1}},
    borderline west={0.4mm}{1.2mm}{\ocotscolor{rule-#1}}}}
\ocotsregistersiderule{double}{\ocots@siderule@double}
```

### Titres (`titles=`) — `tex/theme/title/ocots-title-<nom>.sty`

Le preset ne fait que **déposer** des crochets ; le support (`carrier/`) charge
titlesec puis les exécute via `\ocotsheading{titles-book}`.

```latex
\ocotssetheading{chapter-number}{\color{\ocotscolor{chapter}}\Huge\bfseries}
\ocotssetheading{chapter-title}{\color{\ocotscolor{chapter}}\Huge\bfseries}
\ocotssetheading{section}{\color{\ocotscolor{section}}\Large\bfseries}
% ... subsection, subsubsection
\ocotssetheading{titles-book}{%
  \titleformat{\chapter}[display]{...}{...}{...}{...}%
  \ocotsheading{titles-article}}
\ocotssetheading{titles-article}{%
  \titleformat{\section}{\ocotsheading{section}}{\thesection}{1em}{}%
  ...}
```

### Encadré de formule (`mathbox=`) — `tex/theme/mathbox/ocots-mathbox-<nom>.sty`

```latex
% initialize@reset, PAS un \tcbset simple : la bibliothèque theorems de
% tcolorbox réécrit « highlight math style » à l'ouverture de chaque boîte.
\tcbset{initialize@reset={highlight math style={%
  enhanced, colback=\ocotscolor{mathhighlight}, boxrule=0pt, size=minimal}}}
```

### Habillage du code (`listing=`) — `tex/theme/listing/ocots-listing-<nom>.sty`

Un `\lstset` : cadre, fonte de base, numéros de ligne, fond. La **coloration
syntaxique** (commentaires, mots-clés, chaînes) reste dans `ocots-text.sty` —
elle suit la palette et n'a pas de variante.

```latex
\ocots@derivecolor{listing-rule}{ocots@emph-a}
\lstset{
  backgroundcolor=\color{white},
  basicstyle=\footnotesize\ttfamily,
  frame=lb, framerule=1.4pt,
  rulecolor=\color{\ocotscolor{listing-rule}},
  numbers=left, numberstyle=\scriptsize\ttfamily\color{\ocotscolor{grey}}}
```

## Pièges (vus en écrivant cette couche)

- Un **chiffre après `@`** dans un nom de macro tronque le nom : `\ocots@v2foo`
  n'existe pas, TeX lit `\ocots@v` puis le texte `2foo`. Utiliser
  `\ocots@vtwofoo`.
- `\@for\x:=\uneMacroListe\do{...}` ne développe pas la macro comme attendu
  (la variable de boucle capture le jeton entier au premier tour). Lister en
  clair.
- Un fragment de liste de clés pgfkeys doit être un **style**
  (`foo/.style={...}`) et non une macro contenant des virgules.
- Ce qui apparaît dans une liste de clés tcolorbox doit être **robuste** :
  `\ocotscolor{...}` développe en un simple nom de couleur, c'est voulu.
- `\newtheorem*` de style « ocots » avec nom **et** numéro vides compose un
  « . » solitaire : les variantes étoilées des blocs étiquetés
  (`assumption*`…) sont donc des environnements nus, décorés par
  `\tcolorboxenvironment` comme les autres.

## API du noyau (rappel)

| macro | rôle |
|-------|------|
| `\ocotssetcolor{clef}{couleur}` | pose une couleur (verrouillée) |
| `\ocotsform{famille}{forme}` · `\ocotsformall{forme}` | applique une forme |
| `\ocotssiderule{famille}{style}` | applique un filet latéral |
| `\ocotsusetitles{preset}` · `\ocotsusemathbox{preset}` · `\ocotsuselisting{preset}` | charge le preset |
| `\ocotssetboxstyle{clef}{...}` · `\ocotsboxstyle{clef}` | style tcolorbox brut |
| `\ocotssetheading{clef}{...}` · `\ocotsheading{clef}` | crochet de titre |
| `\ocotsregisterform{nom}{\macro}` · `\ocotsregistersiderule{nom}{\macro}` | (dans un preset) s'enregistrer |
| `\ocots@derivecolor{clef}{couleur}` | (dans un preset) dériver sans écraser un verrou |

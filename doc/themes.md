# Thèmes `ocots`

> [`README.md`](../README.md) · [`doc/commandes.md`](commandes.md) · **themes.md**

L'apparence du template — couleurs, forme des boîtes, dessin des titres — est
un **thème**. Le noyau et les environnements ne testent jamais le thème : ils
lisent des registres (`\ocotsboxstyle{theorem}`, `\ocotscolor{link}`,
`\ocotsheading{chapter}`). Changer de thème, c'est changer une option.

---

# 1. Côté utilisateur

## Choisir un thème

```latex
\usepackage[lang=fr, theme=classic]{ocots}
```

`theme=` se résout en un fichier : `theme=classic` charge
`ocots-theme-classic.sty`. Sans l'option, le défaut dépend du support :
`classic` sur papier, `classic-dark` en diapositives.

| thème | rendu | boîtes | titres | formule |
|-------|-------|--------|--------|---------|
| `classic` | le rendu historique : cadres pastel, titres entre filets | `framed` | `rules` | `highlight` |
| `classic-dark` | soutenu : cadres pleins, titres blancs — défaut diapos | `framed-solid` | `rules` | `highlight` |
| `classic-light` | pastel, en-têtes de diapo claires | `framed` | `rules` | `highlight` |
| `mono` | niveaux de gris, pour l'impression sans couleur | `framed` | `rules` | `highlight` |
| `charter` | refonte visuelle : XCharter/Fira, filet latéral, grand chiffre de chapitre | `sidebar` | `bignum` | `flat` |
| `slate` | sobre : un seul accent, aplats teintés | `shaded` | `plain` | `flat` |

Les anciens noms `n7`, `n7-dark`, `n7-light`, `bw`, `v2` restent acceptés comme
**alias dépréciés** (avertissement à la compilation).

## Régler une seule facette

Trois options surchargent le thème, **après** son chargement — pour comparer
deux rendus sur un même document sans éditer de fichier :

| option | valeurs | remplace |
|--------|---------|----------|
| `boxform=` | `framed`, `framed-solid`, `sidebar`, `shaded` | la forme des 7 boîtes à titre |
| `titles=` | `rules`, `bignum`, `plain` | le dessin des titres de chapitre / section |
| `mathbox=` | `highlight`, `flat`, `rule`, `none` | le style de `\tcbhighmath` |

```latex
% palette et polices de « classic », mais boîtes dessinées comme « charter »
\usepackage[lang=fr, theme=classic, boxform=sidebar]{ocots}

% « charter » complet, mais titre de chapitre entre filets
\usepackage[lang=fr, theme=charter, titles=rules]{ocots}
```

Ce qui **n'est pas** pilotable par option : la palette (elle vient toujours du
`theme=`), la typographie (les polices de `charter` sont dans le thème), et le
filet latéral des remarques / hypothèses. Pour combiner autrement, il faut un
**fichier de thème** — voir la partie 2.

## Comparer

`examples/variants/` compile le même corps avec des options différentes :

| fichier | montre |
|---------|--------|
| `theme-classic.tex` / `theme-charter.tex` / `theme-slate.tex` | un thème chacun, contenu complet |
| `form-sidebar.tex` / `form-shaded.tex` | `theme=classic` + `boxform=` |
| `titles-bignum.tex` | `theme=classic` + `titles=bignum` |

```bash
cd examples && make variants     # puis ouvrir les PDF côte à côte
```

---

# 2. Côté développeur

## Un thème = trois axes indépendants

1. une **palette** — une couleur *clé* par famille, plus les couleurs
   sémantiques ;
2. une **forme** par famille de boîte, et un style de filet pour les blocs
   annexes ;
3. un **dessin de titres** et un **encadré de formule**.

Chacun est une brique séparée. Un thème les assemble.

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
\ocotssetcolor{slide0}{ocots@raw@coffee}   % ... slide1..4, slidetitle
\ocotssetcolor{titlebox-back}{ocots@raw@coffee}
\ocotssetcolor{titlebox-frame}{ocots@raw@coffee}
\ocotssetcolor{titlebox-text}{white}

% --- 2 & 3. Socle : framed + bar + rules + highlight par défaut -----------
\RequirePackage{ocots-theme-base}

% --- surcharges éventuelles ---------------------------------------------
\ocotsform{exercise}{shaded}       % une famille dans une autre forme
\ocotssiderule{difficulty}{soft}
\ocotsusemathbox{flat}

\endinput
```

**Ordre obligatoire** : la palette **avant** `\RequirePackage{ocots-theme-base}`
(ou avant tout `\ocotsformall`). Une forme dérive `back-`/`frame-`/`title-` de
la couleur clé par un `\colorlet` immédiat : si `key-<famille>` n'est pas
encore posée, erreur `undefined color`.

## Liste fermée des registres

**Familles à titre** (forme via `\ocotsform` / `\ocotsformall`) :
`theorem`, `definition`, `proposition`, `corollary`, `conjecture`,
`exercise`, `solution`.

**Blocs à filet** (via `\ocotssiderule`) :
`remark`, `assumption`, `openquestion`, `difficulty`.

**Couleurs attendues** — clé de famille : `key-<famille>` (les 7 ci-dessus).
Sémantiques : `link`, `url`, `cite`, `proof`, `emph-a`…`emph-d`, `grey`,
`chapter`, `section`, `subsection`, `subsubsection`, `rule-remark`,
`rule-assumption`, `mathhighlight`, `slide0`…`slide4`, `slidetitle`,
`titlebox-back`, `titlebox-frame`, `titlebox-text`.

`proof` et `titlebox` ont un style de boîte fixe posé par le socle ; un thème
peut le redéfinir avec `\ocotssetboxstyle{proof}{...}` après le socle.

## Le modèle de couleurs : dérivation vs verrou

- `\ocotssetcolor{<clef>}{<couleur>}` — appelé par un **thème**. La couleur est
  **verrouillée** : une forme ne la dérivera pas par-dessus.
- `\ocots@derivecolor{<clef>}{<couleur>}` — appelé par un **preset de forme**.
  Ne pose la couleur que si elle n'est pas verrouillée.

Donc : un thème pose `key-theorem`, la forme `framed` en dérive
`frame-theorem = key-theorem!20!white`. Si le thème pose *aussi*
`\ocotssetcolor{frame-theorem}{...}`, la forme respecte ce choix.
`mono` s'en sert : il pose les triplets `back-/frame-/title-` en clair (pour
un contraste par famille impossible à dériver d'une teinte unique).

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
`\renewcommand{\ocotsboxtitlefont}{\sffamily}`.

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

## API du noyau (rappel)

| macro | rôle |
|-------|------|
| `\ocotssetcolor{clef}{couleur}` | pose une couleur (verrouillée) |
| `\ocotsform{famille}{forme}` · `\ocotsformall{forme}` | applique une forme |
| `\ocotssiderule{famille}{style}` | applique un filet latéral |
| `\ocotsusetitles{preset}` · `\ocotsusemathbox{preset}` | charge le preset |
| `\ocotssetboxstyle{clef}{...}` · `\ocotsboxstyle{clef}` | style tcolorbox brut |
| `\ocotssetheading{clef}{...}` · `\ocotsheading{clef}` | crochet de titre |
| `\ocotsregisterform{nom}{\macro}` · `\ocotsregistersiderule{nom}{\macro}` | (dans un preset) s'enregistrer |
| `\ocots@derivecolor{clef}{couleur}` | (dans un preset) dériver sans écraser un verrou |

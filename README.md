# Template `ocots`

Template LaTeX pour **polycopiés, diapositives, TD et sujets d'examen**, avec
une seule API : un énoncé se colle tel quel du TD au polycopié. L'apparence est
pilotée par des **thèmes** interchangeables (`classic` reproduit le rendu
historique, `charter` est une refonte visuelle, `slate` un thème sobre).

- **[`doc/commandes.md`](doc/commandes.md)** — toutes les commandes et
  environnements, par thème.
- **[`doc/notations.md`](doc/notations.md)** — la référence exhaustive des
  notations mathématiques et de leurs modules.
- **[`doc/themes.md`](doc/themes.md)** — choisir, régler ou écrire un thème
  (partie utilisateur + partie développeur).
- **[`examples/`](examples/)** — un document compilable par support, plus les
  variantes d'options.

---

## Installation

Le template est un jeu de fichiers `.sty` / `.cls` trouvés par `TEXINPUTS`. Il
n'y a **rien à compiler** ni à configurer côté template ; trois façons de le
rendre visible à LaTeX :

### A. Sous-module git (recommandé pour un cours)

```bash
git submodule add git@github.com:ocourses/ocots-latex-template.git template
```

puis, dans le `.latexmkrc` du document (ou du dépôt) :

```perl
$ENV{'TEXINPUTS'} = '../template/tex//:../template/assets//:' . ($ENV{'TEXINPUTS'} // '');
```

Chaque cours **épingle une version** du template ; marche sur Overleaf ; se met
à jour par `git -C template pull` + un commit du pointeur.
[`examples/Makefile`](examples/Makefile) montre le réglage `TEXINPUTS` côté
`make`.

### B. Installation locale (`TEXMFHOME`)

Pour raccourcir les préambules sur un poste, sans casser Overleaf ni les
co-auteurs :

```bash
mkdir -p ~/texmf/tex/latex
ln -s /chemin/vers/ocots-latex-template/tex ~/texmf/tex/latex/ocots
```

`\usepackage{ocots}` fonctionne alors sans `TEXINPUTS`. (Les logos de
`assets/` restent à couvrir séparément si un document en a besoin.)

### C. Overleaf

Overleaf clone les sous-modules : la méthode A fonctionne telle quelle. À
défaut, copier `tex/` et `assets/` dans le projet et pointer `TEXINPUTS`
dessus via un `latexmkrc`.

### Prérequis

- **TeX Live complet** (`scheme-full`) ou MacTeX — le template charge une
  quarantaine de paquets (`tcolorbox` avec `skins`/`breakable`, `beamer`,
  `circuitikz`, `titlesec`, `stackengine`…) ;
- `latexmk`.

---

## Prise en main

Un polycopié :

```latex
\documentclass[11pt,twoside]{ocots-book}
\usepackage[lang=fr, theme=ocots, solutions=end, math=analysis]{ocots}

\title{Calcul différentiel et équations différentielles}
\author{Prénom \textsc{Nom}}

\begin{document}
\maketitle
\tableofcontents
\end{document}
```

`theme=` est facultatif : sans lui, le thème `ocots` est utilisé sur papier comme
en diapositives. `legacy-dark` reste disponible comme variante adaptée à la
projection.

Des diapositives — le support est déduit de la classe, rien à déclarer :

```latex
\documentclass[9pt,t]{beamer}
\usepackage[lang=fr, theme=ocots]{ocots}

\begin{slide}{Une diapositive titrée} … \end{slide}
\begin{slide}                       … \end{slide} % transition sans titre
```

`slide` accepte un titre optionnel : la forme titrée reçoit le bandeau et le
compteur du template, tandis que la forme sans titre conserve le rendu d'un
`frame` nu. `frame` reste disponible comme environnement natif de beamer. Le
titre est détecté par un groupe `{…}` en premier ; si le corps d'un `slide`
sans titre doit commencer par un groupe brut, voir la mise en garde dans
[`doc/commandes.md`](doc/commandes.md#diapositives).

`\slidetitlepage` accepte un contenu optionnel placé sous le bloc
auteur/date/logos, tout en restant vide par défaut.

Un TD ou un sujet d'examen :

```latex
\documentclass[11pt]{ocots-td}     % ou ocots-exam
\usepackage[lang=fr, solutions=none, institution={n7}]{ocots}
```

---

## Options

| Option | Valeurs | Défaut | Effet |
|--------|---------|--------|-------|
| `lang` | `fr`, `en` | `fr` | langue des intitulés et de la typographie |
| `theme` | `ocots`, `legacy`, `legacy-dark`, `legacy-light`, `mono`, `charter`, `slate` | `ocots` | palette + formes + titres |
| `boxform` | `bracket`, `framed`, `framed-solid`, `sidebar`, `shaded` | (le thème décide) | **surcharge** la forme des boîtes à titre |
| `titles` | `plain`, `rules`, `bignum` | (le thème décide) | **surcharge** le dessin des titres |
| `mathbox` | `highlight`, `flat`, `rule`, `none` | (le thème décide) | **surcharge** l'encadré de formule (`\tcbhighmath`) |
| `listing` | `card`, `framed` | (le thème décide) | **surcharge** l'habillage des blocs de code |
| `solutions` | `none`, `inline`, `end` | `end` | sort des corrigés |
| `math` | `base`, `analysis`, `control`, `measure` | `base` | modules de macros chargés |
| `setfont` | `bb`, `rm` | `bb` | police des ensembles de nombres |
| `calfont` | `scr`, `cal` | `scr` | police des familles calligraphiques |
| `institution` | `n7`, `inp`, `insa`, `uftmp` | `n7` | logos de la page de titre |
| `author` | texte | vide | métadonnée `pdfauthor` |
| `draft` | drapeau | absent | affiche les notes de travail |
| `binding` | longueur | `0mm` | décalage de reliure pour l'impression |

`math` et `institution` acceptent plusieurs valeurs séparées par une virgule —
**entourer alors la valeur d'accolades** : `institution={n7,inp}`, jamais
`institution=insa,n7` (la virgule non protégée est vue par `\usepackage[...]`
avant d'atteindre l'option, qui ne reçoit alors que la première valeur, sans
erreur ni avertissement).

Chaque valeur se résout en un nom de fichier : `theme=ocots` charge
`tex/theme/ocots-theme-ocots.sty`, `boxform=sidebar` charge
`tex/theme/form/ocots-form-sidebar.sty`. **Ajouter un thème, une forme, une
langue ou un module de macros, c'est ajouter un fichier** — le noyau n'est pas
touché. Les anciens noms de thème `classic`, `n7`, `n7-dark`, `n7-light`, `bw`,
`v2` restent acceptés (alias dépréciés vers `legacy*` / `charter`, avec un
avertissement).

Le détail des commandes est dans [`doc/commandes.md`](doc/commandes.md), les
notations mathématiques dans [`doc/notations.md`](doc/notations.md), et les
thèmes dans [`doc/themes.md`](doc/themes.md).

---

## Organisation

```
tex/
  ocots.sty              point d'entrée : options et orchestration
  ocots-kernel.sty       registres (chaînes, couleurs, styles, presets) + détection du support
  ocots-packages.sty     les \RequirePackage, et rien d'autre
  ocots-env.sty          les environnements — définis une seule fois
  ocots-exercise.sty     exercices et corrigés
  ocots-text.sty         mise en valeur, notes de travail, coloration du code
  ocots-graphics.sty     aides TikZ, tableaux
  ocots-institution.sty  logos
  ocots-compat.sty       alias des noms v0
  ocots-book.cls  ocots-td.cls  ocots-exam.cls
  carrier/               supports : book, slides, article, td, exam
  theme/                 thèmes : ocots, legacy{,-dark,-light}, mono, charter, slate, + socle
    theme/form/            formes de boîte : bracket, framed, framed-solid, sidebar, shaded
    theme/siderule/        filets latéraux : bar, soft, none
    theme/title/           dessin des titres : plain, rules, bignum
    theme/mathbox/         encadré de formule : highlight, flat, rule, none
    theme/listing/         habillage du code : card, framed
  lang/                  chaînes : fr, en
  math/                  macros : base, analysis, control, measure
  third-party/           tikzgraphicx (B. Kellermann, GPL)
assets/logos/
doc/                     commandes.md, themes.md
examples/                un document par support, plus les variantes d'options
```

**Trois couches, une règle** : le noyau définit les environnements, le support
fournit la structure, le thème fournit l'apparence. Un environnement ne teste
jamais son support ni son thème. Les retouches propres à un médium (remise à
zéro des compteurs entre deux `\pause`, par exemple) sont enregistrées par le
support, après coup.

**Étendre** :
- une **langue** — copier `tex/lang/ocots-lang-fr.def`, traduire, `lang=<code>` ;
- un **module de macros maths** — un fichier `tex/math/ocots-math-<nom>.sty`,
  chargé par `math=<nom>` ;
- un **thème** ou un **preset** — voir [`doc/themes.md`](doc/themes.md) ;
- un **établissement** — image dans `assets/logos/` + une ligne dans
  `tex/ocots-institution.sty`.

---

## Migrer un document v0

Deux lignes de préambule :

```latex
% avant
\documentclass[11pt,onecolumn,twoside]{../template/book}
\newcommand{\relativePath}{../template}
\usepackage[correction, relativePath=\relativePath]{\relativePath/book}

% après
\documentclass[11pt,twoside]{ocots-book}
\usepackage[lang=fr, solutions=end, math=analysis]{ocots}
```

Le **corps n'est pas retouché** : `mytheorem`, `myexercisecb<étiquette>`,
`\solutioncb`, `\myemph`, `no solution`… restent définis par
[`tex/ocots-compat.sty`](tex/ocots-compat.sty). Voir
[`examples/variants/compat.tex`](examples/variants/compat.tex), écrit
entièrement avec les noms de la v0. Ces alias sont destinés à disparaître :
chaque ligne supprimée de `ocots-compat.sty` est une migration terminée.

---

## Compilation des exemples

```bash
cd examples && make        # les quatre supports + les variantes d'options ; doit être VERT
```

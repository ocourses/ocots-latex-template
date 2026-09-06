# Template `ocots`

Template LaTeX pour polycopiés, diapositives, TD et sujets d'examen.

Refonte de l'**architecture** du template historique (défauts et diagnostic
recensés dans les notes de conception, ci-dessous). L'apparence est pilotée par
des **thèmes** : `classic` reproduit le rendu historique, `charter` est une
refonte visuelle complète, `slate` un thème sobre. Notes de conception dans
[`../reports/template-refonte/`](../reports/template-refonte) du dépôt qui monte
ce template en sous-module.

## Prise en main

Un polycopié :

```latex
\documentclass[11pt,twoside]{ocots-book}
\usepackage[lang=fr, theme=classic, solutions=end, math=analysis]{ocots}

\title{Calcul différentiel et équations différentielles}
\author{Prénom \textsc{Nom}}

\begin{document}
\maketitle
\tableofcontents
\end{document}
```

Des diapositives — le support est déduit de la classe, rien à déclarer :

```latex
\documentclass[9pt,t]{beamer}
\usepackage[lang=fr, theme=classic-dark]{ocots}
```

Un TD ou un sujet d'examen :

```latex
\documentclass[11pt]{ocots-td}     % ou ocots-exam
\usepackage[lang=fr, solutions=none, institution={insa,n7}]{ocots}
```

## Où LaTeX trouve le template

Par `TEXINPUTS`, qui doit couvrir `tex/` et `assets/` :

```bash
export TEXINPUTS="/chemin/vers/template-v1/tex//:/chemin/vers/template-v1/assets//:"
latexmk -pdf main.tex
```

En pratique on met cette ligne dans le `Makefile` ou le `.latexmkrc` du projet ;
[`examples/Makefile`](examples/Makefile) montre comment. Les documents n'ont
donc **aucun chemin relatif** à tenir à jour — le `\relativePath` de la v0 a
disparu.

## Options

| Option | Valeurs | Défaut | Effet |
|--------|---------|--------|-------|
| `lang` | `fr`, `en` | `fr` | langue des intitulés et de la typographie |
| `theme` | `classic`, `classic-dark`, `classic-light`, `mono`, `charter`, `slate` | `classic` (papier), `classic-dark` (diapos) | palette + formes + titres |
| `boxform` | `framed`, `framed-solid`, `sidebar`, `shaded` | (le thème décide) | **surcharge** la forme des boîtes à titre |
| `titles` | `rules`, `bignum`, `plain` | (le thème décide) | **surcharge** le dessin des titres |
| `mathbox` | `highlight`, `flat`, `rule`, `none` | (le thème décide) | **surcharge** l'encadré de formule (`\tcbhighmath`) |
| `solutions` | `none`, `inline`, `end` | `end` | sort des corrigés |
| `math` | `base`, `analysis`, `control`, `measure` | `base` | modules de macros chargés |
| `institution` | `n7`, `inp`, `insa`, `uftmp` | `n7` | logos de la page de titre |

Les anciens noms de thème `n7`, `n7-dark`, `n7-light`, `bw`, `v2` restent
acceptés (alias dépréciés → `classic`, `classic-dark`, `classic-light`, `mono`,
`charter`), avec un avertissement à la compilation.

`math` et `institution` acceptent plusieurs valeurs séparées par une virgule —
**entourer alors la valeur d'accolades** : `institution={insa,n7}`, pas
`institution=insa,n7`. Sans elles, la virgule est vue par `\usepackage[...]`
avant d'atteindre l'option, qui ne reçoit que la première valeur — sans erreur
ni avertissement.
| `author` | texte | vide | métadonnée `pdfauthor` |
| `draft` | drapeau | absent | affiche les notes de travail |
| `binding` | longueur | `0mm` | décalage de reliure pour l'impression |

Chaque valeur se résout en un nom de fichier : `theme=foo` charge
`tex/theme/ocots-theme-foo.sty`, `boxform=bar` charge
`tex/theme/form/ocots-form-bar.sty`. **Ajouter un thème, une forme, une langue
ou un module de macros, c'est ajouter un fichier** — le noyau n'est pas touché.

### Comment un thème est fait

Un thème fixe **trois choses qui varient indépendamment** :

1. une **palette** — une couleur *clé* par famille (`key-theorem`,
   `key-exercise`…) plus les couleurs sémantiques (`link`, `url`, `cite`,
   `chapter`…) ;
2. une **forme** par famille (`\ocotsformall{framed}`, ou `\ocotsform{exercise}{shaded}`) ;
3. un **dessin de titres** (`\ocotsusetitles{rules}`) et un **encadré de
   formule** (`\ocotsusemathbox{highlight}`).

La forme dérive `back-`/`frame-`/`title-<famille>` de la couleur clé ; un thème
qui veut sortir de la recette pose la couleur explicitement, elle est alors
verrouillée. Les formes, filets, titres et encadrés vivent dans
`tex/theme/{form,siderule,title,mathbox}/` : chacun est un preset réutilisable.

Le socle `ocots-theme-base.sty` assemble un jeu par défaut (`framed` + `bar` +
`rules` + `highlight`). Un thème minimal (`classic`, `mono`, `slate`) = une
palette + `\RequirePackage{ocots-theme-base}` + éventuellement deux ou trois
surcharges. `charter` (ex-`v2`) montre qu'une refonte visuelle complète —
typographie Charter/Fira, filet latéral, grand chiffre de chapitre — tient dans
une **trentaine de lignes** : palette + `\ocotsformall{sidebar}` +
`\ocotsusetitles{bignum}`.

Les options `boxform=`, `titles=`, `mathbox=` rejouent ces choix **après** le
thème, pour comparer deux rendus sur un même document sans éditer de fichier :
`examples/variants/form-sidebar.tex` = `theme=classic, boxform=sidebar`.
Comparer `theme-classic.tex`, `theme-charter.tex`, `theme-slate.tex` : même
corps, seule l'option change.

## Environnements

Ils sont définis **une seule fois**, quel que soit le support : un énoncé de TD
se colle tel quel dans le polycopié.

```latex
\begin{theorem}{Titre facultatif}{étiquette}     % + definition, proposition,
\end{theorem}                                    %   corollary, conjecture

\begin{lemma} \begin{example} \begin{remark}     % et leurs variantes étoilées
\begin{assumption}                               % étiquetées H1, H2...
\begin{openquestion}                             % Q1, Q2...
\begin{difficulty}                               % D1, D2...
\begin{web}[texte]                               % renvoi vers une ressource

\begin{proof} … \end{proof}
\begin{proofbegin} \begin{proofmiddle} \begin{proofend}   % preuve sur n diapos
```

Diapositives :

```latex
\slidechapter{5}{Titre du chapitre}
\slidetitlepage
\begin{slide}{Titre}                  … \end{slide}
\begin{slide}[\ocotscolor{slide2}]{…} … \end{slide}
```

## Exercices et corrigés

```latex
\ocotscollectsolutions                    % début de partie

\begin{exercise}[label=matrices, points=4]
    Énoncé.
\solution
    Corrigé.
\end{exercise}

\ocotsprintsolutions                      % là où les corrigés doivent paraître
```

`\solution` est une commande et non un environnement : `\begin{solution}`
ouvrirait un groupe, et la séparation haut/bas d'une `tcolorbox` doit se faire
au premier niveau.

L'option `solutions=` décide de tout le reste :

- `none` — les corrigés ne sont pas composés. **La version étudiante.**
- `inline` — le corrigé suit l'énoncé.
- `end` — le corrigé est reporté, avec renvois croisés dans les deux sens.

Le document ne change pas d'un mode à l'autre ; seule l'option bouge.
`\begin{exercise}[nosolution]` exclut un exercice précis, quel que soit le mode.

## Organisation

```
tex/
  ocots.sty              point d'entrée : options et orchestration
  ocots-kernel.sty       registres (chaînes, couleurs, styles) et détection du support
  ocots-packages.sty     les \RequirePackage, et rien d'autre
  ocots-env.sty          les environnements — définis une seule fois
  ocots-exercise.sty     exercices et corrigés
  ocots-text.sty         mise en valeur, notes de travail, listings
  ocots-graphics.sty     aides TikZ, tableaux
  ocots-institution.sty  logos
  ocots-compat.sty       alias des noms v0
  ocots-book.cls  ocots-td.cls  ocots-exam.cls
  carrier/               supports : book, slides, article, td, exam
  theme/                 thèmes : classic{,-dark,-light}, mono, charter, slate, + socle
    theme/form/            formes de boîte : framed, framed-solid, sidebar, shaded
    theme/siderule/        filets latéraux : bar, soft, none
    theme/title/           dessin des titres : rules, bignum, plain
    theme/mathbox/         encadré de formule : highlight, flat, rule, none
  lang/                  chaînes : fr, en
  math/                  macros : base, analysis, control, measure
  third-party/           tikzgraphicx (B. Kellermann, GPL)
assets/logos/
examples/                un document par support, plus les variantes d'options
```

Trois couches, et une règle : **le noyau définit les environnements, le support
fournit la structure, le thème fournit l'apparence.** Un environnement ne teste
jamais son support ni son thème. Les retouches propres à un médium (remise à
zéro des compteurs entre deux `\pause`, par exemple) sont enregistrées par le
support, après coup.

## Migrer un document v0

Deux lignes de préambule à changer :

```latex
% avant
\documentclass[11pt,onecolumn,twoside]{../template/book}
\newcommand{\relativePath}{../template}
\usepackage[correction, relativePath=\relativePath]{\relativePath/book}

% après
\documentclass[11pt,twoside]{ocots-book}
\usepackage[lang=fr, solutions=end, math=analysis]{ocots}
```

Le **corps du document n'est pas retouché** : `mytheorem`, `myremark`,
`myexercisecb<étiquette>`, `\solutioncb`, `\myemph`, `no solution`… restent
définis par [`tex/ocots-compat.sty`](tex/ocots-compat.sty).
Voir [`examples/variants/compat.tex`](examples/variants/compat.tex), qui est
écrit entièrement avec les noms de la v0.

Ces alias sont destinés à disparaître : chaque ligne supprimée de
`ocots-compat.sty` est une migration terminée.

## Compilation des exemples

```bash
cd examples && make        # les quatre supports + les variantes d'options
```

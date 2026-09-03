# Template `ocots` — v1

Template LaTeX pour polycopiés, diapositives, TD et sujets d'examen.

La v1 est la refonte de l'**architecture** du template historique
([`../template/`](../template), gelé). Le rendu visuel reste proche de celui de
la v0 ; c'est la v2 qui le reprendra. Notes de conception dans
[`../template-refonte/`](../template-refonte).

## Prise en main

Un polycopié :

```latex
\documentclass[11pt,twoside]{ocots-book}
\usepackage[lang=fr, theme=n7, solutions=end, math=analysis]{ocots}

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
\usepackage[lang=fr, theme=n7-dark]{ocots}
```

Un TD ou un sujet d'examen :

```latex
\documentclass[11pt]{ocots-td}     % ou ocots-exam
\usepackage[lang=fr, solutions=none, institution=insa,n7]{ocots}
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
| `theme` | `n7`, `n7-dark`, `n7-light`, `bw` | `n7` (papier), `n7-dark` (diapos) | couleurs et formes |
| `solutions` | `none`, `inline`, `end` | `end` | sort des corrigés |
| `math` | `base`, `analysis`, `control`, `measure` | `base` | modules de macros chargés |
| `institution` | `n7`, `inp`, `insa`, `uftmp` | `n7` | logos de la page de titre |
| `author` | texte | vide | métadonnée `pdfauthor` |
| `draft` | drapeau | absent | affiche les notes de travail |
| `layout` | `standard`, `fiche` | `standard` | mise en page |
| `binding` | longueur | `0mm` | décalage de reliure pour l'impression |

Chaque valeur se résout en un nom de fichier : `theme=foo` charge
`tex/theme/ocots-theme-foo.sty`. **Ajouter un thème, une langue ou un module de
macros, c'est ajouter un fichier** — le noyau n'est pas touché.

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
  theme/                 apparence : n7, n7-dark, n7-light, bw, + socle commun
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

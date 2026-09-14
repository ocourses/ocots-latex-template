# Référence des commandes `ocots`

> [`README.md`](../README.md) · **commandes.md** · [`doc/notations.md`](notations.md) · [`doc/themes.md`](themes.md)

Tout ce que le template met à disposition dans un document, par thème. Les
environnements sont **définis une seule fois** : un énoncé se colle tel quel du
TD au polycopié.

Sommaire : [environnements](#environnements) · [exercices et corrigés](#exercices-et-corrigés)
· [mise en valeur](#mise-en-valeur) · [notes de travail](#notes-de-travail)
· [mathématiques](#mathématiques) · [dessins et tableaux](#dessins-et-tableaux)
· [diapositives](#diapositives) · [TD et examens](#td-et-examens)
· [page de titre](#page-de-titre-et-métadonnées) · [langue](#chaînes-de-langue)

---

## Environnements

### Résultats — une signature et un compteur commun

Les huit environnements de résultats acceptent une liste de clés optionnelle :
`title=`, `label=` et `note=`. Le label est posé **tel quel** : le template
n'ajoute aucun préfixe.

```latex
\begin{theorem}[title={Théorème de Cauchy-Lipschitz}, label=thm:cauchy]
    Un énoncé. Se cite par \ref{thm:cauchy}.
\end{theorem}

\begin{definition}[label=def:ouvert]
    Un énoncé sans titre supplémentaire.
\end{definition}

\begin{example}[note={Cas particulier}, label=exa:cas]
    Un exemple numéroté.
\end{example}

\begin{remark}                         % aucune clé n'est obligatoire
    Une remarque non étiquetée.
\end{remark}
```

| environnement | compteur | variante étoilée | intitulé (fr) |
|---------------|----------|------------------|---------------|
| `theorem` | partagé, dans la section | — | Théorème |
| `definition` | partagé, dans la section | — | Définition |
| `proposition` | partagé, dans la section | — | Proposition |
| `corollary` | partagé, dans la section | — | Corollaire |
| `conjecture` | partagé, dans la section | — | Conjecture |
| `lemma` | partagé, dans la section | `lemma*` | Lemme |
| `example` | partagé, dans la section, carré blanc | `example*` | Exemple |
| `remark` | partagé, dans la section | `remark*` | Remarque |

Les variantes étoilées sont non numérotées. La forme (cadre, filet, aplat…) vient
du thème. Les familles `assumption`, `openquestion`, `difficulty` et `exercise`
conservent leurs compteurs propres.

### Introduction de chapitre — retrait configurable par le thème

À l'ouverture d'un chapitre, composer le texte d'introduction dans `chapterintro` plutôt
que de détourner `quote` ou `quotation` :

```latex
\chapter{Théorie de la mesure}
\minitoc
\begin{chapterintro}
    Ce chapitre présente les notions nécessaires à la définition de l'intégrale.
\end{chapterintro}
```

L'environnement n'ajoute ni guillemets ni titre : son retrait et ses espacements
sont fournis par le thème via le style `chapterintro`.

### Blocs étiquetés — filet latéral ou simple retrait

| environnement | étiquette | étoilé |
|---------------|-----------|--------|
| `assumption` | H1, H2, … | `assumption*` (non étiqueté) |
| `openquestion` | Q1, Q2, … | `openquestion*` |
| `difficulty` | D1, D2, … | `difficulty*` |

Une seule fabrique interne les produit : en ajouter une quatrième tient en une
ligne (`\ocots@taggedenv` dans `ocots-env.sty`).

### Preuves

```latex
\begin{proof}                         % marqueur ▷ en tête, ∎ en fin
\end{proof}

\begin{proof}[Démonstration de la proposition~\ref{prop:x}]   % marqueur remplacé
\end{proof}
```

Preuve étalée sur plusieurs diapositives — seul `proofend` pose le carré final :

```latex
\begin{proofbegin} … \end{proofbegin}
\begin{proofmiddle} … \end{proofmiddle}
\begin{proofend} … \end{proofend}
```

| macro | effet |
|-------|-------|
| `\newstep` | astérisque centré, sépare deux étapes d'une preuve |
| `\QEDA` | `\hfill∎` (carré noir) |
| `\QEDB` | `\hfill□` (carré blanc) |

### Renvoi vers une ressource en ligne

```latex
\begin{web}[Documentation en ligne du cours]
    Texte du renvoi, précédé du pictogramme ⎋.
\end{web}
```

### Numérotation de problèmes

```latex
\begin{equation}
    \min_u \int_0^{t_f} \ell(x,u)\,\dif t   \problemtag      % (P₁), (P₂)…
\end{equation}
```

---

## Exercices et corrigés

```latex
\ocotscollectsolutions                    % début de partie (mode end)

\begin{exercise}[label=matrices, points=4]
    Énoncé.
\solution
    Corrigé.
\end{exercise}

\ocotsprintsolutions                      % où les corrigés doivent paraître
```

| clé de `\begin{exercise}[…]` | effet |
|------------------------------|-------|
| `label=<nom>` | pose `\label{<nom>}` tel quel |
| `points=<n>` | affiche `(n points)` après le numéro |
| `nosolution` | exclut ce corrigé quel que soit le mode |

- **`\solution` est une commande, pas un environnement** (`\begin{solution}`
  ouvrirait un groupe et la séparation haut/bas d'une `tcolorbox` doit se faire
  au premier niveau).
- L'option `solutions=none|inline|end` du paquet décide du reste. En `none` et
  `inline`, `\ocotscollectsolutions` / `\ocotsprintsolutions` sont des
  instructions vides : **le document ne change pas d'un mode à l'autre**.

### Questions

| environnement / macro | effet |
|-----------------------|-------|
| `question` | numérotée dans l'exercice (1., 2., …), remet les sous-questions à zéro |
| `subquestion` | 2.1., 2.2., … |
| `\newquestion` | force le passage à la question suivante (corrigé rédigé à part) |
| `\exercisenotext` | avale la ligne vide quand l'énoncé n'a pas de texte d'intro |

### Correction hors boîte (TD, examen)

```latex
\begin{correction}       % ▷ + texte coloré ; disparaît en solutions=none
\end{correction}
```

---

## Mise en valeur

| macro | rendu |
|-------|-------|
| `\keyword{…}` | terme important (gras + couleur d'accent) — redéfinissable |
| `\emphA{…}` `\emphB{…}` `\emphC{…}` `\emphD{…}` | les quatre couleurs du thème |
| `\emphLink{…}` | couleur des liens |
| `\cmark` `\xmark` | ✓ ✗ |
| `\handwrite` | ✍ (main, couleur d'accent) — précédait les exercices en v0 |
| `\newpoint` | puce colorée |
| `\breakline` | saut de ligne sans alinéa (`~\\ \vspace{-\baselineskip}`) |
| `\HRule` | filet pleine largeur, fin |
| `\myurl{…}` | `\href{url}{url}` |
| `\ie` `\cf` | abréviations localisées, avec espacement automatique |

### Guillemets

Utiliser `\enquote{…}` pour des guillemets adaptés à la langue déclarée par
`lang=`. Le paquet `csquotes` est chargé par le template avec `autostyle=true` :

```latex
\enquote{un texte cité, avec \enquote{une citation imbriquée}}
```

La même source produit des guillemets français avec `lang=fr` et anglais avec
`lang=en`.

### Blocs annexes

| macro | rendu (fr) |
|-------|------------|
| `\supplement{…}` | *Supplément : …* (vert) |
| `\reminder{…}` | *Rappels : …* (rouge) |

### Noms de logiciels

`\lib{…}` `\vrb{…}` `\cmd{…}` (police machine à écrire), et les raccourcis
`\matlab` `\octave` `\fortran` `\python` `\julia`.

### Numérotation des équations

`\leqnomode` / `\reqnomode` : numéro à gauche / à droite.

---

## Notes de travail

Visibles **seulement avec l'option `draft`**, invisibles sinon.

| macro / env | rendu |
|-------------|-------|
| `\notework{…}` | *Note : …* au fil du texte |
| `\noteinmargin{…}` | note en marge |
| `\worktodo{…}` | *À FAIRE : …* |
| `worknotes` (env) | bloc entier, exclu hors `draft` |
| `\marginnote[décalage]{l\|r}{texte}` | note encadrée en marge, avec pointeur (toujours affichée) |

### Code source

`lstlisting` est préréglé : `breaklines`, coloration syntaxique qui suit la
palette (commentaires en vert italique, mots-clés en gras). L'**habillage**
(cadre ou liseré, numéros de ligne) vient du thème — `card` (liseré en équerre,
numéros en marge) pour `ocots`, `framed` (cadre complet) pour `legacy` ;
`listing=card|framed` surcharge.

```latex
\begin{lstlisting}[language=Python, caption={Une méthode d'Euler}]
def euler(f, t0, x0, tf, n):
    ...
\end{lstlisting}
```

---

## Mathématiques

Les modules mathématiques sont chargés **à la carte** par l'option `math=` ;
`base` est toujours chargé. Les noms, signatures, rendus et exemples sont
référencés dans la fiche dédiée [`doc/notations.md`](notations.md).

```latex
\usepackage[lang=fr, math={analysis,measure}]{ocots}
```

La fiche couvre notamment les ensembles (`\R`, `\Rpos`, `\Sphere`), les
constructions (`\norm`, `\abs`, `\inner`, `\setst`, `\functiondef`), les
intervalles (`\intervalcc`, `\intervaloo`), les opérateurs localisés (`\rank`,
`\spanop`, `\graph`) et les modules `analysis`, `control` et `measure`.

Les options `setfont=bb|rm` et `calfont=custom|scr|cal` règlent respectivement la
police des ensembles de nombres et des familles calligraphiques. Le mode
`custom` est le défaut : il compose `\Neighborhoods`, `\TimeInterval`,
`\AllMaps`, `\GenericNorm`, `\FlowDomain`, `\Reachable` et `\MatrixSpace` en
mathcaligraphique, tout en conservant le choix
historique pour les autres familles. Les anciens
noms sont conservés par `ocots-compat.sty` pour la migration, mais tout nouveau
document doit utiliser les noms de [`notations.md`](notations.md).

---

## Dessins et tableaux

### Fenêtre de tracé TikZ

Options sur `tikzpicture` : `xmin`, `xmax`, `ymin`, `ymax` (défaut ±3).

| macro | effet |
|-------|-------|
| `\grille` | grille `help lines` de la fenêtre |
| `\fenetre` | `\clip` sur la fenêtre |
| `\axes{$x$}{$y$}` | axes fléchés gris + étiquettes |
| `\axesDown{$t$}{$x$}` | idem, axe vertical vers le bas |
| `\gettikzxy{(nœud)}{\x}{\y}` | récupère les coordonnées d'un nœud |

### Annotation d'une image bitmap

```latex
\begin{tikzgraphics}{6cm}{2546}{552}{logo-insa}   % largeur, W px, H px, fichier
    \pxnode[anchor=west]{2600}{276}{repère}{$\leftarrow$ ici}
\end{tikzgraphics}
```

### Tableaux

| macro | effet |
|-------|-------|
| `C{3cm}` `L{3cm}` | colonnes `p{}` centrée / alignée à gauche, largeur fixe |
| `\Tstrut` `\Bstrut` | cales verticales haut / bas de cellule |
| `\smallhrule` `\medhrule` `\bighrule` | filets d'épaisseurs graduées (`specialrule`) |

---

## Diapositives

Support déduit de la classe `beamer`, rien à déclarer.

```latex
\slidechapter{5}{Équations différentielles linéaires}   % pose le n° de chapitre
\slidetitlepage                                         % page de titre standard
% ou, avec un contenu additionnel sous auteur/date/logos :
\slidetitlepage[{\includegraphics[height=5em]{qr-code-cours.pdf}}]

\begin{slide}{Titre}                       … \end{slide}
\begin{slide}[\ocotscolor{slide2}]{Titre}  … \end{slide}   % couleur ponctuelle
\begin{slide}                              … \end{slide}   % sans titre
```

`slide` est l'environnement unique pour une diapositive. Son titre est
optionnel : avec un titre, le template ajoute le bandeau, le filet et le
compteur ; sans titre, il conserve le rendu d'un `frame` nu, sans bandeau ni
filet. La couleur entre crochets reste une surcharge ponctuelle, et
`\slidecolor{…}` règle la couleur des diapositives suivantes. `frame` reste
valide comme environnement natif de beamer pendant la migration progressive
des cours.

Le titre est détecté par la présence d'un groupe `{…}` immédiatement après
`\begin{slide}` (ou son option de couleur) : le premier groupe accolade
rencontré est toujours pris pour le titre, sans exception. Un `slide` sans
titre dont le corps commence lui-même par un groupe brut — `{\small …}` pour
une portée locale, par exemple — serait donc pris pour un titre,
silencieusement si ce groupe ne contient pas de saut de paragraphe (sinon
LaTeX signale une erreur « Paragraph ended before \ocots@slidetitle was
complete »). Dans ce cas précis, remplacer le groupe accolade par
`\begingroup … \endgroup`, qui ne déclenche pas la détection.

L'argument optionnel de `\slidetitlepage` est vide par défaut. Lorsqu'il est
renseigné, son contenu est placé sous le bloc auteur/date/logos, dans le même
centrage. Les appels existants sans argument restent donc inchangés. Lorsque le
contenu contient lui-même des crochets optionnels, comme ceux de
`\includegraphics`, on le groupe entre accolades dans l'argument externe.

| macro | effet |
|-------|-------|
| `\slidecolor{…}` | change la couleur d'en-tête pour toutes les diapos suivantes |
| `\slidecounter` | le numéro cerclé en haut à droite, disponible pour un usage explicite et posé automatiquement par `slide` titré |

Les diapositives utilisent les couleurs du thème pour `\alert`, les liens
internes (`\href`, `\hyperref`), les URL (`\url`, `\myurl`) et les entrées de
table des matières. Le thème `ocots` est le défaut, mais les autres thèmes
(`legacy`, `charter`, `slate`) restent utilisables explicitement.

Les preuves fractionnées (`proofbegin`/`proofmiddle`/`proofend`) et la remise à
zéro des compteurs entre deux `\pause` sont gérées par le support.

---

## TD et examens

Classes `ocots-td` et `ocots-exam`. Métadonnées portées par les en-têtes :

| macro | rôle |
|-------|------|
| `\title{…}` / `\shorttitle{…}` | titre long / titre des pages suivantes |
| `\numero{…}` | référence du document |
| `\date{…}` | année |
| `\discipline{…}` | matière |
| `\promotion{…}` | public |

Sur `ocots-td` et `ocots-exam`, `\maketitle` compose le titre sous un
en-tête de première page (`plain`) : les logos sont à gauche, la promotion et
la discipline au centre, la date et la référence à droite. Les pages suivantes
conservent leur en-tête court.

Pour `ocots-exam`, les champs renseignés sont ensuite composés dans l'ordre
`\duree`, `\documents`, `\calculatrice`, puis `\examnote` :

```latex
\duree{1h30}
\documents{deux feuilles A4 recto-verso manuscrites}
\calculatrice{interdite}
\examnote{Les parties sont indépendantes.}
```

Un champ absent n'ajoute ni ligne vide ni libellé. `\examnote` est le hook libre
pour les consignes qui ne correspondent à aucun champ standard. `\maketitle`
appelle automatiquement `\printinstructions` pour un examen ; cette commande
peut aussi être appelée explicitement si l'auteur veut placer le bloc ailleurs.
Les anciennes formes `instruction` et `instructions` restent valides ; elles
permettent la migration progressive et ne sont pas composées automatiquement si
aucun nouveau champ n'est renseigné.

Les environnements propres sont `instruction`, `instructions` (non numérotés) et
`docpart` (Partie 1, 2, …). Chaque `points=<n>` d'un `exercise` alimente le
barème de la partie courante et le total du sujet. Le total de chaque partie est
imprimé avant la partie suivante, et le total général à la fin du sujet :

```latex
\begin{docpart}
    Analyse
\end{docpart}
\begin{exercise}[points=8]
    Énoncé.
\end{exercise}
```

Le barème est la somme des clés `points=` ; il n'est pas normalisé sur 20 et ne
doit pas être recopié en prose. Un exercice sans `points=` reste valide, mais ne
contribue pas au total calculé.

---

## Page de titre et métadonnées

### Polycopié (`ocots-book`)

```latex
\title{…}   \author{Prénom \textsc{Nom}}   \date{\today}
\subtitle{…}                    % facultatif
\makeindex                      % si un index est voulu
\begin{document}
\maketitle
\tableofcontents
```

### Logos

`\ocotslogos[hauteur]` compose les logos de page de titre demandés par
l'option `institution=` (`n7`, `inp`, `insa`, `uftmp` ; plusieurs valeurs entre
accolades). Pour un en-tête de TD ou d'examen, le support utilise
`\ocotslogosheader[hauteur]` : tous les établissements sont alignés sur une
seule ligne à une hauteur commune, y compris `uftmp`. La disposition spéciale
de `uftmp` (grand à gauche, établissements empilés à droite) reste réservée
aux pages de titre. Ajouter un établissement = déposer l'image dans
`assets/logos/` + une ligne dans `ocots-institution.sty`.

Les pages de titre des polycopiés et des diapositives ne sont pas concernées
par le placement des logos dans l'en-tête article.

---

## Chaînes de langue

`\ocotsstring{<clef>}` compose une chaîne dans la langue courante (`lang=fr|en`).
Une chaîne absente donne `?clef?` et un avertissement, pas une erreur.

Clefs : `theorem` `definition` `proposition` `corollary` `conjecture` `lemma`
`example` `remark` `assumption` `chapter-label` · `exercise` `solution`
`correction` `question` `part` `instruction` `instructions` `points`
`page-abbr` `solution-at` `solution-of` · `supplement` `reminder` `note` `todo`
· `op-rank` `op-minimize` `op-graph`.

Ajouter une langue = copier `tex/lang/ocots-lang-fr.def`, traduire, `lang=<code>`.

---

## Compatibilité v0

Les noms de la v0 (`mytheorem`, `myexercisecb<étiquette>`, `\solutioncb`,
`\myemph`, `no solution`, `\cblue`, `\tagProblem`…) restent définis par
`tex/ocots-compat.sty`
— pour migrer au fil de l'eau, pas en bloc. Les anciens noms d'environnement
produisent un avertissement de compilation, une seule fois par run, lorsqu'ils
sont utilisés. **Rien de neuf ne doit les utiliser** ; chaque ligne supprimée
de ce fichier est une migration terminée.

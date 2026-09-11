# Référence des commandes `ocots`

> [`README.md`](../README.md) · **commandes.md** · [`doc/themes.md`](themes.md)

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
    \min_u \int_0^{t_f} \ell(x,u)\,\xdif t   \tagProblem      % (P₁), (P₂)…
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
| `label=<nom>` | pose `\label{ex:<nom>}` |
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
| `\ie` `\cf` | *i.e.* / cf. |

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

Chargées **à la carte** par l'option `math=` (séparateur virgule, valeur entre
accolades : `math={analysis,control}`). `base` est toujours là.

### `math=base` — toujours chargé

| domaine | macros |
|---------|--------|
| ensembles | `\N \Z \Q \R \C \K \Sn` |
| ensembles décorés | `\Nb \Ns \Nsb` · `\Rn \Rp \Rb \Rbp \Rs \Rsp \Rsn` (barre, étoile, signe) |
| classes | `\M \B \E \F \D \O \P \Vcal \Ical \Sgot` · `\ind` (indicatrice) |
| valeur absolue, norme | `\abs{…} \norm{…}` et leurs variantes `…Style` (délimiteurs extensibles) |
| produit scalaire | `\prodscal{u}{v}` |
| ensemble défini | `\enstq{x}{P(x)}` → `{ x | P(x) }` |
| application | `\fonction{f}{E}{F}{x}{f(x)}` (tableau `array`) |
| intervalles | `\intervalleff \intervalleof \intervallefo \intervalleoo` (f=fermé, o=ouvert), `\intervalleentier` — l'ouvert suit la langue (`]a,b[` / `(a,b)`) |
| matrices | `\semidefpos \defpos \defneg` |
| grec | `\veps \vphi` |
| opérateurs | `\argmax \codim \rank \rang \vect \im \Im \trace \sign \Ker \ker \diag \id \Hom \GL \sym \card \dd \minimize \graphe` … |
| barre ajustée | `\xoverline[ratio]{expr}` — remplace `\bar` sur les symboles larges |

### `math=analysis` — calcul différentiel, EDO

| domaine | macros |
|---------|--------|
| éléments différentiels | `\xdif \xDif \diff \Diff \pardiff` |
| dérivées partielles | `\frp{f}{x}` `\frpp{f}{x}` `\frpij{f}{x}{y}` `\frpxx \frptt \frpuu \frpxu \frpux` |
| gradient | `\grad{f}` ou `\grad{f}{x}` |
| Landau | `\petito{h} \grandO{h}` |
| topologie | `\adherence{A}` `\Ball` `\BallClosed` |
| espaces | `\Htrue \Ccal \Lcal \Dcal \Ucal \Acal \Ecal \Fcal \Kcal \Ncal \GLcal` · `\xCn{k}` (classe Cᵏ) · `\xLn{k}` (linéaires continues) |
| quotient | `\EnsembleQuotient{E}{R}` |
| convergence | `\convn` |
| solutions (notation barre) | `\xsol \ysol \zsol \ssol \tsol \lsol` |
| commutateur de matrices | `\Lie{A}{B}` = `[A,B]` |

### `math=control` — contrôle optimal, homotopie, tir

`\rsol \fsol \usol \psol \tfsol` · homotopie `\sbar \cbar \lbar \sphere \laz \hom`
· décorées `\xt \ut \pt \ft \ct \Et \Ucalt \Acalt \Phit`
· `\crochetDualite{p}{v}` `\expmap{x}{t}{v}` `\arc`
· logiciels `\hampath \bocop \cotcot \nutopy \controltoolbox \tapenade \lapack \minpack`

### `math=measure` — mesure et intégration

`\tribu \Bor \AT \BT \NT \CT \OT \FT \Parties` · `\FM` (mesurable) `\FE` (étagée)
· `\cl{f}` (classe d'équivalence) · `\convps` (→ p.p.)

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
\begin{slide}[\ocotscolor{slide2}]{Titre}  … \end{slide}   % couleur d'en-tête ponctuelle
```

L'argument optionnel de `\slidetitlepage` est vide par défaut. Lorsqu'il est
renseigné, son contenu est placé sous le bloc auteur/date/logos, dans le même
centrage. Les appels existants sans argument restent donc inchangés. Lorsque le
contenu contient lui-même des crochets optionnels, comme ceux de
`\includegraphics`, on le groupe entre accolades dans l'argument externe.

| macro | effet |
|-------|-------|
| `\slidecolor{…}` | change la couleur d'en-tête pour toutes les diapos suivantes |
| `\slidecounter` | le numéro cerclé en haut à droite (posé automatiquement par `slide`) |

Les diapositives utilisent les couleurs du thème pour `\alert`, les liens
internes (`\href`, `\hyperref`), les URL (`\url`, `\myurl`) et les entrées de
table des matières. Le thème `ocots` est le défaut, mais `legacy-dark` et les
autres thèmes restent utilisables explicitement.

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

`\maketitle` compose logos + titre. Environnements propres : `instruction`,
`instructions` (non numérotés), `docpart` (Partie 1, 2, …).

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

`\ocotslogos[hauteur]` compose les logos demandés par l'option
`institution=` (`n7`, `inp`, `insa`, `uftmp` ; plusieurs valeurs entre
accolades). `uftmp` demandé avec d'autres passe en grand à gauche, les autres
empilés à droite. Ajouter un établissement = déposer l'image dans
`assets/logos/` + une ligne dans `ocots-institution.sty`.

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
`\myemph`, `no solution`, `\cblue`…) restent définis par `tex/ocots-compat.sty`
— pour migrer au fil de l'eau, pas en bloc. **Rien de neuf ne doit les
utiliser** ; chaque ligne supprimée de ce fichier est une migration terminée.

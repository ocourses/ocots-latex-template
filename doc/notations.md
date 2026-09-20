# Notations mathématiques `ocots`

Cette fiche est la référence des macros mathématiques publiques du template. Les
noms sont en anglais pour rester stables entre les langues ; le rendu des
opérateurs et la police des familles suivent les options du document.

```latex
\usepackage[lang=fr, math={analysis,measure}]{ocots}
```

`base` est toujours chargé. Les modules `analysis`, `control` et `measure` sont
chargés à la carte avec `math=` ; plusieurs valeurs doivent être protégées par
des accolades.

## Options de police

| Option | Valeurs | Défaut | Effet |
|---|---|---|---|
| `setfont` | `bb`, `rm` | `bb` | police des ensembles de nombres : `\mathbb` ou `\mathrm` |
| `calfont` | `custom`, `scr`, `cal` | `custom` | police des familles nommées : choix macro par macro, `\mathscr` ou `\mathcal` |

Le mode `custom` est le défaut : `\Neighborhoods`, `\TimeInterval`, `\AllMaps`, `\GenericNorm`, `\FlowDomain`, `\Reachable` et `\MatrixSpace` sont
composées en `\mathcal`, tandis que les autres familles
conservent leur rendu historique. `calfont=cal` impose `\mathcal` partout et `calfont=scr` impose
`\mathscr` partout. Par exemple, `\usepackage[setfont=rm, calfont=cal]{ocots}`
compose `\R` en `\mathrm{R}` et toutes les macros de familles en `\mathcal`.

## Module `base`

### Ensembles de nombres

| Macro | Notation |
|---|---|
| `\N`, `\Z`, `\Q`, `\R`, `\C`, `\K` | ensembles usuels |
| `\Sphere` | sphère `S` |
| `\Rnonneg`, `\Rnonpos` | réels positifs ou nuls, négatifs ou nuls |
| `\Rpos`, `\Rneg` | réels strictement positifs, strictement négatifs |
| `\Rstar` | réels non nuls |
| `\Rbar`, `\Rbarnonneg` | droite réelle achevée, version positive ou nulle |
| `\Nbar`, `\Nstar`, `\Nbarstar` | variantes décorées de `\N` |

Les macros d’ensembles sont utilisables directement en mathématiques :

```latex
$\Rpos \subset \R$, $\Nstar = \N \setminus \{0\}$.
```

### Familles et lettres calligraphiques

| Macro | Sens |
|---|---|
| `\Neighborhoods` | voisinages |
| `\TimeInterval` | intervalle de temps |
| `\ContinuousLinear` / `\ContinuousLinear{k}` | espaces `\mathscr{L}` / `\mathscr{L}^k` des applications linéaires / `k`-linéaires continues |
| `\Cclass{k}` | applications de classe `C^k` |
| `\AllMaps` | ensemble des applications |
| `\MultilinearSpace` | espace des applications multilinéaires |
| `\Reachable` | ensemble atteignable |
| `\FlowDomain` | domaine de définition du flot |
| `\Differentiable` | ensemble des applications différentiables en un point |
| `\SolutionSpace` | espace des solutions d'une équation différentielle (linéaire homogène) |
| `\GenericNorm` | norme générique, sans rapport avec une notation déjà fixée |
| `\MatrixSpace` | espace des matrices, p. ex. `\MatrixSpace_n(\R)`, `\MatrixSpace_{m,n}(\R)` |
| `\Orbit` | orbite d'un point pour un système dynamique |
| `\calset{A}` | lettre calligraphique générique, selon `calfont` |
| `\indicator` | fonction indicatrice `\mathds{1}` |

`\calset{A}` est prévu pour les lettres propres au cours, lorsque le nom du
concept n’est pas assez stable pour justifier une macro dédiée.

### Constructions

| Macro | Usage |
|---|---|
| `\abs{x}` / `\abs*{x}` | valeur absolue, délimiteur fixe ou extensible |
| `\norm{x}` / `\norm*{x}` | norme, délimiteur fixe ou extensible |
| `\inner{x}{y}` | produit scalaire |
| `\setst{x}{P(x)}` | ensemble des `x` tels que `P(x)` |
| `\functiondef{f}{E}{F}{x}{f(x)}` | définition d’une application |
| `\intervalcc{a}{b}` | intervalle fermé-fermé |
| `\intervaloc{a}{b}` | intervalle ouvert-fermé |
| `\intervalco{a}{b}` | intervalle fermé-ouvert |
| `\intervaloo{a}{b}` | intervalle ouvert-ouvert |
| `\intervalint{p}{q}` | intervalle entier `⟦p,q⟧` |
| `\possemidef`, `\posdef`, `\negdef` | comparaison de matrices |
| `\xoverline{A}` | barre ajustée aux symboles larges |

Les variantes étoilées de `\abs` et `\norm` sont fournies par
`mathtools` et choisissent automatiquement la taille des délimiteurs.

### Opérateurs

Les noms restent les mêmes en français et en anglais lorsque le concept est
standard. Le rendu des opérateurs localisés suit `lang=`.

| Macro | Rendu français | Sens |
|---|---|---|
| `\rank` | rang | rang |
| `\spanop` | Vect | espace engendré |
| `\cofactor` | com | comatrice |
| `\graph` | graphe | graphe |
| `\sinh`, `\argsinh` | sh, argsh | fonctions hyperboliques |
| `\argmax`, `\codim`, `\trace`, `\supp`, `\sign` | — | opérateurs usuels |
| `\im`, `\Ker`, `\diag`, `\id`, `\Hom`, `\GL`, `\Isom` | — | opérateurs usuels |
| `\inv`, `\sym`, `\card`, `\minimize` | — | opérateurs usuels |

## Module `analysis`

| Macro | Usage |
|---|---|
| `\dif` | différentielle `\mathrm{d}` |
| `\Dif` | différentielle de Fréchet `\mathrm{D}` |
| `\partialop` | symbole `\partial` |
| `\pd{f}{x}` | dérivée partielle première |
| `\pdd{f}{x}{y}` | dérivée partielle seconde, mixte ou non |
| `\grad{f}` / `\grad{f}{x}` | gradient, éventuellement indexé |
| `\smallo{h}` / `\bigO{h}` | notations de Landau |
| `\closure{A}` | adhérence |
| `\ball` / `\closedball` | boule ouverte / fermée |
| `\quotient{E}{R}` | quotient `E/R` |
| `\sol{x}` | valeur ou solution notée `\bar{x}` |
| `\Lie{A}{B}` | commutateur `[A,B]` |

Les cas particuliers de dérivées secondes (`xx`, `tt`, `xu`, etc.) sont tous
écrits avec `\pdd` :

```latex
$\pdd{f}{x}{x}$, $\pdd{f}{x}{u}$.
```

## Module `control`

Ce module regroupe les notations propres au contrôle optimal et à
l’homotopie :

| Famille | Macros |
|---|---|
| solutions paramétrées | `\rsol`, `\fsol`, `\usol`, `\psol`, `\tfsol` |
| homotopie | `\sbar`, `\cbar`, `\lbar`, `\sphere`, `\laz`, `\hom` |
| lettres décorées | `\xt`, `\ut`, `\pt`, `\ft`, `\ct`, `\Et`, `\Ucalt`, `\Acalt`, `\Phit` |
| dualité et flots | `\crochetDualite`, `\expmap`, `\arc` |
| logiciels | `\hampath`, `\bocop`, `\cotcot`, `\nutopy`, `\controltoolbox`, `\tapenade`, `\lapack`, `\minpack` |

## Module `measure`

| Macro | Sens |
|---|---|
| `\Borel` | tribu borélienne |
| `\PowerSet` | ensemble des parties |
| `\Measurable` | fonctions mesurables |
| `\Simple` | fonctions étagées |
| `\eqclass{x}` | classe d’équivalence de `x` |
| `\convae` | convergence presque partout |

Les lettres propres à une tribu ou à une famille d’ensembles s’écrivent avec
`\calset`, par exemple `\calset{A}`, `\calset{F}`.

## Compatibilité et migration

Les anciens noms sont conservés dans `ocots-compat.sty` afin que les cours
existants compilent pendant leur migration. Ils émettent un avertissement et ne
devraient pas être utilisés dans un nouveau document. Les noms supprimés sans
équivalent sémantique ne sont pas réintroduits ; les exemples officiels
exercent désormais les nouveaux noms.

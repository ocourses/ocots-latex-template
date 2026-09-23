# Exemples du template

Trois rôles :

1. **Test de non-régression** — `make` doit toujours être vert.
2. **Documentation** — un exemple vaut mieux qu'une page de manuel. Dans
   `content/`, chaque construction démontrée (environnement, macro) est
   montrée en paire **code puis rendu** : le lecteur voit le `\begin{...}`
   qui produit exactement ce qui suit.
3. **Base de comparaison de thèmes** — un répertoire par thème, avec les
   quatre mêmes supports et les mêmes options isolées, pour mettre deux PDF
   côte à côte.

## Un dossier par thème, quatre supports chacun

```text
examples/themes/<theme>/{poly,slides,td,exam}.tex
```

pour chacun des quatre thèmes (`ocots`, `legacy`, `charter`, `slate`) :

| Fichier | Support | Classe | Montre |
|---------|---------|--------|--------|
| `poly.tex`  | polycopié       | `ocots-book`  | le plus complet — c'est la vitrine |
| `slides.tex` | diapositives   | `beamer`      | diapositives `slide` titrées et sans titre, surcharges de couleur |
| `td.tex`     | travaux dirigés| `ocots-td`    | un TD complet, corrigés en fin de séance |
| `exam.tex`   | examen         | `ocots-exam`  | champs d'en-tête d'un sujet, calcul du barème par partie et pour le sujet |

Un même document (par exemple `poly.tex`) est **identique d'un thème à
l'autre** à l'exception de la ligne `theme=` : ouvrir
`themes/ocots/poly.pdf` et `themes/legacy/poly.pdf` côte à côte montre que
`theme=` redessine sans qu'une ligne du contenu ne change.

## Contenu partagé

`content/` porte le contenu de démonstration une seule fois — huit fichiers,
`\input` par les 16 documents `themes/*/{poly,slides,td,exam}.tex` et par les
68 variantes de facette `themes/*/variants/` :

| fichier | utilisé par |
|---------|-------------|
| `boxes.tex`, `blocks.tex`, `exercises.tex`, `math.tex`, `text.tex` | `poly.tex`, un thème à la fois |
| `slides-body.tex` | `slides.tex` |
| `td-body.tex` | `td.tex` |
| `exam-body.tex` | `exam.tex` |
| `variant-body.tex` | les 68 variantes de facette (`themes/*/variants/`) |

C'est la démonstration de l'étape 2 de la refonte : un énoncé ne dépend ni du
support qui le compose, ni du thème qui l'affiche.

## Variantes indépendantes du thème

`variants/` (à la racine) compile le **même corps** avec des options
différentes ; seule la ligne `\usepackage` change. Toutes utilisent le thème
par défaut (`ocots`) — ce ne sont pas des comparaisons de thème, voir plus bas.

| Fichier | Ce qu'il montre |
|---------|-----------------|
| `fr-none.tex`   | corrigés absents — la version étudiante |
| `fr-inline.tex` | corrigés en place |
| `en-end.tex`    | même contenu en anglais, corrigés reportés |
| `compat.tex`    | un corps écrit **avec les noms de la v0**, compilé aujourd'hui |
| `slides-hook.tex` | page de titre Beamer avec contenu optionnel sous auteur/date/logos |
| `header-article.tex` | TD multi-établissement : logos `uftmp` et `n7` côte à côte dans l'en-tête |
| `institution-inp.tex`, `institution-insa.tex` | en-tête TD à établissement unique, autres que le défaut `n7` |
| `math-modules.tex` | `math={control,measure}` — syntaxe multi-valeurs entre accolades + corpus des deux modules |
| `draft.tex`     | option `draft` : `\notework`, `\noteinmargin`, `\worktodo`, `worknotes` visibles |
| `binding.tex`   | `binding=12mm` : décalage de reliure (`ocots-book` en `twoside`) |
| `paper-preprint.tex` | défauts de `ocots-paper` : anglais, thème `paper`, `math=none` |
| `paper-draft.tex` | `mode=draft` : thème `ocots` et marques visibles |
| `paper-fr.tex` | préprint avec `lang=fr` |
| `paper-preprint-workmark.tex` | test négatif : une marque fait échouer le preprint |

`fr-none`, `fr-inline`, `en-end`, `binding` partagent `body.tex`, un corps
minimal ; `draft` le complète d'une section de notes de travail. `compat.tex`
et `math-modules.tex` ont leur corps propre : le premier prouve que
l'ancienne syntaxe passe sans retouche, le second exerce des macros qui
n'existent que sous `math=control` / `math=measure`.

## Variantes par thème

`examples/themes/<theme>/variants/` isole **une seule facette**, appliquée
**par-dessus le thème du dossier** (pas par-dessus le défaut `ocots`) — c'est
ce qui répond à « qu'est-ce que cette option change, pour ce thème-là ? ».
Chaque PDF affiche en première page une note rappelant l'écart par rapport au
réglage par défaut du thème (le détail des notes est dans
[`doc/themes.md`](../doc/themes.md)).

Chaque facette est présentée **en entier** — une variante par valeur, nommée
`<facette>-<valeur>.tex` :

| fichier | montre |
|---------|--------|
| `variants/fonts.tex` | `setfont=`/`calfont=` par-dessus le thème du dossier |
| `variants/boxform-{plain,bracket,framed,sidebar,shaded}.tex` | les 5 formes de boîtes à titre |
| `variants/titles-{plain,rules,bignum}.tex` | les 3 dessins de titres |
| `variants/mathbox-{highlight,flat,rule,none}.tex` | les 4 encadrés de formule |
| `variants/listing-{card,framed,lines,shade}.tex` | les 4 habillages de code |

Soit 17 variantes par thème (68 au total). La valeur propre du thème figure
aussi (`listing-card` sous `ocots`, par exemple) : référence explicite, la
note du PDF la signale comme réglage par défaut forcé — la matrice prouve en
outre que chaque preset se charge sous chaque palette. Le filet latéral
(`siderule`) n'a pas de variante : il n'est pas pilotable par option.

## Compilation

```bash
make                        # tout : 16 supports, 68+14 variantes, verification
make themes                 # les 16 supports (4 themes x 4 supports)
make themes/legacy/poly     # un seul document
make theme-variants         # les 68 variantes de facette (par theme)
make variants               # les 14 variantes independantes du theme
make check                  # revérifie les journaux sans recompiler
make clean                  # nettoie les auxiliaires
make mrproper                # nettoie tout, PDF compris
```

`make poly` n'existe plus : le support ne suffit plus à désigner un fichier
à lui seul, il faut préciser le thème — `make themes/<theme>/<support>`.

`make` est **vert** si aucune erreur n'apparaît dans les journaux, **rouge** à
la moindre. Le motif d'erreur est `ERRPAT` dans le `Makefile` (il attrape aussi
les erreurs venues d'un `\input` de `../../content/`, ce que l'ancien `^\./`
ratait). La liste `KNOWN` sert à tolérer un défaut connu et documenté — elle
contient aujourd'hui l'avertissement bénin de `newtxmath` (thème `charter`,
famille `symbolsC` désactivée pour rester sous la limite des 16 familles
mathématiques de TeX) : `\nplus` garde la définition de `stmaryrd`, sans effet
visible.

Le template est trouvé par `TEXINPUTS`, positionné par le `Makefile` : les
documents n'ont aucun chemin relatif à tenir à jour.

# Exemples du template

Trois rôles :

1. **Test de non-régression** — `make` doit toujours être vert.
2. **Documentation** — un exemple vaut mieux qu'une page de manuel.
3. **Base de comparaison de thèmes** — le même contenu, deux thèmes, deux PDF
   à mettre côte à côte.

## Un document par support

| Répertoire | Support | Classe |
|------------|---------|--------|
| `poly/`   | polycopié      | `ocots-book` |
| `slides/` | diapositives   | `beamer` |
| `td/`     | travaux dirigés| `ocots-td` |
| `exam/`   | examen         | `ocots-exam` |

Chacun exerce tout ce que le template sait faire pour son support : toutes les
familles d'environnements, les trois modes de corrigés, les macros de mise en
valeur. `poly/main.tex` est le plus complet — c'est la vitrine.

## Contenu partagé

`content/` porte le contenu de démonstration une seule fois
(`boxes.tex`, `blocks.tex`, `exercises.tex`, `math.tex`, `text.tex`,
`slides-body.tex`), `\input` par `poly/main.tex` et par les variantes de
`variants/`. C'est la démonstration de l'étape 2 de la refonte : un énoncé ne
dépend pas du support qui le compose.

## Variantes d'options

`variants/` compile le **même corps** avec des options différentes ; seule la
ligne `\usepackage` change.

| Fichier | Ce qu'il montre |
|---------|-----------------|
| `fr-none.tex`   | corrigés absents — la version étudiante |
| `fr-inline.tex` | corrigés en place |
| `en-end.tex`    | même contenu en anglais, corrigés reportés |
| `mono-end.tex`  | noir et blanc (`theme=mono`), pour l'impression |
| `fonts.tex`     | options `setfont=rm` et `calfont=cal` |
| `compat.tex`    | un corps écrit **avec les noms de la v0**, compilé aujourd'hui |
| `theme-ocots.tex`   | thème `ocots` — le défaut (liseré en équerre, sans fond) |
| `theme-legacy.tex`  | thème `legacy` — le rendu historique (cadres pastel, titres entre filets) |
| `theme-charter.tex` | thème `charter` — Charter/Fira, filet latéral |
| `theme-slate.tex`   | thème `slate` — un seul accent, aplats teintés |
| `form-sidebar.tex` `form-shaded.tex` | `theme=ocots` + `boxform=` : même palette, boîtes redessinées |
| `titles-bignum.tex` | `theme=ocots` + `titles=bignum` : même palette, titres redessinés |

`fr-none`, `fr-inline`, `en-end`, `mono-end` partagent `body.tex`, un corps
minimal. `compat.tex` ne le partage pas : il prouve que l'ancienne syntaxe passe
sans retouche. Les `theme-*` partagent le contenu complet de `../content/` —
ouvrir deux PDF côte à côte montre que `theme=` redessine sans qu'une ligne du
document ne change.

## Compilation

```bash
make            # les quatre supports, les variantes, puis la vérification
make poly       # un seul support
make variants   # seulement les variantes
make check      # revérifie les journaux sans recompiler
make clean      # nettoie les auxiliaires
```

`make` est **vert** si aucune erreur n'apparaît dans les journaux, **rouge** à
la moindre. Le motif d'erreur est `ERRPAT` dans le `Makefile` (il attrape aussi
les erreurs venues d'un `\input` de `../content/`, ce que l'ancien `^\./`
ratait). La liste `KNOWN` sert à tolérer un défaut connu et documenté.

Le template est trouvé par `TEXINPUTS`, positionné par le `Makefile` : les
documents n'ont aucun chemin relatif à tenir à jour.

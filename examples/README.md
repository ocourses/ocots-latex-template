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
| `bw-end.tex`    | noir et blanc, pour l'impression |
| `compat.tex`    | un corps écrit **avec les noms de la v0**, compilé par la v1 |
| `theme-n7.tex`  | thème `n7` — recoloration de la v0 (socle commun, cadres pastel) |
| `theme-v2.tex`  | thème `v2` — refonte visuelle (filet latéral, titres alignés à gauche) |

`fr-none`, `fr-inline`, `en-end` et `bw-end` partagent `body.tex`, un corps
minimal. `compat.tex` ne le partage pas : il existe précisément pour prouver
que l'ancienne syntaxe passe sans retouche. `theme-n7.tex` et `theme-v2.tex`
partagent le contenu complet de `../content/` — c'est la base de comparaison
de l'étape 3 : ouvrir les deux PDF côte à côte montre que `theme=` redessine
sans qu'une ligne du document ne change.

## Compilation

```bash
make            # les quatre supports, les variantes, puis la vérification
make poly       # un seul support
make variants   # seulement les variantes
make check      # revérifie les journaux sans recompiler
make clean      # nettoie les auxiliaires
```

`make` est **vert** si aucune erreur n'apparaît dans les journaux, **rouge** à
la moindre. La liste `KNOWN` du `Makefile` sert à tolérer un défaut connu et
documenté ; elle est vide depuis que l'étape 2 a remplacé le chargement de
paquets de la v0 — ce qui a fait disparaître le `Extra \fi` (défaut D11).

Le template est trouvé par `TEXINPUTS`, positionné par le `Makefile` : les
documents n'ont aucun chemin relatif à tenir à jour.

## État

**Étapes 2 et 3 faites.** Les quatre supports et les sept variantes compilent
sans erreur ; `theme-v2.tex` valide que la refonte visuelle (thème `v2`) tient
dans un seul fichier de thème, sans toucher au noyau ni aux documents.

# Exemples du template

Trois rôles :

1. **Test de non-régression** — `make` doit toujours être vert.
2. **Documentation** — un exemple vaut mieux qu'une page de manuel.
3. **Base de comparaison v1 / v2** — les mêmes sources, deux thèmes, deux PDF
   à mettre côte à côte.

## Un document par support

| Répertoire | Support | Classe |
|------------|---------|--------|
| `poly/`   | polycopié      | `ocots-book` |
| `slides/` | diapositives   | `beamer` |
| `td/`     | travaux dirigés| `ocots-td` |
| `exam/`   | examen         | `ocots-exam` |

## Variantes d'options

`variants/` compile **le même corps** (`body.tex`) avec des options
différentes. C'est la démonstration de l'étape 2 : le contenu ne bouge pas,
seule la ligne `\usepackage` change.

| Fichier | Ce qu'il montre |
|---------|-----------------|
| `fr-none.tex`   | corrigés absents — la version étudiante |
| `fr-inline.tex` | corrigés en place |
| `en-end.tex`    | même contenu en anglais, corrigés reportés |
| `bw-end.tex`    | noir et blanc, pour l'impression |
| `compat.tex`    | un corps écrit **avec les noms de la v0**, compilé par la v1 |

`compat.tex` ne partage pas `body.tex` : il existe précisément pour prouver que
l'ancienne syntaxe passe sans retouche.

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

**Étape 2 faite.** Les exemples exercent l'architecture mais restent minces.
Chaque fichier porte un marqueur `<<< étape 3 : … >>>` là où le contenu de
démonstration viendra : tous les environnements, toutes les options, toutes les
variantes, pour comparer v1 et v2 côte à côte.

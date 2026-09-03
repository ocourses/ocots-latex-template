# Exemples du template

Un document minimal par type de support. Ils ont trois rôles :

1. **Test de non-régression** — `make` doit toujours passer.
2. **Documentation** — un exemple vaut mieux qu'une page de manuel.
3. **Base de comparaison v1 / v2** — les mêmes sources, deux thèmes,
   deux PDF à mettre côte à côte.

| Répertoire | Support | Entrée |
|------------|---------|--------|
| `poly/`   | polycopié (livre)   | `book.cls` + `book.sty` |
| `slides/` | diapositives        | `beamer` + `slides.sty` |
| `td/`     | travaux dirigés     | `article` + `td.sty` |
| `exam/`   | examen              | `article` + `exam.sty` |

## Compilation

```bash
make            # les quatre
make poly       # un seul
make clean      # nettoie les auxiliaires
```

Les fichiers auxiliaires vont dans `<exemple>/build/`, le PDF reste à côté
du `.tex`.

## État

**Étape 1** — squelettes vierges qui compilent. Chaque fichier porte un
marqueur `<<< étape 3 : … >>>` à l'endroit où le contenu de démonstration
viendra : tous les environnements, toutes les options, toutes les variantes.

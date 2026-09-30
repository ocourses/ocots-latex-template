<!-- LTeX: language=fr-FR -->

# Journal des versions

Une section par version, la plus récente en haut. La section « Non publié »
reçoit les changements au fil des PR ; elle devient une version au moment du
tag. Politique de version : [README](README.md#versions).

---

## Non publié

### Ajouté

- **Annexes dans les diapositives** : `\slideappendix{n}{Titre}`, pendant de
  `\slidechapter` pour une annexe du polycopié. Le numéro s'affiche en lettre
  (« Annexe B » dans le bandeau, sections B.1, boîtes B.1.1). Nouvelle chaîne
  `appendix-label` (« Annexe », « Appendix »).

### Corrigé

- **Numérotation des exemples dans les diapositives** : sans l'option
  `notheorems` de beamer, `example` partageait le compteur des résultats
  (beamer le déclare sur `theorem`, amsthm en fait un alias) — « Exemple 1.1.2 »
  après « Théorème 1.1.1 » au lieu de « Exemple 1.1.1 ». Il reprend son
  compteur propre, comme dans le polycopié, remis à zéro à chaque section (la
  marque d'alias du noyau est effacée avec lui, ce qui supprime aussi
  l'avertissement « Alias counters can not be used in a counter reset »).
  Vérifié par `examples/check-appendix.sh`.

---

## v1.1.0 — 2026-09-28

### Changé

- **Page de titre des diapositives** (`\slidetitlepage`) : un bandeau pleine
  largeur, sans cadre, collé au bord supérieur, remplace la boîte encadrée
  centrée. Il porte le titre, puis « Chapitre N » et le titre du chapitre ;
  auteur, date, logos et contenu optionnel sont centrés dans la moitié
  blanche en dessous. Aucune source de document à modifier.
- **Couleurs `titlebox-*`** des thèmes `ocots`, `legacy` et `paper` : fond
  sombre (indigo, midnight, encre) et texte blanc, pour un bandeau lisible en
  projection. `charter` et `slate` l'étaient déjà.

---

## v1.0.0 — 2026-09-28

Première version taguée. Elle fige l'état du template tel que les cours
l'utilisent aujourd'hui ; auparavant, chaque cours épinglait un commit.

### Contenu

- **Classes** `ocots-book`, `ocots-paper`, `ocots-td`, `ocots-exam`, et le
  support `slides` pour beamer. Une seule API : un énoncé se colle tel quel
  d'un support à l'autre.
- **Trois couches** : le noyau définit les environnements, le support fournit
  la structure, le thème l'apparence.
- **Thèmes** `paper`, `ocots`, `legacy`, `charter`, `slate`, avec leurs
  surcharges `boxform`, `titles`, `mathbox`, `listing`.
- **Options** `lang`, `mode`, `solutions`, `math` (`base`, `analysis`,
  `control`, `measure`), `setfont`, `calfont`, `institution`, `draft`,
  `binding`.
- **Environnements** d'énoncés (résultats, exemples, remarques avec leurs
  compteurs propres, variantes étoilées), exercices et corrigés,
  `chapterintro`, `\newstep`, `\qedhere` dans les preuves et les exemples.
- **Alias v0** dans `ocots-compat.sty`, avec avertissement : un document v0
  compile en changeant deux lignes de préambule.
- **Exemples et harnais** : un document par support et les variantes
  d'options (`examples/`, `make`), avec les contrôles sur le rendu
  `check-qed.sh`, `check-numbering.sh`, `check-crefnames.sh`,
  `check-spacing.sh`.

Dernier changement avant ce tag : couleur de thème `table-stripe` et lignes
alternées des tableaux (#57).

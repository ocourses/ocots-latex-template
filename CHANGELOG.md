<!-- LTeX: language=fr-FR -->

# Journal des versions

Une section par version, la plus récente en haut. La section « Non publié »
reçoit les changements au fil des PR ; elle devient une version au moment du
tag. Politique de version : [README](README.md#versions).

---

## Non publié

### Changé

- **Titre de preuve ponctué** : un titre passé à `proof` ou `proofbegin`
  (`\begin{proof}[Idée]`) est désormais suivi d'un point, comme le titre de
  `\newstep`. `\@addpunct` n'en ajoute pas après une ponctuation forte, donc
  un titre déjà ponctué (`[Idée.]`) ne change pas. Le titre par défaut
  (marqueur ▷, ou nom de la preuve du thème `paper`) reste sans point.

---

## v1.8.0 — 2026-10-06

### Ajouté

- **Espacement des points de texte** : `\pointsetup{top=...}` règle l'espace
  supérieur par défaut de `\point`, et l'option ponctuelle `[top=...]` le
  surcharge ; `\newpoint` reste disponible comme alias de compatibilité.

---

## v1.7.1 — 2026-10-05

### Corrigé

- **Énoncé coupé de sa place de réponse** (v1.7.0) : la place était liée à
  la seule dernière ligne de l'énoncé (`\nobreak`). Quand une question
  tombait en bas de page, sa dernière ligne partait avec la place sur la page
  suivante, le reste de l'énoncé restant au-dessus — cas d'un énoncé coupé
  après une formule centrée, dans une boîte d'exercice sécable. Une question
  qui a une place est désormais composée, énoncé et place ensemble, dans un
  bloc insécable ; son espacement de liste est posé hors du bloc, où il se
  fusionne avec celui des questions voisines. `check-answerspace.sh` vérifie
  en plus qu'aucun énoncé n'est coupé (témoin négatif : sans le bloc, deux
  questions coupées).

---

## v1.7.0 — 2026-10-05

### Ajouté

- **Espace de réponse dans un sujet à compléter** (#85) : `\setanswerspace`,
  l'option `answerspace=` d'un `exercise`, l'option `space=` d'une `question`
  ou d'une `subquestion`, et `\answerspace[…]` pour un espace isolé. La place
  n'est posée qu'en `solutions=none`, le sujet distribué ; en `inline` et
  `end`, aucune. Défaut `0pt` : un document qui ne s'en sert pas ne change
  pas. La place est une boîte vide liée à l'énoncé, qui ne tombe pas à une
  coupure de page. Les sujets réglaient jusqu'ici cette place par un
  `\vspace` à la main, posé aussi dans le corrigé. Vérifié par
  `variants/answerspace-{none,inline}` et `check-answerspace.sh`.

---

## v1.6.1 — 2026-10-05

### Corrigé

- **En-tête de partie collé au texte qui précède** : `docpart` (« Partie 1. … »
  dans un sujet d'examen) n'avait que l'espacement d'un théorème et se collait
  à une liste de consignes ou à la fin d'un exercice ; les sujets
  compensaient par un `\bigskip` à la main, contraire à la convention C6.
  `docpart` pose désormais `\addvspace{1.5\bigskipamount}` avant l'en-tête :
  l'espace complète celui qui est déjà posé sans s'y ajouter, donc un sujet
  qui garde son `\bigskip` ne change pas.

---

## v1.6.0 — 2026-10-05

### Ajouté

- **Module `measure` : espaces ℒᵖ et bornes essentielles**
  (ocourses/ocots-latex-template#70). `\Integrable` / `\Integrable{p}`
  compose ℒ / ℒᵖ, avec la même lettre et la même option `calfont` que
  `\ContinuousLinear`, réservé aux applications linéaires continues.
  `\esssup` et `\essinf` sont des opérateurs nommés selon la langue :
  sup ess, inf ess en français, ess sup, ess inf en anglais. Un document qui
  les définissait lui-même par `\DeclareMathOperator` doit retirer sa
  définition.
- **`\resp`**, abréviation localisée « resp. », sur le modèle de `\ie` et
  `\cf` ; la convention C1 d'ocots-conventions la citait déjà.

---

## v1.5.4 — 2026-10-03

### Corrigé

- **Couleur perdue après un saut de page dans une boîte sécable** : une
  `correction` placée dans un `exercise` repassait en noir sur la page
  suivante quand la boîte se coupait. tcolorbox remet la couleur de texte de
  la boîte au début de chaque morceau et écrase le `\color` posé à
  l'intérieur. `ocots-packages.sty` active désormais `use color stack` pour
  toutes les boîtes : la pile de couleurs dédiée de tcolorbox conserve la
  couleur d'une page à l'autre. Vérifié par compilation d'un `exercise` dont la
  correction franchit une page (témoin négatif : noir après la coupure avec
  l'ancien code) ; `make all` vert.

---

## v1.5.3 — 2026-10-01

### Corrigé

- **`\Cref` cassait la compilation**, quel que soit le nombre d'étiquettes
  (`Argument of \ocotsstring has an extra }`). Dans
  `\ocots@result@crefname` (`ocots-env.sty`), l'appel à `\crefname` a un
  effet de bord : cleveref fabrique la variante majuscule en capitalisant le
  premier lexème du nom, ici `\ocotsstring` privé de son argument. Le garde
  de `\Crefname`, évalué après coup, prenait ce nom fabriqué pour un choix du
  document et sautait le bon `\Crefname`. Les deux gardes sont désormais
  évalués avant tout appel ; un `\crefname` ou un `\Crefname` posé par le
  document reste prioritaire. `examples/variants/paper-cleveref{,-fr}.tex`
  testent désormais `\Cref` (une étiquette, plusieurs, familles mêlées),
  vérifiés par `check-crefnames.sh`.

---

## v1.5.2 — 2026-10-01

### Modifié

- **Compatibilité mathématique** : les redirections de `\Acal`, `\Vcal`,
  `\Ical`, `\Ecal`, `\Fcal` dans `ocots-compat.sty` pointent désormais vers
  la macro générique `\calset{}` correspondante (`\calset{A}`, etc.) au lieu
  d'une macro de concept spécifique (`\Reachable`, `\Neighborhoods`,
  `\TimeInterval`, `\MultilinearSpace`, `\AllMaps`). Les alias de tribus
  `\AT`…`\FT` suggèrent également `\calset{}`. Le rendu visuel reste
  identique, mais l'avertissement de dépréciation ne suggère plus un concept
  faux (#72).

---

## v1.5.1 — 2026-09-30

### Corrigé

- **Ancienne syntaxe à clé vide** : `\begin{mydefinition}{Titre}{}` (et
  `mytheorem`, `myproposition`, `mycorollary`, `myconjecture`,
  `myexercisecb<>`) ne pose plus d'étiquette. Elle posait le préfixe seul
  (`def:`, `ex:`…) à chaque boîte : label multiplement défini, que la CI
  des cours refuse désormais (ocourses/agents#41). Le noyau
  (`\begin{theorem}{Titre}{}`) faisait déjà ainsi. Vérifié par
  `make check` sur `variants/compat` (témoin négatif : rouge avec
  l'ancien code).

---

## v1.5.0 — 2026-09-30

### Ajouté

- **`vocabulaire.json` : `ancienne_syntaxe`** (ajout compatible au schéma
  1) — pour les environnements qui acceptent l'ancienne syntaxe
  d'étiquette, sa forme (`{titre}{clé}` ou `<clé>`), le préfixe que le
  template ajoute au label (`thm:`, `def:`, `prop:`, `cor:`, `conj:`,
  `ex:`), et s'il le saute quand la clé le porte déjà. Lu par `ocots-lint`
  pour retrouver le vrai label. Vérifié contre `tex/` (les boîtes étoilées,
  qui ignorent le label, n'en déclarent pas).

---

## v1.4.0 — 2026-09-30

### Corrigé

- **Numérotation des boîtes dans un TD ou un sujet** : les résultats, exemples
  et remarques étaient numérotés « section.numéro ». Un TD n'a en général pas
  de `\section`, et un sujet n'en numérote aucune (`secnumdepth=0`) : ils
  s'affichaient « Remarque 0.1 ». Le support commun TD/examen les numérote
  désormais sans préfixe de section, comme les exercices (« Remarque 1 »).
  Vérifié par `examples/check-td-numbering.sh` (#67).
- **Questions citables** : `question` et `subquestion` incrémentaient leur
  compteur par `\stepcounter`, si bien qu'un `\label` posé dedans renvoyait le
  numéro de l'exercice. Elles passent à `\refstepcounter` : le renvoi rend le
  numéro affiché (« 2.2 », « 2.2.1 » en TD et en examen ; « 2 », « 2.1 » dans le
  polycopié), avec des ancres hyperref uniques. Le compteur `subquestion` est
  désormais remis à zéro par `question` (`\newcounter{subquestion}[question]`)
  (#67).

---

## v1.3.0 — 2026-09-30

### Changé

- **Bas de page du polycopié** (`ocots-carrier-book.sty`) : `\raggedbottom`
  remplace le `\flushbottom` du recto-verso. Aligner tous les bas de page
  étirait l'espace vertical jusqu'à la limite sur les pages difficiles à
  remplir (`Underfull \vbox`, 23 pages sur le poly de mesure et intégration).
  Ces pages se terminent désormais un peu plus haut.

### Corrigé

- **Avertissements à la compilation** d'un document sans `draft`, sans effet
  sur le rendu :
  - `versions` n'avertit plus qu'il redéfinit `comment` (déjà défini par
    `verbatim`), `worknotes` hors `draft`, et `correction` avec
    `solutions=none` : l'environnement est libéré avant `\excludeversion` ;
  - `minitoc` : `caption` et `subcaption` sont chargés avant lui (W0033), et
    l'option `nohints` tait le conseil W0099 sur `titlesec`, sans objet ici
    (les mini-sommaires sont corrects), et le W0024 qui l'accompagne.

---

## v1.2.0 — 2026-09-30

### Ajouté

- **`vocabulaire.json`** (schéma 1) : chaque environnement public avec sa
  famille (boîte ou non), son symbole de fin, ou l'environnement dont il est
  un alias déprécié ; le support que choisit chaque classe. Lu par
  `ocots-lint` au lieu de noms codés en dur. Vérifié contre `tex/` à chaque
  PR (workflow `vocabulaire.yml`) : tout environnement défini est listé, et
  inversement.
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

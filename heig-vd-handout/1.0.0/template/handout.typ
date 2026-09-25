// HEIG-VD practical work handout.
//
// This file is both the starting point for a real handout and a demo of
// everything the template offers. Keep what you need and delete the rest; the
// "Aide-mémoire" section at the end is there only to show the features the TP
// above does not happen to use.
//
// Compile: just            → handout.pdf           (given to the students)
//          just solutions  → handout-solutions.pdf (with the answers)
//          just verify     → builds both, then checks the student PDF
#import "@local/heig-vd-handout:1.0.0": *

// Settings (edit these).
#let title    = [TP 3 — Allocation dynamique]
#let subtitle = [Programmation système]
#let institution = [Département TIC]
#let date     = datetime.today().display("[day].[month].[year]")
#let lang     = "fr" // "fr" or "en": text language and the template's own strings

#show: conf.with(
  title: title,
  subtitle: subtitle,
  institution: institution, // composée au-dessus du titre ; `none` pour l'omettre
  outline: true, // table des matières, avec `outline-depth:` pour sa profondeur
  outline-depth: 2,
  date: date,
  lang: lang,
  numbering: "1.1", // `none` turns the heading numbers off
  // `solutions: true` or `false` pins the version. Left out, it follows
  // `--input solutions=true`, which is what the justfile drives.
  authors: (
    // `role:` accepte "professor" ou "assistant" — traduits selon `lang` — ou
    // n'importe quel texte pour un titre que ces deux clés ne couvrent pas.
    // `gender:` vaut "f" ou "m" et décline le titre en français.
    role: "professor",
    gender: "m",
    name: "Aubry Mangold",
    affiliation: "HEIG-VD",
    email: "aubry.mangold@heig-vd.ch",
  ),
  // Several authors: pass an array of those same dictionaries instead.
)

#info[
  Ce laboratoire dure deux périodes. Rendez une archive `nom_prenom.tar.gz`
  contenant vos sources et un court rapport sur Cyberlearn avant le prochain
  cours.
]

= Objectifs

- Comprendre la différence entre allocation automatique et allocation dynamique.
- Utiliser `malloc`, `realloc` et `free` sans fuite de mémoire.
- Diagnostiquer une fuite avec Valgrind.

#tip[
  Compilez toujours avec `-Wall -Wextra -g`. La majorité des erreurs de ce TP
  sont signalées par le compilateur avant même l'exécution.
]

= Préparation

== Environnement

Un bloc de code délimité par des accents graves est encadré et numéroté
automatiquement.

// `#manipulation` numérote à part de `#question` : ce que les étudiants font,
// par opposition à ce à quoi ils répondent. Les deux repartent de 1 à chaque
// titre de niveau 1 et prennent un `points:` facultatif.
#manipulation(points: 1)[
  Vérifiez que Valgrind est installé, puis clonez le squelette du laboratoire.

  ```bash
  valgrind --version
  git clone https://github.com/heig-vd/tp3-skeleton.git
  ```
]

#warning[
  N'utilisez pas `sudo` pour installer des paquets sur les machines du
  laboratoire : votre session est réinitialisée à chaque redémarrage.
]

#part(points: 11)[Exercices]

== Taille des types

#question(points: 2)[
  Quelle est la valeur affichée par ce programme sur une machine x86-64 ?

  ```c
  printf("%zu\n", sizeof(struct { char c; int i; }));
  ```
]

#answer[
  Le résultat est *8*. Le compilateur insère trois octets de rembourrage
  (_padding_) après le `char` afin que le champ `int` soit aligné sur une
  frontière de quatre octets.
]

== Tableau dynamique

#question(points: 3)[
  Écrivez une fonction `int *grow(int *tab, size_t old, size_t new)` qui
  agrandit un tableau alloué dynamiquement et recopie les anciennes valeurs.
]

#answer[
  #sourcecode(highlighted: (3,))[```c
  int *grow(int *tab, size_t old, size_t new)
  {
      int *tmp = realloc(tab, new * sizeof(*tab)); // <realloc>
      if (tmp == NULL)
          return NULL; // tab reste valide, l'appelant doit le libérer
      memset(tmp + old, 0, (new - old) * sizeof(*tmp));
      return tmp;
  }
  ```]

  Le piège classique est d'écrire `tab = realloc(tab, …)` à la
  #lineref(<realloc>, supplement: "ligne") : si `realloc` échoue, le pointeur
  d'origine est perdu et la mémoire fuit irrémédiablement.
]

== Mesures

Les éléments numérotés — figures, tableaux, équations — se placent dans
l'énoncé : un compteur incrémenté dans un `#answer` ne le serait que dans le
corrigé, et les deux PDF cesseraient de s'accorder.

#question(points: 5)[
  Complétez le tableau ci-dessous, puis donnez le facteur d'agrandissement $k$
  qui minimise le nombre de copies, sachant que $n_(i+1) = k dot n_i$.

  #figure(
    table(
      columns: (auto, 1fr, 1fr),
      table.header[Taille initiale][Copies mesurées][Temps (ms)],
      [1024], [], [],
      [4096], [], [],
      [16384], [], [],
    ),
    caption: [Relevé des copies effectuées par `realloc`.],
  )
]

#answer(title: "Réponse et barème")[
  Valgrind rapporte `definitely lost: 40 bytes in 1 blocks` si le tableau n'est
  pas libéré. Le facteur $k = 2$ amortit le coût des copies à $O(1)$ par
  insertion.

  *Barème* : 2 points pour le relevé, 3 points pour la justification de
  l'amortissement. Accepter $k = 1.5$ avec une justification correcte.
]

== Réponse brève

#question(points: 1)[
  En une phrase : pourquoi `free(NULL)` est-il légal ?
]

// `boxed: false` compose la réponse sans encadré, pour une remarque courte.
#answer(boxed: false)[
  Parce que la norme C l'exige explicitement : `free` sur un pointeur nul ne
  fait rien, ce qui évite un test avant chaque libération.
]

= Pour aller plus loin

#question[
  Si vous terminez en avance, remplacez `malloc` par une arène mémoire allouée
  d'un seul bloc au démarrage et mesurez la différence de performance.
]

#note[
  Les corrigés sont publiés sur Cyberlearn après la séance de rendu.
]

// ===========================================================================
// Aide-mémoire — à supprimer dans une vraie donne.
// ===========================================================================

= Aide-mémoire du modèle

== Énoncés

`#question` et `#manipulation` produisent le même encadré et se numérotent
séparément, `<numéro de partie>.<n>`, remis à zéro à chaque titre de niveau 1.
`#part(points: 11)[Exercices]` remplace `= Exercices` pour afficher le total
d'une partie : le total est composé à côté du titre mais n'appartient pas à son
contenu, et la table des matières l'ignore donc.

#manipulation(points: 0.5)[`#manipulation` : ce que les étudiants font.]
#question[`#question` sans `points:` : l'en-tête n'affiche alors aucun barème.]

== Paragraphes

Le retrait de première ligne marque le changement de paragraphe : il n'y a donc
pas de blanc entre eux, et le premier paragraphe d'une partie, d'un encadré ou
d'une section n'est pas indenté. Deux cas échappent à la règle automatique, car
Typst ne peut pas savoir ce qui suit un paragraphe — utilisez `#flush` :

#flush[La ligne qui introduit une liste reste au fer à gauche :]

- premier élément
- second élément

#flush[Comme la ligne de conclusion isolée qui referme une section.]

== Encadrés

Les quatre encadrés du modèle prennent un `title:` facultatif.

#info(title: "Titre personnalisé")[`#info`, bleu, pour un complément neutre.]
#tip[`#tip`, turquoise, pour un conseil.]
#warning[`#warning`, rouge, pour ce qui coûtera du temps aux étudiants.]
#note[`#note`, gris, pour une remarque secondaire.]

Le paquet #link("https://typst.app/universe/package/colorful-boxes/")[colorful-boxes]
est réexporté en entier pour tout le reste.

#colorbox(title: "#colorbox", color: "purple")[
  Douze teintes prédéfinies (`box-colors`), ou un dictionnaire
  `(fill: …, stroke: …, title: …)` pour une couleur maison.
]

#outline-colorbox(title: "#outline-colorbox", color: "gold")[
  Variante au trait, avec `centering: true` pour centrer le titre.
]

#slanted-colorbox(title: "#slanted-colorbox", color: "blue")[
  Bandeau de titre incliné.
]

#align(center, stickybox(rotation: -2deg, width: 7cm)[
  `#stickybox` : un pense-bête, avec `tape: false` pour retirer l'adhésif.
])

== Code source

Les blocs délimités par des accents graves passent par
#link("https://typst.app/universe/package/codelst/")[codelst]. Appelez
`#sourcecode` à la main pour changer les options d'un bloc :

#sourcecode(numbering: none)[```bash
# `numbering: none` : pas de numéros, pour une ligne isolée
gcc -Wall -Wextra -g -o tp3 main.c
```]

#sourcecode(highlighted: (3,))[```c
// `highlighted: (3,)` surligne la troisième ligne. Attention : ce sont les
// numéros affichés qui comptent, donc `numbers-start: 10` les décale aussi.
int *tab = malloc(n * sizeof(*tab)); // <alloc>
```]

`showrange: (2, 4)` n'affiche qu'un extrait. Pour insérer un fichier du disque,
`#sourcefile` attend son contenu, pas son chemin — `file:` ne sert qu'à déduire
le langage : `#sourcefile(read("main.c"), file: "main.c")`.
`#lineref(<alloc>)` renvoie à une ligne annotée `// <alloc>` :
voir #lineref(<alloc>, supplement: "ligne").

== Liens

Un lien sortant, #link("https://typst.app")[comme celui-ci], est composé en bleu
souligné ; les renvois internes, dont les entrées de la table des matières,
gardent la couleur du texte.

== Les deux versions

`#is-solutions()` expose l'interrupteur, dans un bloc `context` :

#context if is-solutions() [
  #text(fill: heig-red)[Cette phrase n'apparaît que dans le corrigé.]
] else [
  Cette phrase n'apparaît que dans la donne des étudiants.
]

`#heig-red` est le rouge institutionnel (Pantone 485 C), celui de la mention
#text(fill: heig-red, weight: "bold")[CORRIGÉ] en en-tête.

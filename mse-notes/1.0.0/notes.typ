// HES-SO MSE course notes.
//
// This file is both the starting point for real notes and a short demo of the
// layout. Keep what you need and delete the rest.
//
// Compile: typst compile notes.typ
//          typst watch notes.typ   (live preview)
#import "@local/mse-notes:1.0.0": *

// Settings (edit these).
#show: conf.with(
  title: [Ordonnancement temps réel],
  date: datetime.today().display("[day].[month].[year]"),
  language: "fr", // sets Typst's hyphenation and quotes; the footer's "Page
  // X sur Y" is French regardless of this setting
  // `authors` is always an array, even for a single author: up to three are
  // laid out side by side.
  authors: (
    (
      name: "Aubry Mangold",
      affiliation: "HES-SO Master",
      email: "aubry.mangold@master.hes-so.ch",
    ),
  ),
)

= Ordonnancement à taux monotone

Un ordonnanceur préemptif choisit à chaque instant la tâche prête de la plus
haute priorité. Le champ `priority` d'une `task_t` est comparé directement :
plus la valeur est basse, plus la tâche est prioritaire.

#quote(block: true)[
  Le critère de Liu et Layland donne une borne suffisante d'ordonnançabilité :
  $U <= n (2^(1/n) - 1)$.
]

```c
static task_t *pick_next(void) {
    task_t *best = NULL;
    for (size_t i = 0; i < NR_TASKS; i++)
        if (tasks[i].state == TASK_READY
            && (best == NULL || tasks[i].priority < best->priority))
            best = &tasks[i];
    return best;
}
```

Points à retenir :

- la sélection est en $O(n)$ ;
- aucune allocation dynamique n'intervient dans le chemin critique ;
- l'inversion de priorité est évitée par héritage sur les mutex.

// Images and other files live in assets/:
// #figure(image("assets/schema.svg", width: 80%), caption: [Schéma du système.])

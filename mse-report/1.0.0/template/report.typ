// HES-SO MSE course report.
//
// This file is both the starting point for a real report and a short demo of
// the layout. Keep what you need and delete the rest.
//
// Compile: typst compile report.typ
//          typst watch report.typ   (live preview)
#import "@local/mse-report:1.0.0": *

// Settings (edit these).
#show: conf.with(
  title: [Analyse d'un ordonnanceur temps réel],
  subtitle: [Systèmes embarqués avancés],
  date: datetime.today().display("[day].[month].[year]"),
  lang: "fr", // "fr" or "en": text language and the template's own strings
  authors: (
    name: "Aubry Mangold",
    affiliation: "HES-SO Master",
    email: "aubry.mangold@master.hes-so.ch",
  ),
  // Several authors: pass an array of those same dictionaries instead.
  // authors: (
  //   (name: "…", affiliation: "HES-SO Master", email: "…@master.hes-so.ch"),
  //   (name: "…", affiliation: "HES-SO Master", email: "…@master.hes-so.ch"),
  // ),
)

= Introduction

Ce rapport présente l'analyse d'un ordonnanceur temps réel préemptif. Le texte
est justifié par défaut ; le logo, le titre courant et la pagination sont posés
par le modèle.

= Méthode

La charge du processeur pour un ensemble de $n$ tâches périodiques se calcule à
partir de leur durée d'exécution $C_i$ et de leur période $T_i$ :

$ U = sum_(i=1)^n C_i / T_i $

Le critère de Liu et Layland donne la borne d'ordonnançabilité de l'algorithme
à taux monotone :

$ U <= n (2^(1/n) - 1) $

== Jeu de tâches

// Images and other files live in assets/:
// #figure(image("assets/schema.svg", width: 80%), caption: [Schéma du système.])

#figure(
  table(
    columns: 4,
    align: (left, right, right, right),
    table.header([Tâche], [$C_i$ (ms)], [$T_i$ (ms)], [$C_i \/ T_i$]),
    [T1], [1.0], [4.0], [0.250],
    [T2], [2.0], [8.0], [0.250],
    [T3], [3.0], [16.0], [0.188],
  ),
  caption: [Les trois tâches périodiques mesurées.],
)

La charge totale vaut donc $U = 0.688$, sous la borne de $0.780$ calculée pour
$n = 3$ : le jeu est ordonnançable.

= Implémentation

Le noyau retient la tâche de plus haute priorité prête à s'exécuter.

```c
static task_t *pick_next(void) {
    task_t *best = NULL;
    for (size_t i = 0; i < NR_TASKS; i++) {
        if (tasks[i].state != TASK_READY)
            continue;
        if (best == NULL || tasks[i].priority < best->priority)
            best = &tasks[i];
    }
    return best;
}
```

Les points à retenir :

- la sélection est en $O(n)$, ce qui reste acceptable pour un nombre de tâches
  fixé à la compilation ;
- aucune allocation dynamique n'intervient dans le chemin critique ;
- l'inversion de priorité est évitée par héritage sur les mutex.

= Conclusion

La borne théorique est respectée et les mesures confirment qu'aucune échéance
n'est manquée sur la durée d'observation.

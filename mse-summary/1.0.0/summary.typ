// HES-SO MSE lesson summary.
//
// This file is both the starting point for a real summary and a short demo of
// the layout. Keep what you need and delete the rest.
//
// Compile: typst compile summary.typ
//          typst watch summary.typ   (live preview)
#import "@local/mse-summary:1.0.0": *

// Settings (edit these).
#show: conf.with(
  title: [Ordonnancement temps réel],
  author: [Aubry Mangold],
  institution: [HES-SO Master], // accepted, but not rendered by this template
  date: datetime.today().display("[day].[month].[year]"),
)

= Priorités

Un ordonnanceur préemptif choisit à chaque instant la tâche prête de la plus
haute priorité -> la plus basse valeur numérique l'emporte.

// A bullet list is flattened onto one line, "item / item / item":
- taux monotone
- échéance au plus tôt
- moindre laxité

// A term list becomes "*term* description • *term* description":
/ RM: priorité fixée à la période
/ EDF: priorité réévaluée à chaque échéance

== Bornes

Le critère de Liu et Layland : $U <= n (2^(1/n) - 1)$.

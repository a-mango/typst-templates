# Modèle de présentation HES-SO MSE

*En anglais : [README.md](README.md) — cette version française est tenue à jour
en parallèle.*

Modèle de slides [Typst](https://typst.app) (basé sur [Touying](https://touying-typ.github.io/))
aux couleurs du MSE de la HES-SO. Autonome : seul `typst` est requis ; un `justfile`
optionnel automatise les variantes (`just all`, `just handout`, `just pdfpc`, …).

## Démarrer une présentation

1. Copiez tout le dossier (`presentation.typ`, `theme/`, `assets/`).
2. Éditez les **réglages** en haut de `presentation.typ` (titre, auteur, date, …),
   puis le contenu en dessous.
3. Compilez :

   ```bash
   typst compile presentation.typ            # → presentation.pdf
   typst watch presentation.typ              # aperçu en direct
   ```

### Variante : `typst init` (paquet local, sans copier le dossier)

Installez le modèle une fois comme paquet local en liant ce dossier dans le
répertoire de paquets de Typst :

```bash
ln -s /chemin/vers/mse-slides/1.0.0 \
  ~/.local/share/typst/packages/local/mse-slides/1.0.0
```

(Inutile si le dépôt [typst-templates](https://github.com/a-mango/typst-templates)
entier est déjà lié comme espace `@local`.)

Chaque nouveau deck se crée alors avec :

```bash
typst init @local/mse-slides:1.0.0 mon-deck
```

Le projet généré ne contient que `presentation.typ` (qui importe
`@local/mse-slides:1.0.0`) et le `justfile` ; le thème et les logos sont
résolus depuis le paquet. Après toute modification du `presentation.typ` à la
racine, lancez `just template` pour régénérer sa copie dans `template/` (seule
la ligne d'import diffère).

## Deck de démonstration

`demo.typ` est une présentation qui utilise toutes les fonctionnalités du
modèle (les deux familles de slides, colonnes, encadrés, tableaux, code, maths,
pauses et révélations, diagramme animé, slides pleine page, palette, logotypes,
notes pdfpc, comment présenter sous Linux, annexes) et rappelle sur chaque slide
la commande correspondante. Elle est rédigée **en anglais** (`lang = "en"`, ce
qui montre au passage la traduction automatique des titres fixes) et
volontairement figée en configuration **claire**.

```bash
just demo             # → demo.pdf
just demo-handout     # → demo-handout.pdf (sans les pauses)
typst watch demo.typ  # aperçu en direct
```

Ce fichier sert de référence vivante : il est indépendant de `presentation.typ`
(le point de départ d'une vraie présentation) et n'est pas embarqué dans le
modèle `typst init`.

## Variante sombre

Mettez `mode = "dark"` dans les réglages, ou à la compilation :

```bash
typst compile --input mode=dark presentation.typ presentation-dark.pdf
```

Tout le contenu suit : les encadrés (`#info`, `#warning`, `#example`) prennent
leurs teintes sombres, les blocs de code passent sur le thème de coloration
`theme/mse-dark.tmTheme` (le thème clair de Typst tombe à 3.4:1 de contraste
sur fond sombre), et les accents (`#hl`, liens, `*gras*`) utilisent le rouge
clair de la charte, seul à rester au-dessus du seuil WCAG AA sur `#1A1A1A`.

## Version sans pauses (handout)

Pour distribuer les slides sans les révélations progressives (`#pause`,
diagrammes animés) : mettez `handout = true` dans les réglages, ou compilez les
deux variantes côte à côte :

```bash
typst compile presentation.typ presentation.pdf
typst compile --input handout=true presentation.typ presentation-handout.pdf
```

## Langue

Le modèle est livré en anglais (`lang = "en"`). Mettez `lang = "fr"` dans les
réglages (ou `--input lang=fr` à la compilation) pour passer en français : règle
la langue du texte (césure, guillemets) et traduit les titres fixes
(“Outline” → « Sommaire », “Thank you!” → « Merci ! »). Les paramètres `title:`
de `#outline-slide` et `message:` de `#closing-slide` permettent toujours un
libellé sur mesure.

## Notes du présentateur (pdfpc)

Ajoutez des notes invisibles sur les slides avec `#speaker-note[…]`, puis
exportez-les pour [pdfpc](https://pdfpc.github.io/) (console de présentation :
slide courante, slide suivante, notes, chronomètre) :

```bash
just pdfpc        # ou :
typst eval 'query(<pdfpc-file>).first().value' --in presentation.typ > presentation.pdfpc
pdfpc presentation.pdf    # détecte presentation.pdfpc automatiquement
```

## Annexes

Les slides placées après `#show: appendix` (slides de secours pour les
questions) sont exclues du sommaire, du compteur de pages et de la barre de
progression. Utilisez `#heading(depth: 1, outlined: false)[…]` plutôt que `=`
pour que le titre n'apparaisse pas dans le sommaire.

## Mise en page

| Élément                                    | Usage                                                                                                                                                                                    |
| ------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `= Titre` suivi de contenu                 | slide de contenu à barre rouge                                                                                                                                                           |
| `#slide(title: […], align: top)[…]`        | slide de contenu appelée à la main (titre et alignement au choix ; plusieurs corps → colonnes)                                                                                           |
| `= Titre` suivi de `== …`                  | grande slide séparateur de section                                                                                                                                                       |
| `== Titre`                                 | slide de contenu à barre rouge                                                                                                                                                           |
| `#title-slide()`                           | page de titre (logo MSE + HES-SO)                                                                                                                                                        |
| `#outline-slide()`                         | sommaire automatique (titres `=`) ; `levels: (1, 2)` pour les sous-titres, `max-count:` pour le nombre de colonnes (3 par défaut), `fit: false` pour désactiver la réduction automatique |
| `#focus-slide[…]`                          | slide pleine page sur fond rouge                                                                                                                                                         |
| `#dark-focus-slide[…]`                     | slide pleine page sur fond sombre (même en mode clair)                                                                                                                                   |
| `#dark-title-slide()`                      | variante sombre de la page de titre                                                                                                                                                      |
| `#closing-slide(contact: …)`               | slide de clôture (“Thank you!”, « Merci ! » en `lang: "fr"`)                                                                                                                                                             |
| `#hl[mot]` / `#highlight[mot]`             | surlignage gras + rouge MSE                                                                                                                                                              |
| `#cols(columns: (1fr, 1fr))[…][…]`         | colonnes                                                                                                                                                                                 |
| `#fletcher-diagram(…)`                     | diagramme [fletcher](https://typst.app/universe/package/fletcher/) animable : `pause` entre les éléments les révèle étape par étape (voir la slide « Diagramme animé »)                  |
| `#image-slide("photo.jpg", title: […])`    | image plein écran, titre en surimpression (accepte aussi du contenu)                                                                                                                     |
| `#info[…]` / `#warning[…]` / `#example[…]` | encadrés (gris / rouge / contour), `title:` optionnel                                                                                                                                    |
| `#speaker-note[…]`                         | note du présentateur (invisible, exportée via pdfpc)                                                                                                                                     |
| `#show: appendix`                          | slides de secours hors numérotation                                                                                                                                                      |

Les tableaux (`#table`), légendes de figures et liens externes sont stylés
automatiquement aux couleurs de la charte. Comme dans tous les thèmes Touying,
le gras `*mot*` est rendu comme `#hl` (gras + rouge) ; pour retrouver un gras
neutre, passez `config-common(show-strong-with-alert: false)` à `mse-theme`.

Le thème s'en tient volontairement à la barre de progression, aux slides
séparateur et au sommaire : si vous voulez en plus la barre de navigation par
section des thèmes Metropolis/Dewdrop, `components.mini-slides` et
`components.progressive-outline` de Touying restent accessibles depuis votre
`presentation.typ`.

Un sommaire trop long ne déborde plus silencieusement sur une deuxième page :
`#outline-slide` répartit les entrées en colonnes puis, si nécessaire, réduit
le corps du texte (plancher à 0.6em).

## Identité visuelle

- Rouge `#E2001A` et gris `#66696F`, relevés sur le logotype officiel MSE.
- Police : **Helvetica Neue** (texte/titres), avec **Noto Sans** en repli sur
  les machines qui ne l'ont pas ; monospace pour le code et la sérif
  mathématique par défaut de Typst (**New Computer Modern Math**) pour les
  formules. Personnalisable via le réglage `fonts` de `presentation.typ`, p.ex.
  `#let fonts = (body: "Inter", heading: "Inter", mono: "JetBrains Mono", math:
  "Fira Math")` (chaque clé est optionnelle ; les absentes gardent leur valeur
  par défaut).
- Logos MSE dans `assets/logo/`, servis par `mse-logo(mode: …, assets,
  baseline: …)` : `mode: "light"` donne la marque gris + rouge, `"dark"` la
  blanc + rouge et `"white"` la tout blanc (barre de titre rouge, slide de
  clôture) ; `baseline: true` ajoute « Master of Science in Engineering ». La
  marque HES-SO de la page de titre (en couleur, ou blanche en mode sombre)
  vient de `mse-institutions(mode: …, assets)`.

## Accessibilité (PDF/UA)

Typst balise les PDF par défaut ; le modèle est conçu pour passer la validation
PDF/UA-1 :

```bash
typst compile --pdf-standard ua-1 presentation.typ
```

Les logos du thème portent déjà leur texte de remplacement. À vous d'en donner
un à **vos** images et équations, sans quoi la validation échoue :

```typ
#image("schema.png", alt: "Architecture du système en trois couches")
#figure(rect(…), alt: "…", caption: [Schéma])
#math.equation(block: true, alt: "Somme des entiers de 1 à n", $sum_(i=1)^n i$)
```

(Sans `--pdf-standard ua-1`, un `alt` manquant ne provoque aucune erreur : le
PDF reste balisé, simplement non conforme.)

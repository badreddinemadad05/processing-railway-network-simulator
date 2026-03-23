# Railway Dispatching Simulation with Processing

## Description

Ce projet est une simulation visuelle d'un reseau ferroviaire realisee avec Processing. Il met en scene quatre gares principales, quatre gares secondaires, plusieurs bandes de circulation, des deviations et des feux de signalisation pour piloter les deplacements de trains entre differentes destinations.

L'objectif principal est de simuler la circulation, l'occupation des voies, la gestion des conflits et certains mecanismes de retour lorsqu'une situation de collision ou de blocage est detectee.

## Objectifs

- Simuler les trajets de trains entre plusieurs gares.
- Visualiser l'etat du reseau ferroviaire en temps reel.
- Gerer l'attribution des voies en gare.
- Modeliser des zones critiques avec aiguillages, deviations et feux.
- Detecter certains conflits de circulation et declencher des retours automatiques.

## Fonctionnalites

- Interface graphique sous Processing.
- Generation manuelle de trains via 12 boutons de trajet.
- Affichage de 4 gares principales : `Gare1`, `Gare2`, `Gare3`, `Gare4`.
- Affichage de 4 gares secondaires : `SA`, `SB`, `SC`, `SD`.
- Gestion des bandes horizontales de circulation.
- Gestion des deviations via courbes de Bezier.
- Feux rouges et verts selon la capacite des gares.
- Panneau de dispatching avec informations sur le train selectionne.
- Detection de collisions sur certains itineraires avec procedure de retour.

## Technologies utilisees

- Processing / Java mode
- API graphique Processing (`PApplet`, `PImage`, primitives de dessin)
- Collections Java (`ArrayList`)

## Structure du projet

```text
groupe-10-EL HARCHA-ESSALHI-MADAD-FASKA-processing/
|-- Processing/
|   |-- redaprocessingaout.pde   # sketch principal : setup, draw, creation du reseau, routage
|   |-- Train.pde                # modele d'un train et etat de circulation
|   |-- Gare.pde                 # gestion des gares principales
|   |-- GareSecondaire.pde       # gestion des gares secondaires
|   |-- Bande.pde                # segments droits de circulation
|   |-- Deviation.pde            # courbes, ralentissements et retours
|   |-- Aiguillage.pde           # aiguillages et orientation des sorties
|   |-- Feu.pde                  # signalisation
|   |-- dispatching.pde          # panneau d'information de supervision
|   |-- Bouton.pde               # boutons d'interface pour lancer les trains
|   |-- Itineraire.pde           # structure d'itineraire peu exploitee
|   |-- data/                    # images du train, des gares et autres ressources
|-- rapportProjetGroupeProcessing.pdf
|-- README.md
```

## Installation

### Prerequis

- Processing IDE 4.x recommande

### Etapes

1. Ouvrir Processing IDE.
2. Ouvrir le dossier `Processing/` du projet.
3. Verifier que le dossier `Processing/data/` contient bien les images utilisees par `loadImage(...)`.
4. Lancer le sketch principal en ouvrant `redaprocessingaout.pde`.

## Utilisation

- Au lancement, l'application affiche le reseau ferroviaire.
- Les boutons en bas de l'ecran permettent de generer un train pour un trajet donne.
- Un clic sur un train affiche ses informations dans le panneau de dispatching.
- Les trains se deplacent selon leur route, les disponibilites de voies et certaines regles de securite.

## Configuration

Le projet ne contient pas de fichier de configuration externe.

Les principaux parametres sont codifies directement dans les fichiers `.pde` :

- dimensions de la fenetre dans `redaprocessingaout.pde`
- coordonnees des gares, bandes et deviations
- capacite des gares
- delais de pause et vitesses sur courbes

## Base de donnees

Aucune base de donnees n'est utilisee dans ce projet.

## API / Scripts

- Aucune API distante
- Aucun script backend
- Toute la logique est embarquee dans le sketch Processing

## Docker / Docker Compose

Ce projet ne contient ni `Dockerfile` ni configuration `docker-compose`.

## Remarques techniques importantes

- Certains trajets sont proposes dans l'interface mais non implementes dans la logique principale, notamment `G1 -> G3` et `G3 -> G1`.
- Le fichier `Train.pde` attribue l'identifiant via un compteur d'instance au lieu d'un compteur statique, ce qui peut produire des identifiants dupliques.
- Plusieurs variables et ressources semblent non utilisees ou partiellement exploitees (`Itineraire`, `image_raille`, certains fichiers images et PDF dans `data/`).
- Des problemes d'encodage sont visibles dans plusieurs chaines de caracteres, probablement dus a un melange UTF-8 / ANSI.
- Les PDF presents dans `Processing/data/` paraissent etre des documents de travail et non des dependances d'execution.

## Auteurs

- Groupe 10
- EL HARCHA
- ESSALHI
- MADAD
- FASKA

## Statut

Projet academique de simulation ferroviaire sous Processing.

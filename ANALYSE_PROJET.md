# Analyse Technique du Projet

## Vue d'ensemble

Ce projet est une simulation de circulation ferroviaire developpee avec Processing en mode Java. Le reseau represente quatre gares principales (`G1`, `G2`, `G3`, `G4`) et quatre gares secondaires (`SA`, `SB`, `SC`, `SD`) reliees par des voies droites, des aiguillages et des deviations courbes. L'utilisateur peut injecter des trains dans le systeme via des boutons d'interface, puis observer leur progression, les ralentissements, l'occupation des voies, la saturation des gares et certaines procedures de retour lors de conflits.

Le projet ressemble fortement a un travail academique de modelisation et de simulation visuelle d'un systeme de dispatching ferroviaire.

## But du projet

Le projet vise a demontrer comment un reseau ferroviaire peut etre gere visuellement avec :

- des gares ayant une capacite limitee
- des zones critiques de croisement
- des aiguillages dynamiques
- des feux dependants de l'occupation
- des trajets differents selon les points de depart et de destination
- des mecanismes de prevention ou de correction de conflits

## Probleme resolu

Le projet cherche a illustrer un probleme classique de circulation ferroviaire : faire circuler plusieurs trains sur une infrastructure partagee sans bloquer totalement le reseau et en limitant les collisions logiques. Il ne s'agit pas d'un systeme industriel complet, mais d'une simulation pedagogique de regulation et d'occupation des ressources.

## Fonctionnement global

Le sketch principal initialise l'ensemble du reseau dans `setup()` :

- creation des gares principales
- creation des gares secondaires
- creation des bandes de voie
- creation des deviations avec points de controle Bezier
- creation des aiguillages
- creation des feux
- chargement des images
- creation de l'interface de dispatching et des boutons de trajet

Ensuite, `draw()` :

- redessine la scene a chaque frame
- affiche les boutons et le panneau de supervision
- met a jour les feux selon l'occupation des gares
- lance la logique de circulation pour chaque couple depart / destination
- dessine l'ensemble des composants visuels
- detecte certaines collisions et affiche un bandeau d'alerte

## Architecture generale

L'architecture est centralisee autour du fichier principal `redaprocessingaout.pde`, qui orchestre tout :

- initialisation du reseau
- boucle d'animation
- generation des trains
- routage selon les couples de gares
- detection d'une partie des conflits

Autour de ce noyau, les autres fichiers jouent un role de modeles ou de composants de simulation :

- `Train.pde` : etat interne d'un train, progression, pause, retour, affichage
- `Gare.pde` : capacite, entrees/sorties, attribution de voie, suppression des trains termines
- `GareSecondaire.pde` : variantes de gare a 2 voies avec pauses et procedures specifiques
- `Bande.pde` : gestion des segments droits et de files d'attente sur une voie
- `Deviation.pde` : mouvements sur courbe, retour inverse, ralentissements, collisions
- `Aiguillage.pde` : orientation des trains en entree/sortie
- `Feu.pde` : signalisation selon la saturation
- `dispatching.pde` : petit panneau d'information avec selection d'un train
- `Bouton.pde` : interface de creation des trains
- `Itineraire.pde` : structure simple definie mais tres peu exploitee

## Role des fichiers importants

### `Processing/redaprocessingaout.pde`

Fichier principal du projet.

Il contient :

- les declarations globales
- la creation des objets du reseau
- `setup()` et `draw()`
- le `spawn` des trains selon le bouton clique
- la logique de routage par trajet
- plusieurs procedures de gestion de collision et de retour

C'est le coeur fonctionnel de l'application.

### `Processing/Train.pde`

Ce fichier definit les proprietes d'un train :

- position
- destination
- gare de depart
- etat de pause
- progression sur aiguillage et courbe
- etats de collision et de retour

Il gere aussi l'affichage du train et de certains marqueurs visuels en cas d'alerte.

### `Processing/Gare.pde`

Modele les gares principales a 4 voies. La classe gere :

- la liste des trains presents
- le `spawn`
- l'attribution des voies disponibles
- l'entree des trains en gare
- la sortie apres une pause
- le nettoyage quand un train termine son cycle

### `Processing/GareSecondaire.pde`

Equivalent simplifie des gares principales pour des zones intermediaires a 2 voies. Ce fichier contient aussi des fonctions de retour/collision propres aux sections centrales du reseau.

### `Processing/Bande.pde`

Represente des troncons droits de circulation. Les trains y avancent en file et la classe gere aussi certains cas de conflit simples.

### `Processing/Deviation.pde`

Composant central pour les mouvements courbes. Les deviations utilisent des courbes de Bezier pour faire passer les trains d'une voie a une autre. La classe contient aussi une partie importante de la logique de ralentissement, de retour et de collision.

### `Processing/Aiguillage.pde`

Permet d'orienter visuellement et logiquement les trains vers la bonne voie selon la gare cible ou la voie libre.

### `Processing/Feu.pde`

Modele les signaux lumineux. Un feu passe rouge quand une gare ou une gare secondaire est pleine.

### `Processing/dispatching.pde`

Ajoute une couche de supervision simple :

- selection d'un train a la souris
- affichage de sa gare de depart
- affichage de sa destination
- indication d'un etat de collision
- affichage des coordonnees

## Fonctionnalites principales

- generation manuelle de trains selon 12 couples de gares
- simulation graphique temps reel
- capacite limitee des gares
- attribution de voies libres
- transit par bandes et deviations
- arrets temporises dans certaines gares
- feux automatiques selon la disponibilite
- detection de certains conflits dans les zones sensibles
- retour de trains en cas de collision logique
- panneau de supervision de train selectionne

## Technologies et outils detectes

### Technologies utilisees

- Processing
- Java mode pour Processing
- API graphique integree de Processing
- `ArrayList` de Java

### Outils de donnees et d'infrastructure

- aucune base de donnees
- aucune API backend
- aucun framework web
- aucun outil de deploiement
- aucun conteneur Docker
- aucun outil de build distinct detecte

### Ressources multimedia

- images PNG / JPG pour les gares et le train
- PDF de rapport et PDF de support de cours presents dans le depot

## Incoherences, erreurs et points a ameliorer

### 1. Trajets annonces mais non implementes

Les boutons proposent `G1 -> G3` et `G3 -> G1`, et `spawnTrain()` cree bien les trains correspondants. En revanche, la fonction `move(...)` n'appelle jamais `trajetG1versG3(...)` ni `trajetG3versG1(...)`. Les deux fonctions existent seulement en bloc commente a la fin du fichier principal.

Impact :

- l'utilisateur peut creer ces trains
- mais leur deplacement n'est pas gere

### 2. Generation d'identifiants probablement incorrecte

Dans `Train.pde`, le champ `compteur` est un attribut d'instance :

- `public int compteur = 0;`
- `this.id = compteur++;`

Chaque nouvel objet `Train` commence donc avec son propre compteur a `0`, ce qui peut donner plusieurs trains avec le meme identifiant. C'est problematique car plusieurs suppressions utilisent `id`.

Correction recommandee :

- rendre `compteur` statique

### 3. Variables ou structures peu ou pas utilisees

Plusieurs elements semblent partiellement abandonnes ou non exploites :

- `Itineraire.pde`
- `trajetsActifs`
- `image_raille`
- `tempsDepart`
- `autoriserMoveG4versG2`
- `gareDepart` et `gareDestination` n'ont qu'un usage tres limite
- plusieurs images dans `data/` ne sont pas chargees

### 4. Problemes d'encodage de texte

On observe de nombreuses chaines avec caracteres corrompus, par exemple dans les commentaires et certains libelles (`DÃ©claration`, `colision`, fleches mal encodees).

Impact :

- rendu moins professionnel
- lisibilite reduite du code
- possible affichage degrade dans l'interface

### 5. Ressources non essentielles dans `data/`

Le dossier `Processing/data/` contient des PDF de cours et des documents qui ne sont pas referencies par le code. Cela alourdit le depot et melange les ressources d'execution avec des documents annexes.

### 6. Logique de collision tres centralisee et difficile a maintenir

Une grande partie des regles metier est codee en dur dans de longues suites de conditions, surtout dans `redaprocessingaout.pde` et `Deviation.pde`.

Impact :

- maintenance difficile
- forte duplication
- tests unitaires quasiment impossibles dans l'etat

### 7. Nommage et organisation perfectibles

- le fichier principal `redaprocessingaout.pde` porte un nom peu explicite
- plusieurs noms de fonctions sont heterogenes
- certaines fonctions sont tres longues et melangent rendu, logique metier et gestion d'etat

### 8. Quelques incoherences mineures

- `Feu.pde` initialise `estVert = true` alors que le commentaire indique "par defaut rouge"
- `delaiAttente = 4560` avec un commentaire "3 secondes"
- plusieurs `println` de debug sont encore presents

## Points forts du projet

- bon niveau de modelisation visuelle pour un projet Processing
- reseau ferroviaire relativement riche
- effort visible sur la gestion des cas de conflit
- interface simple mais utile pour manipuler la simulation
- separation en plusieurs classes plutot claire
- integration d'un panneau de supervision

## Limites techniques

- architecture tres imperative et fortement couplee
- absence de tests
- absence de documentation initiale
- logique de collision difficile a verifier formellement
- non-couverture de tous les trajets affiches
- depot encore peu prepare pour une publication propre sur GitHub

## Version longue et detaillee

Ce projet peut etre presente comme une plateforme de simulation ferroviaire developpee avec Processing afin de visualiser, a l'echelle d'un reseau simplifie, la circulation de trains entre plusieurs gares interconnectees. L'application se concentre sur le dispatching local, c'est-a-dire la regulation de mouvements dans un reseau partage compose de gares principales, de gares secondaires, d'aiguillages, de voies droites et de deviations.

Le coeur du systeme est base sur une boucle temps reel qui met a jour l'etat du reseau image par image. A chaque cycle, le programme verifie la position des trains, fait evoluer leur trajectoire, met a jour les feux de signalisation et applique des regles de securite rudimentaires. Certaines portions du reseau sont plus critiques que d'autres, notamment les zones centrales reliant les gares principales aux gares secondaires. Dans ces zones, des collisions logiques sont detectees a partir du nombre de trains presents, de leur origine et de leur destination. Lorsqu'un conflit est identifie, le programme peut imposer un retour sur trajectoire inverse.

D'un point de vue technique, l'application repose sur une decomposition en classes metier relativement lisible : les gares gerent la capacite et les voies libres, les bandes representent les troncons rectilignes, les deviations utilisent des courbes de Bezier pour animer les mouvements non lineaires, les feux pilotent l'entree selon la saturation, et le panneau de dispatching apporte une couche minimale d'observabilite. L'utilisateur interagit principalement par des boutons qui generent les trains selon des couples origine/destination predefinis.

Le projet est convaincant pour une demonstration pedagogique ou un mini-projet academique, car il combine representation graphique, logique d'occupation des ressources et gestion d'evenements. En revanche, l'ensemble reste assez monolithique. La logique de routage est largement codee en dur, certaines routes de l'interface ne sont pas implementees jusqu'au bout, et quelques elements montrent un manque de finalisation pour une publication professionnelle, notamment l'encodage du texte, le rangement des assets, l'absence de README initial et plusieurs variables inutilisees.

## Version courte pour presentation orale

Ce projet est une simulation ferroviaire developpee avec Processing. Il permet de visualiser la circulation de trains entre quatre gares principales et quatre gares secondaires, avec des aiguillages, des feux et des deviations. L'utilisateur peut lancer des trains via une interface de boutons, observer leur trajet et voir comment le systeme gere l'occupation des voies et certains conflits de circulation. Techniquement, le projet est structure autour d'un sketch principal et de plusieurs classes de modelisation comme `Train`, `Gare`, `Deviation` et `Feu`. Le resultat est interessant pour illustrer un probleme de dispatching ferroviaire, meme si certaines routes restent inachevees et que la logique gagnerait a etre refactorisee.

## Version formelle pour rapport ou memoire

Ce projet consiste en la conception et l'implementation d'une simulation de circulation ferroviaire sous Processing, dans le but de representer visuellement la regulation de trains sur un reseau simplifie. Le systeme modelise plusieurs gares principales et secondaires interconnectees par des troncons rectilignes et des deviations courbes. Il integre des mecanismes de supervision, d'affectation de voies, de signalisation ainsi qu'une gestion partielle des conflits de circulation. L'application permet ainsi d'etudier, dans un cadre pedagogique, l'impact de la capacite des gares et des zones critiques de croisement sur la fluidite du trafic. Malgre une architecture fonctionnelle et une modelisation graphique aboutie, plusieurs limitations subsistent, notamment l'absence de certaines routes annoncees dans l'interface, la presence de ressources non essentielles dans le depot et une logique metier fortement centralisee.

## Proposition de nom professionnel pour le repository GitHub

Nom recommande :

`railway-dispatching-simulation-processing`

Autres options possibles :

- `processing-railway-network-simulator`
- `rail-traffic-dispatching-processing`
- `train-routing-simulation-processing`

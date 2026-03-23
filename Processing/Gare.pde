import java.util.ArrayList;

class Gare {



  ArrayList<Train> train_en_gare = new ArrayList<Train>();
  ArrayList<Train> train_en_garezz = new ArrayList<Train>();
  ArrayList<Train> train_en_garecolision = new ArrayList<Train>();
  ArrayList<Train> train_en_gare_apres_retour = new ArrayList<Train>();
  int x, y ;
  int width =80;
  int length=5;
  int ampleur=15;
  String nom;
  Train trainEnMouvement = null;
  boolean estBloqueeParCollision = false;


  long prochainDepartApres = 0;   // ⏱️ cooldown global par gare
  boolean aLanceUnTrainCeFrame = false; // 🔒 anti-doublon dans le même frame





  Gare(int x, int y, String nom) {
    this.x = x;
    this.y = y;
    this.nom=nom;
  }


  boolean contientTrain(Train t) {
    // Vérifie si le train est encore proche de la gare
    return abs(t.x - this.x) < t.largeur && abs(t.y - this.y) < t.largeur;
  }

  Train spawn() {   // <-- retour Train au lieu de void
    if (train_en_gare.size() < 4) {
      int index = train_en_gare.size();
      int yBande = y + index * ampleur;
      int xSpawn;
      if (nom.equals("Gare4") || nom.equals("Gare3")) {
        xSpawn = x + width - 30;  // spawn à droite
      } else {
        xSpawn = x;
      }
      Train t = new Train(xSpawn, yBande);
      t.depart = this;
      train_en_garezz.add(t);
      train_en_gare.add(t);
      trains.add(t);
      if (prochainDepartApres < millis()) {
        prochainDepartApres = millis() + 4000;
      }
      return t;   // ✅ très important
    }
    return null;
  }
  
  void dessinerVoie(float x, float yCentre, float longueur, float ecartRails, int nbTraverses, float depasse) {
  // Rails
  stroke(255);
  strokeWeight(1);
  line(x, yCentre - ecartRails/2, x + longueur, yCentre - ecartRails/2);
  line(x, yCentre + ecartRails/2, x + longueur, yCentre + ecartRails/2);

  // Traverses
  stroke(222, 184, 135);
  strokeWeight(2);
  for (int i = 0; i <= nbTraverses; i++) {
    float xTraverse = x + i * (longueur / (float)nbTraverses);
    line(xTraverse, yCentre - ecartRails/2 - depasse,
                 xTraverse, yCentre + ecartRails/2 + depasse);
  }
}


  // garde ta fonction dessinerVoie(...)

void afficher() {
  // Titre
  fill(0, 255, 0);
  text(this.nom, this.x, this.y - 12);

  // --- Réglages visuels ---
  float gauge = 4;            // écart entre les 2 rails d'une voie
  float espaceInterVoies = 13; // espace entre deux voies
  float pasVoies = gauge + espaceInterVoies;

  float longueur = this.width - 4; // longueur visible des rails
  float yTop = this.y +1;        // décoller des quais/bâtiment

  int nbTraverses =10; // moins de traverses
  float depasse = 2;

  // Rails plus fins
  strokeWeight(1);

  // Dessiner 4 voies espacées
  for (int i = 0; i < 4; i++) {
    float yCentre = yTop + i * pasVoies;
    dessinerVoie(this.x , yCentre, longueur, gauge, nbTraverses, depasse);
  }

  // Trains
  for (Train t : train_en_garezz) t.afficher();
}


  void move(Train t) {

  // 🔄 Basculer l’aiguillage en fonction de la gare
  if (this == g1) {
   
    ga1.basculerVersTrainEnSortie(t,this);
  } 
  else if (this == g2) {
    
    gb1.basculerVersTrainEnSortie(t,this);
  } 
  else if (this == g3) {
   
    gc2.basculerVersTrainEnSortie(t,this);
  } 
  else if (this == g4) {
   
    gd2.basculerVersTrainEnSortie(t,this);
  }

  // 🚂 Reste du code inchangé
  int dest = (this==g4 ||this==g3)?this.x:this.x+this.width;
  Bande bandeDevant = null;
  if (nom.equals("Gare2")) {
    bandeDevant = b1;
  } else if (nom.equals("Gare4")) {
    bandeDevant = b4;
  }
  if (bandeDevant != null) {
    for (Train autre : bandeDevant.train_en_bande) {
      if (autre.depart != null && t.depart != null && !autre.depart.equals(t.depart)) {
        return; // ❌ un train opposé est déjà sur la bande → on bloque
      }
    }
  }
  if (nom.equals("Gare4") || nom.equals("Gare3")) {
    if (t.x > this.x - t.largeur) {
      t.x--; // vers la gauche
    } else {
      train_en_gare.remove(t); // ✅ supprime quand totalement sorti
    }
  } else {
    if (t.x < this.x + this.width + t.largeur) {
      t.x++; // vers la droite
    } else {
      train_en_gare.remove(t); // ✅ supprime quand totalement sorti
    }
  }
 
}


  int voieLibre() {
    for (int voie = 0; voie < 4; voie++) {
      int yCible = this.y + this.ampleur * voie;
      boolean occupee = false;

      for (Train t : train_en_gare) {
        if (abs(t.y - yCible) < ampleur / 2) {
          occupee = true;
          break;
        }
      }

      if (!occupee) return voie;
    }

    return -1; // toutes les voies sont occupées
  }






  void entrer_gare(Train t) {
    // Si le train n'a pas encore de voie attribuée
    if (t.voieAttribuee == -1) {
      // Crée une liste pour stocker toutes les voies déjà utilisées ou en cours d'utilisation
      ArrayList<Integer> voiesOccupees = new ArrayList<Integer>();

      // 1. Ajouter les voies des trains déjà présents dans la gare
      for (Train train : train_en_gare) {
        if (train.voieAttribuee != -1) {
          voiesOccupees.add(train.voieAttribuee);
        }
      }

      // 2. Ajouter les voies des trains qui sont en chemin vers cette gare
      for (Train train : trains) {
        if (train != t && train.destination == this && train.voieAttribuee != -1) {
          if (!voiesOccupees.contains(train.voieAttribuee)) {
            voiesOccupees.add(train.voieAttribuee);
          }
        }
      }

      // 3. Trouver la première voie libre qui n'est pas dans la liste des voies occupées
      for (int i = 0; i < 4; i++) {
        if (!voiesOccupees.contains(i)) {
          t.voieAttribuee = i;
          break;
        }
      }

      if (t.voieAttribuee == -1) {
        return;
      }
    }

    // Calcul de la position cible avec la voie attribuée
    int posX = this.x;
    int posY = this.y + ampleur * t.voieAttribuee;

    // Si déjà arrivé à destination, on l'ajoute
    if (abs(t.x - posX) < 2 && abs(t.y - posY) < 2) {
      if (!train_en_gare.contains(t)) {
        train_en_gare.add(t);
        return;
      }
      return;
    }

    // Fait avancer le train vers la voie
    t.avancer(posX, posY);
  }


  void entrer_garerecours(Train t) {

    if (t.voieAttribuee == -1) {
      ArrayList<Integer> voiesOccupées = new ArrayList<Integer>();
      for (Train train : train_en_gare) {
        voiesOccupées.add(train.voieAttribuee);
      }
      for (Train train : trains) {
        if (train.retourCollision && train != t && train.depart == this && train.voieAttribuee != -1) {
          voiesOccupées.add(train.voieAttribuee);
        }
      }
      for (int i = 0; i < 4; i++) {
        if (!voiesOccupées.contains(i)) {
          t.voieAttribuee = i;
          break;
        }
      }
      if (t.voieAttribuee == -1) return;
    }
    int posX = this.x;
    int posY = this.y + ampleur * t.voieAttribuee;
    if (abs(t.x - posX) < 1 && abs(t.y - posY) < 1) {
      if (!train_en_gare.contains(t)) {
        train_en_gare.add(t);
        t.aCommence = false;
        t.debutAttente = -1;
      }
      return;
    }
    t.avancer(posX, posY);
  }
  




 void quitter_gare(Train t) {
  // 1) Pause en cours ?
  if (t.pause > 0) {
    t.pause--;
    return;
  }

  // 2) Pause à mi-chemin (une seule fois)
  int milieu = this.x + (this.width / 2) - t.largeur;
  boolean gareDroite = (this == g3 || this == g4);
  boolean gareGauche = (this == g1 || this == g2);

  if (!t.pauseDejaActivee &&
      ((gareDroite && t.x >= milieu) || (gareGauche && t.x <= milieu))) {
    t.pause = 300;
    t.pauseDejaActivee = true;
    return;
  }

  // 3) Mouvement de sortie
  if (gareDroite) {
    int seuilSortie = this.x + this.width;
    if (t.x < seuilSortie) {
      t.x++;
      return;
    }
  } else if (gareGauche) {
    int seuilSortie = this.x - t.largeur;
    if (t.x > seuilSortie) {
      t.x--;
      return;
    }
  } else {
    return; // sécurité
  }

  // 4) Nettoyage — seulement si le train est encore enregistré
  if (train_en_gare.contains(t)) train_en_gare.remove(t);
  if (train_en_garezz.contains(t)) train_en_garezz.remove(t);
  if (trains.contains(t)) trains.remove(t);

  // resets
  t.pause = 0;
  t.pauseDejaActivee = false;
  t.voieAttribuee = -1;
  t.aCommence = false;
  t.debutAttente = -1;
  t.tAiguillage = 0;
  t.tBezier = 0;
  t.tBezier1 = 1;

  // écarte le sprite de l’écran
  t.x = 900;
  t.y = 900;
}






}

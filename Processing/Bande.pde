
class Bande {
  ArrayList<Train> train_en_bande = new ArrayList<Train>();
  int x, y;
  int width =270;
  int length = 2;
  int ampleur = 6;
  String nom;

  Bande(int x, int y, String nom) {
    this.x = x;
    this.y = y;
    this.nom = nom;
  }
  void afficher() {


    stroke(255);
    strokeWeight(1);
    line(x, y - ampleur / 2, x + width, y - ampleur / 2);
    line(x, y + ampleur / 2, x + width, y + ampleur / 2);

    // Dessiner les traverses qui dépassent un peu
    stroke(222, 184, 135);
    strokeWeight(2);
    int nbTraverses = width / 8;
    float depasse = 2; // combien la traverse dépasse du rail

    for (int i = 0; i <= nbTraverses; i++) {
      float xTraverse = x + i * (width / (float)nbTraverses);
      line(xTraverse, y - ampleur / 2 - depasse, xTraverse, y + ampleur / 2 + depasse);
    }


    // Afficher le texte
    fill(255);
    noStroke();
    textSize(10);
    
    
    
   
  }

  void traverser_bande_retour(Train t) {
    boolean dejaPresent = false;
    for (Train tr : train_en_bande) {
      if (tr.id == t.id) {
        dejaPresent = true;
        break;
      }
    }

    if (!dejaPresent) {
      train_en_bande.add(t);
    }

    t.avancer(this.x + this.width, this.y);

    if (t.x >= this.x + this.width) {
      train_en_bande.removeIf(tr -> tr.id == t.id);
      t.pauseDejaActivee = false;
      
    }
  }


  void traverser_bande(Train t) {
    // Vérifier si le train est déjà dans la file
    if (!train_en_bande.contains(t)) {
      train_en_bande.add(t);
    }

    // Obtenir la position du train dans la file (ordre d'arrivée)
    int position = train_en_bande.indexOf(t); // 0 pour le premier, 1 pour le deuxième...

    // Espacement entre les trains
    int espace = t.largeur; // Ajoute un petit espace pour qu’ils ne se touchent pas

    // Calculer la destination du train selon sa position dans la file
    int destX = this.x + this.width - espace * (position + 1);

    // Faire avancer le train vers sa place
    t.avancer(destX, this.y);

    // S’il atteint la fin de la bande, on le retire
    if (t.x >= this.x + this.width) {
      train_en_bande.remove(t);
      t.pauseDejaActivee = false;
    }
  }
  
  void traverser_bande_gauche(Train t) {
  // Ajouter le train s’il n’est pas encore dans la bande
  if (!train_en_bande.contains(t)) {
    train_en_bande.add(t);
  }

  // Position du train dans la file (0 pour le premier)
  int position = train_en_bande.indexOf(t);

  // Espacement = largeur du train
  int espace = t.largeur;

  // Destination : les trains se rangent de gauche (this.x) vers la droite
  int destX = this.x + espace * position;

  // Faire avancer le train
  t.avancer(destX, this.y);

  // Quand le train atteint le bout de la bande, on le retire
  if (t.x >= this.x + this.width) {
    train_en_bande.remove(t);
    t.pauseDejaActivee = false;
  }
}










  void gerer_colision(Gare une, Gare deux) {
    Bande bande = null;
    Feu f1 = null, f2 = null;
    GareSecondaire gs = null;

    if (une == g2 && deux == g4) {
      gs = GareS_B;
      bande = b1;
      f1 = fsb1;
      f2 = fsb2;
    } else if (une == g4 && deux == g2) {
      gs = GareS_B;
      bande = b4;
      f1 = fsb2;
      f2 = fsb1;
    } else {
      return;
    }

    // 🔴 Si les deux feux sont rouges, il y a collision
    if (!f1.estVert && !f2.estVert) {
      boolean g2Present = false;
      boolean g4Present = false;

      for (Train t : gs.train_en_gare) {
        if (t.depart == g2) g2Present = true;
        if (t.depart == g4) g4Present = true;
        
      }

      // ✅ Collision confirmée : un train de chaque origine est là
      if ((g2Present && g4Present) || g2Present && !g4Present) {
        ArrayList<Train> copieTrains = new ArrayList<Train>(bande.train_en_bande);

        for (Train t : copieTrains) {
          // ✅ Marquer uniquement les trains dont l’origine == une
          if (t.depart == une) {
            t.retourCollision = true;
           
          }
          
        }
        
      }
      
    }
  }
}

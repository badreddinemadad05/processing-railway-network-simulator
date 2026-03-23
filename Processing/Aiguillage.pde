public class Aiguillage {
  int xdep, ydep;
  int xarr, yarr;
  int longeur = 10;
  int largeur = 3;
  color couleur = color(255);
  int sens ;
  float tAiguillage = 0;

  Aiguillage(int xdep, int ydep, int xarr, int yarr, int sens) {
    this.xdep = xdep;
    this.ydep = ydep;
    this.xarr = xarr;
    this.yarr = yarr;
    this.sens = sens;
  }


  void afficher() {
    fill(couleur);
    stroke(couleur);
    strokeWeight(largeur);

    // Dessiner la ligne principale
    line(xdep, ydep, xarr, yarr);

   
    dessinerFleche();
    
    
  }
  void dessinerFleche() {
    float angle = atan2(yarr - ydep, xarr - xdep); // angle vers la destination
    float tailleFleche = 10;

    // Pointe de la flèche
    float xPointe = xarr;
    float yPointe = yarr;

    // Deux ailes
    float xAileGauche = xPointe - tailleFleche * cos(angle - PI / 6);
    float yAileGauche = yPointe - tailleFleche * sin(angle - PI / 6);

    float xAileDroite = xPointe - tailleFleche * cos(angle + PI / 6);
    float yAileDroite = yPointe - tailleFleche * sin(angle + PI / 6);

    noStroke();
    fill(couleur);
    triangle(xPointe, yPointe, xAileGauche, yAileGauche, xAileDroite, yAileDroite);
  }





  void basculer(GareSecondaire g) {
    int voie = g.voieLibre();
    if (voie != -1) {
      int cible = g.y + g.ampleur * voie;
      this.yarr = cible+5;
    } else {
    }
  }
  
  
  
  void basculer1(Gare g) {
    int voie = g.voieLibre();
    if (voie != -1) {
      int cible = g.y + g.ampleur * voie;
      this.yarr = cible+5;
    } else {
    }
  }


void basculerVersTrainEnSortie(Train t , Gare g) {
    Aiguillage aiguillageAssocie = null;

    // Associer la gare actuelle à son aiguillage
    if (g == g1) aiguillageAssocie = ga1;
    else if (g == g2) aiguillageAssocie= gb1;
    else if (g == g3) aiguillageAssocie = gc2;
    else if (g == g4) aiguillageAssocie = gd2;

    if (aiguillageAssocie == null) return;

    // 📌 Basculer uniquement si le train est encore proche de la sortie
    boolean enSortie =
        (g == g1 || g == g2) ? (t.x <= g.x + g.width + 5)   // gares de gauche → vers la droite
                             : (t.x >= g.x - t.largeur - 5); // gares de droite → vers la gauche

    if (enSortie) {
        int voie = (int)((t.y - g.y) / g.ampleur);
        aiguillageAssocie.yarr = g.y + g.ampleur * voie + 5;
    }
}






  void faireSuivreAiguillage(Train train) {
    
    if (train.x >= 130 &&train.x <= 361  ) {  // Condition sur la position du train
      float xTarget = lerp(xarr, xdep, train.tAiguillage);
      float yTarget = lerp(yarr, ydep, train.tAiguillage);

      train.x = int(xTarget);
      train.y = int(yTarget);

      if (train.tAiguillage < 1) {
        train.tAiguillage += 0.01;
      } else {
        train.tAiguillage = 1;
      }
    }
  }

  void faireSuivreAiguillage1(Train t) {
    if (t.tAiguillage < 1) {
      float xTarget = lerp(xdep, xarr, t.tAiguillage);
      float yTarget = lerp(ydep, yarr, t.tAiguillage);

      t.x = int(xTarget);
      t.y = int(yTarget);


      t.tAiguillage += 0.01;
    } else {
      t.tAiguillage = 1;
    }
  }

  void suivre(Train t) {
    // Vérification du sens
    if (sens != 1 && sens != 2) {
      return;
    }

    // Ne rien faire si le mouvement est terminé
    if (t.tAiguillage >= 1) return;

    // Calcul du mouvement selon le sens
    float xStart = (sens == 1) ? xdep : xarr;
    float yStart = (sens == 1) ? ydep : yarr;
    float xEnd   = (sens == 1) ? xarr : xdep;
    float yEnd   = (sens == 1) ? yarr : ydep;

    float xTarget = lerp(xStart, xEnd, t.tAiguillage);
    float yTarget = lerp(yStart, yEnd, t.tAiguillage);

    t.x = int(xTarget);
    t.y = int(yTarget);

    // Avancement
    t.tAiguillage += 0.01;
  }

  void basculerSortie(Train t) {
    
      this.yarr = t.y+4;
    
  }
}

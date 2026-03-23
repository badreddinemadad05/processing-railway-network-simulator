public class Train {
  int x, y;
  int largeur=35;
  int hauteur=10;


  int id;
  static int compteur = 0;
  float vitesseBezier = 0.003f;

  float tBezier = 0;
  float tBezier1 = 1;  // Pour la courbe en arrière (commence à la fin)
  float tAiguillage = 0;


  int pause = 0;
  boolean pauseDejaActivee = false;
  boolean dansDeviation = false;

  boolean aFiniCourbeInverse = false;




  Gare destination;
  Gare depart;


  boolean retourCollision =false;
  boolean retourCollisiong3 =false;
  boolean retourCollisiong4 =false;
  boolean retourCollisiong6 =false;


  boolean retourCollisiong5 =false;
  boolean retourDejaEnCours = false;

  int pauseAvantEntree = 0;
  boolean entreeDejaEnPause = false;



  int voieAttribuee = -1;



  int debutAttente = -1;
  int delaiAttente = 4560; // 3 secondes en millisecondes
  boolean aCommence = false;


  boolean coresp=false;
  boolean retourDejaFait = false;
  boolean aFiniTrajet =false;



  boolean retourTermine = false;
  boolean estEnRecul = false;  // indique si on a déjà commencé le recul


  boolean dejaEnRetour = false;


  boolean enPause = false;     // ✅ indique si le train est en pause
  int debutPause = 0;          // ✅ stocke le moment où la pause commence
  int dureePause = 1000;
  
  
  int lastFrameUpdated = -1; // pour éviter plusieurs updates dans la même frame
  long prochainDepartApres = 0;        // cooldown global par gare
  boolean aLanceUnTrainCeFrame = false; // anti-double départ dans le même frame


  // Train.java
  boolean enInverse = false;  // retour sur courbe inverse en cours ?




  Train(int x, int y) {
    this.id = compteur++;
    this.x = x;
    this.y = y;
  }


void afficher() {
    if (image_train != null) {
        image(image_train, x, y, largeur, hauteur);
    } else {
        // Si l'image n'est pas chargée, rectangle rouge par défaut
        noStroke();
        fill(255, 0, 0);
        rect(x, y, largeur, hauteur);
    }

    // 🔺 Icône danger clignotant si retourCollision actif
  if ((retourCollision || retourCollisiong3 || retourCollisiong4 ||
     retourCollisiong5 || retourCollisiong6) && (frameCount % 60) < 30) {

    // Triangle rouge
    fill(255, 0, 0);
    noStroke();

    float taille = 14;                 // hauteur du triangle
    float centreX = x - 10;             // position horizontale (à gauche du train)
    float baseY = y + hauteur / 2f + taille / 2; // position de la base

    triangle(
        centreX, baseY - taille,        // pointe
        centreX - taille / 2, baseY,    // bas gauche
        centreX + taille / 2, baseY     // bas droite
    );

    // Point d'exclamation blanc
    fill(255); // blanc
    textAlign(CENTER, CENTER);
    textSize(taille * 0.9); // taille adaptée au triangle
    text("!", centreX, baseY - taille / 2.5);
}



}


 /*void afficher() {
    if (this.retourCollisiong5) {
      fill(0, 255, 0);   // 🟢 Vert si collision G5
    } else if (this.retourCollisiong6) {
      fill(255, 255, 0); // 🟡 Jaune si collision G6
    } else if (this.retourCollisiong4) {
      fill(255, 130, 0); // 🟡 Jaune si collision G6
    } else {
      fill(255, 0, 0);   // 🔴 Rouge sinon
    }

    noStroke();
    rect(this.x, this.y, this.largeur, this.hauteur);

    
  }*/


  void avancer(int targetx, int targety) {
    if (this.x < targetx) {
      this.x += 1;
    } else if (this.x > targetx) {
      this.x -= 1;
    }

    if (this.y < targety) {
      this.y += 1;
    } else if (this.y > targety) {
      this.y -= 1;
    }
  }


  void move(Deviation deviation) {
    if (!dansDeviation && dist(x, y, deviation.x1, deviation.y1) <= 5) {
      dansDeviation = true;
      tBezier = 0;
    }

    if (dansDeviation) {
      float tx = bezierPoint(deviation.x1, deviation.cx1, deviation.cx2, deviation.x2, tBezier);
      float ty = bezierPoint(deviation.y1, deviation.cy1, deviation.cy2, deviation.y2, tBezier);
      x = int(tx);
      y = int(ty);
      tBezier += 0.006;
      if (tBezier > 1) tBezier = 1;
    } else {
      avancer(482, 620);
    }
  }


  void reculer() {
    if (this.depart == g2 || this.depart == g1) {
      // sens vers la gauche
      this.x -= 1;
    } else {
      // sens vers la droite
      this.x += 1;
    }
  }
  
  void setDejaEnRetour(boolean val, String from) {
    println("[DEBUG] dejaEnRetour -> " + val + " depuis " + from);
    this.dejaEnRetour = val;
}



  void avancerAvecPause(int targetX) {
    if (pause > 0) {
      pause--;
      return;
    }

    if (x == 300 && !pauseDejaActivee) {
      pause = 240;
      pauseDejaActivee = true;  // pour ne plus redéclencher la pause
      return;
    }

    if (x < targetX) x++;
    if (x > targetX) x--;
  }
}

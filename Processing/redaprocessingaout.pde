import processing.core.PApplet;
ArrayList<Train> trains = new ArrayList<>();
Gare g1, g2, g3, g4;//ICI LES GARES
Bande b1, b2, b3, b4, b6;//ICI LES Voies bande
GareSecondaire GareS_A, GareS_B, GareS_C, GareS_D;// ici leq gares seconadairess
Deviation d1, d2, d3, d4 ;

Aiguillage gb1, gb2, gd1, gd2, ga1, ga2, gc1, gc2, gsd1, gsd2, gsc1, gsc2, gdb1, gdb2, gdb3, gdb4;

Feu f2, fsb1, fsb2, f4, f1, f3, fsd1, fsd2, fsc1, fsc2, fsa1, fsa2;

int currentFrame = 0;

long _collisionMsgUntil = 0;


float t = 0;
boolean t1DansDeviation = false;



Gare gareDepart = null;
Gare gareDestination = null;


int tempsDepart = 0;
boolean autoriserMoveG4versG2 = false;
Dispatching ui;

PImage image_train;
PImage image_gare2;
PImage image_gare1;
PImage image_gare3;
PImage image_gare4;

PImage image_sd, image_sc, image_sb, image_sa;

PImage image_raille;


// --- Déclaration ---
Button[] boutons = new Button[12];
String[] trajets = {
  "G1→G2", "G2→G1",
  "G1→G3", "G3→G1",
  "G1→G4", "G4→G1",
  "G2→G3", "G3→G2",
  "G2→G4", "G4→G2",
  "G3→G4", "G4→G3"
};




void setup() {


  size(1000, 900);
  background(255);




  ui = new Dispatching(this, 320, 180);
  ui.setTrains(trains);


  int btnWidth = 90;
  int btnHeight = 35;
  int spacing = 15;

  // Position de départ des boutons (en bas de l’écran)
  int startX = 20;
  int startY = height - (2 * (btnHeight + spacing)); // 2 lignes de boutons

  for (int i = 0; i < boutons.length; i++) {
    int row = i / 6;  // 6 boutons par ligne
    int col = i % 6;
    boutons[i] = new Button(
      startX + col * (btnWidth + spacing),
      startY + row * (btnHeight + spacing),
      btnWidth, btnHeight,
      trajets[i]
      );
  }


  image_train = loadImage("imagesproce123.png");
  image_gare2 = loadImage("GARE2.png");
  image_gare1= loadImage("gare1.png");
  image_gare3= loadImage("gare3.png");
  image_sd=loadImage("sd.png");
  image_sc=loadImage("sc.png");
  image_sb=loadImage("sb.png");
  image_sa=loadImage("sa.png");
  image_gare4=loadImage("gare4.png");






  int gx=50;
  int gy=100;
  int g1x=900;
  int g1y=600;
  g1=new Gare(gx, g1y, "Gare1");
  g2=new Gare(gx, gy, "Gare2");
  g3=new Gare(g1x, g1y, "Gare3");
  g4=new Gare(g1x, gy, "Gare4");


  int GareS_Ax=(g1.x+g1.ampleur+g4.x)/2;
  int GareS_Bx=(g2.x+g2.ampleur+g4.x)/2;

  GareS_A=new  GareSecondaire(GareS_Ax, 620, "SA");
  GareS_B=new  GareSecondaire(GareS_Bx, 120, "SB");
  GareS_C=new  GareSecondaire(580, 380, "SC");
  GareS_D=new  GareSecondaire(390, 380, "SD");


  b1=new Bande(g2.x+110, GareS_B.y+10, "bande1");
  b2=new Bande(g2.x+110, GareS_A.y+10, "bande2");
  b3=new Bande(GareS_B.x+110, GareS_A.y+10, "bande3");
  b4=new Bande(GareS_B.x+110, GareS_B.y+10, "bande4");

  b6= new Bande(460, 390, "bande6");
  b6.width=100;


  d1=new Deviation(b1.x, b1.y, 300, 130, 300, 350, 360, 395, "deviation1");
  d2 = new Deviation( b4.x + b4.width, 130, 730, 130, 730, 350, 650, 395, "deviation2");
  d3 = new Deviation(b1.x, b3.y, 300, 600, 250, 440, 360, 395, "deviation3");
  d4 = new Deviation(b3.x + b3.width, 630, 730, 600, 750, 440, 650, 395, "deviation4");


  gb1= new Aiguillage(b1.x, b1.y, g2.x+g2.width+2, g2.y+2, 1);
  gb2= new Aiguillage(b1.x+b1.width, b1.y, GareS_B.x-2, GareS_B.y+2, 2);

  gd1= new Aiguillage(b4.x, b4.y, GareS_B.x+GareS_B.width, GareS_B.y, 1);
  gd2= new Aiguillage(b4.x+b4.width, b4.y, g4.x-2, g4.y+2, 2);

  ga1= new Aiguillage(b2.x, b2.y, g1.x+g1.width+2, g1.y+2, 1);
  ga2= new Aiguillage(b2.x+b2.width, b2.y, GareS_A.x-2, GareS_A.y+2, 2);

  gc1= new Aiguillage(b4.x, b3.y, GareS_A.x+GareS_A.width, GareS_A.y+2, 1);
  gc2= new Aiguillage(b4.x+b4.width, b3.y, g3.x-2, g3.y+2, 2 );


  gsd1=new Aiguillage( 360, 395, GareS_D.x, GareS_D.y+2, 1);
  gsd2=new Aiguillage( 461, 389, GareS_D.x+GareS_D.width, GareS_D.y, 2);
  gsc1=new Aiguillage(561, 389, GareS_C.x, GareS_C.y, 1);
  gsc2=new Aiguillage(650, 395, GareS_C.x+GareS_C.width, GareS_D.y, 2 );


  gdb1= new Aiguillage(b1.x+15, b1.y, b1.x+50, b1.y+10, 1);
  gdb2= new Aiguillage(b2.x, b2.y, b2.x+40, b2.y-15, 2);
  gdb3= new Aiguillage(b3.x+b3.width, b3.y, b3.x+b3.width-40, b3.y-15, 1);
  gdb4= new Aiguillage(b4.x+b4.width, b4.y, b4.x+b4.width-40, b4.y+15, 2);


  f2 = new Feu(160, 130);
  fsb1 = new Feu(430, 130);
  fsb2 = new Feu(592, 130);
  f4 = new Feu(862, 130);

  fsd1= new Feu(461, 389);
  fsd2= new Feu(360, 389);
  fsc1= new Feu(561, 389);
  fsc2= new Feu(650, 389);

  f1 = new Feu(160, 630);
  f3 = new Feu(862, 630);

  fsa1=new Feu(430, 630);
  fsa2=new Feu(592, 630);
}

void draw() {
  background(30, 30, 30);

  for (Button b : boutons) {
    b.display();
  }
  // Position ancrée bas-droite
  float x = 20;
  float y = 200;

  // Ombre (noir transparent)
  noStroke();
  fill(245, 235, 220);   // bleu foncé

  // 100 = alpha (transparence)
  rect(x + 4, y + 6, x+140, y+70, 16);

  // Fond du panneau (blanc ou gris très clair)
  fill(245, 235, 220);   // bleu foncé;               // 245 = gris très clair; blanc pur = 255
  rect(x+4, y+6, x+140, y+70, 16);    // 16 = rayon des coins (arrondis)
  fill(30);                     // texte foncé (lisible sur beige)
  textAlign(LEFT, TOP);
  textSize(14);
  text("Info sur le tram", x + 26, y + 10);
  stroke(220);
  strokeWeight(2);
  line(x + 26, y + 10, 181, 328);
  noStroke();




  colispsodpaij();


  ui.setGare2Anchor(g2.x + g2.width/2f, g2.y +200);
  
                 // remettre la couleur normale après

  ui.draw();
  currentFrame++;

  g1.aLanceUnTrainCeFrame = false;
  g2.aLanceUnTrainCeFrame = false;
  g3.aLanceUnTrainCeFrame = false;
  g4.aLanceUnTrainCeFrame = false;

  move(g1, g2);
  move(g1, g3);
  move(g1, g4);
  move(g2, g1);
  move(g2, g3);
  move(g2, g4);
  move(g3, g1);
  move(g3, g2);
  move(g3, g4);
  move(g4, g1);
  move(g4, g2);
  move(g4, g3);






  image(image_gare2, 37, 20, 105, 75);

  image(image_gare1, 37, 520, 105, 75);
  image(image_gare3, 890, 520, 105, 75);
  image(image_gare4, 890, 20, 105, 75);
  image(image_sd, 370, 325, 80, 50);
  image(image_sc, 570, 320, 80, 55);
  image(image_sb, 470, 55, 80, 55);
  image(image_sa, 470, 560, 80, 55);






  f2.afficher();
  fsb1.afficher();
  fsb2.afficher();
  f4.afficher();
  fsd1.afficher();
  fsd2.afficher();
  fsc1.afficher();
  fsc2.afficher();
  f1.afficher();
  f3.afficher();
  fsa1.afficher();
  fsa2.afficher();
  g1.afficher();
  g2.afficher();
  g3.afficher();
  g4.afficher();
  GareS_A.afficher();
  GareS_B.afficher();
  GareS_D.afficher();
  GareS_C.afficher();
  b1.afficher();
  b2.afficher();
  b3.afficher();
  b4.afficher();
  b6.afficher();
  d1.afficher();
  d2.afficher();
  d3.afficher();
  d4.afficher();
  gb1.afficher();
  gb2.afficher();
  gd1.afficher();
  gd2.afficher();
  ga1.afficher();
  ga2.afficher();
  gc1.afficher();
  gc2.afficher();
  gsd1.afficher();
  gsd2.afficher();
  gsc1.afficher();
  gsc2.afficher();
  gdb1.afficher();
  gdb2.afficher();
  gdb3.afficher();
  gdb4.afficher();
  fsb1.mettreAJourSelonGares(GareS_B);
  fsb2.mettreAJourSelonGares(GareS_B);
  fsd1.mettreAJourSelonGares(GareS_D);
  fsd2.mettreAJourSelonGares(GareS_D);
  fsc1.mettreAJourSelonGares(GareS_C);
  fsc2.mettreAJourSelonGares(GareS_C);
  f4.mettreAJourSelonGare(g4);
  f2.mettreAJourSelonGare(g2);
  f3.mettreAJourSelonGare(g3);
  f1.mettreAJourSelonGare(g1);



  boolean flagCollision = false;
  // exemple avec tes flags existants :
  for (Train t : trains) {
    if (t.retourCollisiong3 || t.retourCollisiong4 || t.retourCollisiong5 || t.retourCollisiong6) {
      flagCollision = true;
      break;
    }
  }

  bannerCollision(flagCollision);
}











void move(Gare depart, Gare destination) {
  for (Train t : trains) {

    GareS_D.gerercolisiong1g2(t);
    GareS_C.gerercolisiong4g3(t);

    if (t.retourCollision) {
      if (t.x < b4.x + b4.width) {
        GareS_B.train_en_gare.remove(t);
        b4.traverser_bande_retour(t);

        continue;
      }
      g4.entrer_garerecours(t);
      boolean allOtherTrainsFrom = true;
      for (Train otherTrain : trains) {
        if (otherTrain != t && otherTrain.depart == g2) {
          if (otherTrain.x < 899) {
            allOtherTrainsFrom = false;
            break;
          }
        }
      }

      if (allOtherTrainsFrom) {
        t.aCommence = false;
        t.debutAttente = -1;

        t.retourCollision = false;
      }
      continue;
    }






    if (t.retourCollisiong3) {
      d4.procedure_retour(t);
      boolean allOtherTrainsFromG2AtX900 = true;
      for (Train otherTrain : trains) {
        if (otherTrain != t && otherTrain.destination == g3) {
          if (otherTrain.x < 900 ) {
            allOtherTrainsFromG2AtX900 = false;
            break;
          }
        }
      }

      if (allOtherTrainsFromG2AtX900) {
        t.aCommence = false;
        t.debutAttente = -1;
        t.tBezier1 = 1;
        t.tBezier=0;
        t.retourCollisiong3 = false;
      }

      continue;
    }



    if (t.retourCollisiong4) {

      d2.procedure_retourG4(t);
      boolean allOtherTrainsFromG2AtX900 = true;
      for (Train otherTrain : trains) {
        if (otherTrain != t && otherTrain.destination == g4) {
          if (otherTrain.x < 900 ) {
            allOtherTrainsFromG2AtX900 = false;
            break;
          }
        }
      }

      if (allOtherTrainsFromG2AtX900) {
        t.aCommence = false;
        t.debutAttente = -1;
        t.tBezier1 = 1;
        t.tBezier=0;
        t.retourCollisiong4 = false;
      }

      continue;
    }


    if (t.retourCollisiong5) {

      GareS_D.procedure_retour_g1g2(t);

      boolean allOtherTrainsFromG2GoingToG1AtSafePos = true;
      for (Train otherTrain : trains) {
        // 🔎 On cible uniquement les trains qui viennent de G2 et qui vont vers G1
        if (otherTrain != t &&  otherTrain.destination == g1) {
          if (otherTrain.x > 100) { // 🚦 Position pas encore sécurisée
            allOtherTrainsFromG2GoingToG1AtSafePos = false;
            break;
          }
        }
      }

      if (allOtherTrainsFromG2GoingToG1AtSafePos) {
        t.aCommence = false;
        t.debutAttente = -1;
        t.tBezier1 = 1;
        t.tBezier = 0;
        t.retourCollisiong5 = false;
      }

      continue;
    }


    if (t.retourCollisiong6) {

      GareS_C.procedure_retour_g3g4(t);



      boolean allOtherTrainsFromG2AtX900 = true;
      for (Train otherTrain : trains) {
        if (otherTrain != t && otherTrain.destination == g3) {
          if (otherTrain.x < 900) {
            allOtherTrainsFromG2AtX900 = false;
            break;
          }
        }
      }

      if (allOtherTrainsFromG2AtX900) {
        t.aCommence = false;
        t.debutAttente = -1;
        t.tBezier1 = 1;
        t.tBezier=0;
        t.retourCollisiong6 = false;
      }

      continue;
    }
  }




  for (Train t : depart.train_en_garezz) {
    // ❌ Si ce n’est pas la bonne route pour SA destination, on saute
    if (t.destination != destination) continue;

    // ❌ Déjà traité sur cette frame ? (évite la multi-exécution)
    if (t.lastFrameUpdated == currentFrame) continue;


    // collisions/retours gérés ailleurs
    if (t.retourCollision || t.retourCollisiong3|| t.retourCollisiong4 || t.retourCollisiong6  ) continue;

    // ⏱️ cooldown + verrou "un départ par frame" (patch précédent)
    if (!t.aCommence) {
      if (millis() < depart.prochainDepartApres) continue;
      if (depart.aLanceUnTrainCeFrame) continue;

      t.aCommence = true;
      t.debutAttente = -1;
      depart.prochainDepartApres = millis() + 4000;
      depart.aLanceUnTrainCeFrame = true;
    }

    // ✅ MARQUER qu'on va le bouger UNE SEULE FOIS sur cette frame
    t.lastFrameUpdated = currentFrame;

    // route normale (inchangée)
    if (depart == g2 && destination == g4) {
      trajetG2versG4(t);
    } else if (depart == g4 && destination == g2) {
      trajetG4versG2(t);
    } else if (depart == g2 && destination == g3) {
      trajetG2versG3(t);
    } else if (depart == g3 && destination == g2) {
      trajetG3versG2(t);
    } else if (depart == g1 && destination == g4) {
      trajetG1versG4(t);
    } else if (depart == g4 && destination == g1) {
      trajetG4versG1(t);
    } else if (depart == g2 && destination == g1) {
      trajetG2versG1(t);
    } else if (depart == g1 && destination == g2) {
      trajetG1versG2(t);
    } else if (depart == g4 && destination == g3) {
      trajetG4versG3(t);
    } else if (depart == g3 && destination == g4) {
      trajetG3versG4(t);
    }
  }
}




void mousePressed() {
  // 1) Clique sur un train → "oui, c'est moi"
  ui.onMousePressed(mouseX, mouseY);
  // 2) Clique sur un bouton → spawn
  for (int i = 0; i < boutons.length; i++) {
    if (boutons[i].isClicked(mouseX, mouseY)) {
      spawnTrain(i);
      break; // optionnel: on s’arrête au premier bouton touché
    }
  }
}



void spawnTrain(int index) {
  Train t = null;

  switch(index) {
  case 0:
    t = g1.spawn();
    if (t != null) {
      t.destination = g2;
      gareDepart = g1;
      gareDestination = g2;
    }
    break;
  case 1:
    t = g2.spawn();
    if (t != null) {
      t.destination = g1;
      gareDepart = g2;
      gareDestination = g1;
    }
    break;
  case 2:
    t = g1.spawn();
    if (t != null) {
      t.destination = g3;
      gareDepart = g1;
      gareDestination = g3;
    }
    break;
  case 3:
    t = g3.spawn();
    if (t != null) {
      t.destination = g1;
      gareDepart = g3;
      gareDestination = g1;
    }
    break;
  case 4:
    t = g1.spawn();
    if (t != null) {
      t.destination = g4;
      gareDepart = g1;
      gareDestination = g4;
    }
    break;
  case 5:
    t = g4.spawn();
    if (t != null) {
      t.destination = g1;
      gareDepart = g4;
      gareDestination = g1;
    }
    break;
  case 6:
    t = g2.spawn();
    if (t != null) {
      t.destination = g3;
      gareDepart = g2;
      gareDestination = g3;
    }
    break;
  case 7:
    t = g3.spawn();
    if (t != null) {
      t.destination = g2;
      gareDepart = g3;
      gareDestination = g2;
    }
    break;
  case 8:
    t = g2.spawn();
    if (t != null) {
      t.destination = g4;
      gareDepart = g2;
      gareDestination = g4;
    }
    break;
  case 9:
    t = g4.spawn();
    if (t != null) {
      t.destination = g2;
      gareDepart = g4;
      gareDestination = g2;
    }
    break;
  case 10:
    t = g3.spawn();
    if (t != null) {
      t.destination = g4;
      gareDepart = g3;
      gareDestination = g4;
    }
    break;
  case 11:
    t = g4.spawn();
    if (t != null) {
      t.destination = g3;
      gareDepart = g4;
      gareDestination = g3;
    }
    break;
  }

  if (t != null) {
  }
}

void trajetG2versG4(Train t ) {
  if (t.x < 160) {
    g2.move(t);
    
    gb1.faireSuivreAiguillage(t);
  } else if (t.x>=160 && t.x<b1.x+b1.width-t.largeur)b1.traverser_bande(t);

  else if (t.x>=b1.x+b1.width-t.largeur && t.x<GareS_B.x) {
    gb2.basculer(GareS_B);
    if (fsb1.estVert) {
      GareS_B.entrer_gares(t, fsb1, fsb2);
    }
  } else if (t.x>=GareS_B.x && t.x <GareS_B.x+GareS_B.width-t.largeur ) {
    b1.train_en_bande.remove(t);
    GareS_B.moveAvecPausenormal(t);

    gd1.basculerSortie(t);
  } else if (t.x >= GareS_B.x + GareS_B.width-t.largeur && t.x < b4.x) {
    boolean conflit = false;
    for (Train t1 : b4.train_en_bande) {
      if (t1.destination != t.destination) { // 🟡 Compare bien les références (et pas .equals)
        conflit = true;  // ⚠️ Train déjà dans la bande avec autre départ
        break;
      }
    }
    if (!conflit) {
      //GareS_B.train_en_gare.remove(t);
      t.avancer(b4.x, b4.y);
    }
    // sinon on ne fait rien → il attend
  } else if (t.x>=b4.x && t.x<b4.x+b4.width-t.largeur) {
    GareS_B.train_en_gare.remove(t);

    b4.traverser_bande(t);
  } else if (t.x>=b4.x+b4.width-t.largeur && t.x<g4.x && f4.estVert==true) {
    gd2.basculer1(g4);
    g4.entrer_gare(t);

    b4.train_en_bande.removeIf(tr -> tr.id == t.id);
    t.pauseDejaActivee = false;
    g4.quitter_gare(t);
  }
}


void trajetG4versG2(Train t) {
  b4.gerer_colision(g4, g2);
  if (t.x <= 975 && t.x > 900) {
    g4.move(t);
  } else if (t.x <= 900 && t.x > 833) {
    if (t.x<g4.x-t.largeur)g4.train_en_gare.remove(t);
    f4.mettreAJourSelonGare(g4);
    t.avancer(833, 130);
    b4.train_en_bande.add(t);
  } else if (t.x <= 833 && t.x > b4.x) {
    t.avancer(b4.x, b4.y);
  } else if (t.x <= b4.x && t.x > 532) {
    gd1.basculer(GareS_B);
    GareS_B.entrer_gares(t, fsb1, fsb2);
  } else if (t.x <= GareS_B.x + GareS_B.width && t.x > GareS_B.x) {
    b4.train_en_bande.remove(t);
    GareS_B.moveAvecPauseArriere(t);
    fsb1.mettreAJourSelonGares(GareS_B);
    fsb2.mettreAJourSelonGares(GareS_B);
    gb2.basculerSortie(t);
  } else if (t.x <= GareS_B.x && t.x > b1.x) {
    fsb1.mettreAJourSelonGares(GareS_B);
    fsb2.mettreAJourSelonGares(GareS_B);
    boolean conflit = false;
    for (Train t1 : b1.train_en_bande) {
      if (t1.destination != t.destination) {
        conflit = true;
        break;
      }
    }
    if (!conflit) {
      GareS_B.train_en_gare.remove(t);
      t.avancer(b1.x, b1.y);
    }
  } else if (t.x <= b1.x && t.x > g2.x) {
    gb1.basculer1(g2);
    g2.entrer_gare(t);
  }
  if (t.destination.train_en_gare.contains(t)) {
    t.destination.quitter_gare(t);   // il sort, point final
  }
  if (t.x<=48) {
    t.x=2000;
    t.destination.train_en_gare.remove(t);
    t.destination.train_en_garezz.remove(t);
    trains.remove(t);
  }
}

void trajetG2versG3(Train t) {

  if (t.x < 360) {
    g2.move(t);
    gb1.faireSuivreAiguillage(t);
    d1.faireSuivreCourbe(t);
    if (!d1.train_en_dev.contains(t)) {
      d1.train_en_dev.add(t);
    }
  } else if (t.x >= 360 && t.x < 390) {
    d1.train_en_dev.remove(t);
    gsd1.basculer(GareS_D);
    GareS_D.entrer_gares(t, fsd1, fsd2);
  } else if (t.x >= 390 && t.x < 440-t.largeur) {
    GareS_D.moveAvecPausenormal(t);
    gsd2.basculerSortie(t);
  } else if (t.x >= 440-t.largeur && t.x < 460) {
    t.pauseDejaActivee = false;
    boolean conflit = false;
    for (Train t1 : b6.train_en_bande) {
      if (t1.destination != t.destination) {
        conflit = true;
        break;
      }
    }
    if (!conflit) {
      if (!b6.train_en_bande.contains(t)) {
        b6.train_en_bande.add(t);
      }
      GareS_D.train_en_gare.remove(t);
      t.avancer(b6.x, b6.y);
    }
  } else if (t.x >= 460 && t.x < 560-t.largeur) {

    b6.traverser_bande(t);
  } else if (t.x >= 560-t.largeur && t.x < 580) {
    gsc1.basculer(GareS_C);
    GareS_C.entrer_gares(t, fsc1, fsc2);
    t.pauseDejaActivee = false;
  } else if (t.x >= 580 && t.x < 630-t.largeur) {
    if (b6.train_en_bande.contains(t)) {
      b6.train_en_bande.remove(t);
    }

    gsc2.basculerSortie(t);
    GareS_C.moveAvecPause(t);
    fsc1.mettreAJourSelonGares(GareS_C);
    fsc2.mettreAJourSelonGares(GareS_C);
  } else if (t.x >= 630-t.largeur && t.x < 650) {
    boolean conflit = false;
    for (Train t1 : d4.train_en_dev) {
      if (t1.destination != t.destination) {
        conflit = true;
        break;
      }
    }
    if (!conflit) {
      GareS_C.train_en_gare.remove(t);
      t.avancer(650, 395);
      t.tBezier = 0;
    }
  } else if (t.x >= 650 && t.x < 861) {
    d4.faireSuivreCourbeInverse(t);
    if (!d4.train_en_dev.contains(t)) {
      d4.train_en_dev.add(t);
    }
  } else if (t.x >= 861 && t.x<899) {
    gc2.basculer1(g3);
    g3.entrer_gare(t);
    if (d4.train_en_dev.contains(t)) {
      d4.train_en_dev.remove(t);
    }
  } else if (t.x>=899)g3.quitter_gare(t);
}

void trajetG3versG2(Train t) {


  d4.detecter_colisiong2g3(t); // ou deviation4, retour à g3
  if (t.x <= 975 && t.x>870) g3.move(t);
  else if (t.x <= 870 && t.x > 833 ) {
    g3.train_en_gare.remove(t);
    t.avancer(833, 630);
  } else if (t.x <= 833  && t.x > 650) {
    d4.faireSuivreCourbeArriere(t);
    if (!d4.train_en_dev.contains(t)) {
      d4.train_en_dev.add(t);
    }
  } else if (t.x <= 650 && t.x > 630) {

    gsc2.basculer(GareS_C);
    GareS_C.entrer_gares(t, fsc1, fsc2);
  } else if (t.x <= 630 && t.x > 580) {
    d4.train_en_dev.remove(t);
    GareS_C.moveAvecPauseArriere(t);
    fsc1.mettreAJourSelonGares(GareS_C);
    fsc2.mettreAJourSelonGares(GareS_C);
    gsc1.basculer(GareS_C);
  } else if (t.x <= 580 && t.x > 560-t.largeur) {
    t.pauseDejaActivee = false;
    boolean conflit = false;
    for (Train t1 : b6.train_en_bande) {
      if (t1.destination != t.destination) {
        conflit = true;
        break;
      }
    }
    int compteur = 0;
    for (Train t2 : GareS_D.train_en_gare) {
      if ( t2.depart != t.depart) {
        compteur++;
      }
    }
    if (compteur >= 2) {  // ✅ On exige 2 trains
      conflit = true;
    }
    if (!conflit) {
      for (Train td : d1.train_en_dev) {
        if ((td.destination == g3 || td.destination == g4) && td.x >= 190) {
          conflit = true;
          break;
        }
      }
    }
    if (!conflit) {
      for (Train td : d2.train_en_dev) {
        if ((td.destination == g3 || td.destination == g4) && td.x >= 190) {
          conflit = true;
          break;
        }
      }
    }





    if (!conflit) {
      GareS_C.train_en_gare.remove(t);
      if (!b6.train_en_bande.contains(t)) {
        b6.train_en_bande.add(t);
      }
      t.avancer(b6.x+b6.width-t.largeur, b6.y);
    }
  } else if (t.x <= 560 && t.x > 460) {
    //t.avancer(460, 390);
    b6.traverser_bande_gauche(t);
  } else if (t.x <= 460 && t.x > 440) {
    gsd2.basculer(GareS_D);
    GareS_D.entrer_gares(t, fsd1, fsd2);
  } else if (t.x <= 440 && t.x > 390) {
    GareS_D.moveAvecPauseArriere(t);
    if (b6.train_en_bande.contains(t)) {
      b6.train_en_bande.remove(t);
    }
    fsd1.mettreAJourSelonGares(GareS_D);
    fsd2.mettreAJourSelonGares(GareS_D);
    gsd1.basculer(GareS_D);
  } else if (t.x <= 390 && t.x > 360) {
    t.pauseDejaActivee = false;
    t.avancer(360, 395);
  } else if (t.x <= 360 && t.x > 161) {
    GareS_D.train_en_gare.remove(t);
    d1.faireSuivreCourbeInverse(t);
    if (!d1.train_en_dev.contains(t)) {
      d1.train_en_dev.add(t);
    }
  } else if (t.x <= 161) {
    gb1.basculer1(g2);
    g2.entrer_gare(t);
    if (d1.train_en_dev.contains(t)) {
      d1.train_en_dev.remove(t);
    }
    if (t.destination.train_en_gare.contains(t)) {
      t.destination.quitter_gare(t);   // il sort, point final
    }
    if (t.x<=48) {
      t.x=2000;
      t.destination.train_en_gare.remove(t);
      t.destination.train_en_garezz.remove(t);
      trains.remove(t);
    }
  }
}

void trajetG1versG4(Train t) {
  if (t.x < 360) {
    g1.move(t);
    ga1.faireSuivreAiguillage(t);
    d3.faireSuivreCourbe(t);
    if (!d3.train_en_dev.contains(t)) {
      d3.train_en_dev.add(t);
    }
  } else if (t.x >= 360 && t.x < 390) {
    d3.train_en_dev.remove(t);
    gsd1.basculer(GareS_D);
    GareS_D.entrer_gares(t, fsd1, fsd2);
  } else if (t.x >= 390 && t.x < 440 - t.largeur) {
    GareS_D.moveAvecPausenormal(t);
    gsd2.basculerSortie(t);
  } else if (t.x >= 440 - t.largeur && t.x < 460) {
    t.pauseDejaActivee = false;
    boolean conflit = false;
    for (Train t1 : b6.train_en_bande) {
      if (t1.destination != t.destination) {
        conflit = true;
        break;
      }
    }
    if (!conflit) {
      if (!b6.train_en_bande.contains(t)) {
        b6.train_en_bande.add(t);
      }
      GareS_D.train_en_gare.remove(t);
      t.avancer(b6.x, b6.y);
    }
  } else if (t.x >= 460 && t.x < 560 - t.largeur) {
    b6.traverser_bande(t);
  } else if (t.x >= 560 - t.largeur && t.x < 580) {
    gsc1.basculer(GareS_C);
    GareS_C.entrer_gares(t, fsc1, fsc2);
    t.pauseDejaActivee = false;
  } else if (t.x >= 580 && t.x < 630 - t.largeur) {
    if (b6.train_en_bande.contains(t)) {
      b6.train_en_bande.remove(t);
    }
    gsc2.basculerSortie(t);
    GareS_C.moveAvecPause(t);
    fsc1.mettreAJourSelonGares(GareS_C);
    fsc2.mettreAJourSelonGares(GareS_C);
  } else if (t.x >= 630 - t.largeur && t.x < 650) {
    boolean conflit = false;
    for (Train t1 : d2.train_en_dev) {
      if (t1.destination != t.destination) {
        conflit = true;
        break;
      }
    }
    if (!conflit) {
      GareS_C.train_en_gare.remove(t);
      t.avancer(650, 395);
      t.tBezier = 0;
    }
  } else if (t.x >= 650 && t.x < 861) {
    d2.faireSuivreCourbeInverse(t);
    if (!d2.train_en_dev.contains(t)) {
      d2.train_en_dev.add(t);
    }
  } else if (t.x >= 861 && t.x<899) {
    gd2.basculer1(g4);
    g4.entrer_gare(t);
    if (d2.train_en_dev.contains(t)) {
      d2.train_en_dev.remove(t);
    }
  } else if (t.x>=899)g4.quitter_gare(t);
}


void trajetG4versG1(Train t) {
  d2.detecter_colisiong2g4(t);
  if (t.x <= 975 && t.x > 870) {
    g4.move(t);
    gd2.basculerSortie(t);
  } else if (t.x <= 870 && t.x > 833) {
    g4.train_en_gare.remove(t);

    t.avancer(833, 130);
  } else if (t.x <= 833 && t.x > 650) {
    d2.faireSuivreCourbeArriere(t);
  } else if (t.x <= 650 && t.x > 630) {
    d2.train_en_dev.remove(t);
    gsc2.basculer(GareS_C);
    GareS_C.entrer_gares(t, fsc1, fsc2);
  } else if (t.x <= 630 && t.x > 580) {
    GareS_C.moveAvecPauseArriere(t);
    fsc1.mettreAJourSelonGares(GareS_C);
    fsc2.mettreAJourSelonGares(GareS_C);
    gsc1.basculer(GareS_C);
  } else if (t.x <= 580 && t.x > 560 - t.largeur) {
    t.pauseDejaActivee = false;
    boolean conflit = false;
    for (Train t1 : b6.train_en_bande) {
      if (t1.destination != t.destination) {
        conflit = true;
        break;
      }
    }
    int compteur = 0;
    for (Train t2 : GareS_D.train_en_gare) {
      if ( t2.depart != t.depart) {
        compteur++;
      }
    }
    if (compteur >= 2) {  // ✅ On exige 2 trains
      conflit = true;
    }


    if (!conflit) {
      GareS_C.train_en_gare.remove(t);
      if (!b6.train_en_bande.contains(t)) {
        b6.train_en_bande.add(t);
      }
      t.avancer(b6.x + b6.width - t.largeur, b6.y);
    }
  } else if (t.x <= 560 && t.x > 460) {
    b6.traverser_bande_gauche(t);
  } else if (t.x <= 460 && t.x > 440) {
    gsd2.basculer(GareS_D);
    GareS_D.entrer_gares(t, fsd1, fsd2);
  } else if (t.x <= 440 && t.x > 390) {
    GareS_D.moveAvecPauseArriere(t);
    if (b6.train_en_bande.contains(t)) {
      b6.train_en_bande.remove(t);
    }
    fsd1.mettreAJourSelonGares(GareS_D);
    fsd2.mettreAJourSelonGares(GareS_D);
    gsd1.basculer(GareS_D);
  } else if (t.x <= 390 && t.x > 360) {
    t.pauseDejaActivee = false;
    t.avancer(360, 395);
  } else if (t.x <= 360 && t.x > 161) {
    GareS_D.train_en_gare.remove(t);
    d3.faireSuivreCourbeInverse(t);
    if (!d3.train_en_dev.contains(t)) {
      d3.train_en_dev.add(t);
    }
  } else if (t.x <= 161) {
    ga1.basculer1(g1);
    t.destination.entrer_gare(t);
    if (d3.train_en_dev.contains(t)) {
      d3.train_en_dev.remove(t);
    }
    if (t.destination.train_en_gare.contains(t)) {
      t.destination.quitter_gare(t);   // il sort, point final
    }
    if (t.x<=48) {
      t.x=2000;
      t.destination.train_en_gare.remove(t);
      t.destination.train_en_garezz.remove(t);
      trains.remove(t);
    }
  }
}

void proaller(Train t) {
  if (t.x < 360) {
    g2.move(t);
    g3.train_en_gare.remove(t);
    gb1.faireSuivreAiguillage(t);
    d1.faireSuivreCourbe(t);
    if (!d1.train_en_dev.contains(t)) {
      d1.train_en_dev.add(t);
    }
  } else if (t.x >= 360 && t.x < 390) {
    d1.train_en_dev.remove(t);
    gsd1.basculer(GareS_D);
    GareS_D.entrer_gares(t, fsd1, fsd2);
  } else if (t.x >= 390 && t.x < 440 - t.largeur) {
    GareS_D.moveAvecPausenormal(t);
    if (t.x >= 404 && !t.coresp) {
      t.coresp = true;
    }
  }
  if (t.x >= (440 - t.largeur) && !t.coresp) {
    t.coresp = true;
  }
}

void proretour(Train t) {
  boolean autreTrainPresent = false;
  for (Train autre : d3.train_en_dev) {
    if (autre != t && autre.destination != t.destination) {
      autreTrainPresent = true;
      break;
    }
  }

  if (!autreTrainPresent) {
    GareS_D.moveAvecPauseArriere(t);
  }

  fsd1.mettreAJourSelonGares(GareS_D);
  fsd2.mettreAJourSelonGares(GareS_D);
  gsd1.basculer(GareS_D);

  if (t.x <= 390 && t.x > 360) {
    t.pauseDejaActivee = false;
    t.avancer(360, 395);
    t.tBezier = 0;
  } else if (t.x <= 360 && t.x > 161) {

    d3.faireSuivreCourbeInverse(t);
    if (!d3.train_en_dev.contains(t)) {
      d3.train_en_dev.add(t);
    }
  } else if (t.x <= 161 && t.x>51) {

    g1.entrer_gare(t);
    ga1.basculer1(g1);
    if (d3.train_en_dev.contains(t)) {
      d3.train_en_dev.remove(t);
    }
  } else if ( t.x==51) {
    t.x=-100;
    t.y=1000;
    g1.train_en_gare.remove(t);
    g1.train_en_garezz.remove(t);
    trains.remove(t);
  }
}

void trajetG2versG1(Train t) {
  if (!t.coresp) {
    proaller(t);
  } else {
    proretour(t);
  }
}

void proallerInverse(Train t) {
  if (t.x < 360) {
    g1.move(t);                 // 🚆 Départ G1
    ga1.faireSuivreAiguillage(t);
    d3.faireSuivreCourbe(t);
    if (!d3.train_en_dev.contains(t)) {
      d3.train_en_dev.add(t);
    }
  } else if (t.x >= 360 && t.x < 390) {
    d3.train_en_dev.remove(t);
    gsd1.basculer(GareS_D);
    GareS_D.entrer_gares(t, fsd1, fsd2);
  } else if (t.x >= 390 && t.x < 440 - t.largeur) {
    GareS_D.moveAvecPausenormal(t); // même logique que l'aller G2→G1
    if (t.x >= 404 && !t.coresp) {
      t.coresp = true;
    }
  }
  if (t.x >= (440 - t.largeur) && !t.coresp) {
    t.coresp = true;
  }
}


void proretourInverse(Train t) {
  boolean autreTrainPresent = false;
  for (Train autre : d1.train_en_dev) {
    if (autre != t && autre.destination != t.destination) {
      autreTrainPresent = true;
      break;
    }
  }

  if (!autreTrainPresent) {
    GareS_D.moveAvecPauseArriere(t);
  }
  fsd1.mettreAJourSelonGares(GareS_D);
  fsd2.mettreAJourSelonGares(GareS_D);
  gsd1.basculer(GareS_D);

  if (t.x <= 390 && t.x > 360) {
    t.pauseDejaActivee = false;
    t.avancer(360, 395);
    t.tBezier = 0;
  } else if (t.x <= 360 && t.x > 161) {

    d1.faireSuivreCourbeInverse(t);
    if (!d1.train_en_dev.contains(t)) {
      d1.train_en_dev.add(t);
    }
  } else if (t.x <= 161 && t.x>51) {
    gb1.basculer1(g2);
    g2.entrer_gare(t);

    if (d1.train_en_dev.contains(t)) {
      d1.train_en_dev.remove(t);
    }
  } else if ( t.x==51) {
    t.x=-100;
    t.y=1000;
    g2.train_en_gare.remove(t);
    g2.train_en_garezz.remove(t);
    trains.remove(t);
  }
}


void trajetG1versG2(Train t) {
  if (!t.coresp) {
    proallerInverse(t);
  } else {
    proretourInverse(t);
  }
}

void proallerg4(Train t) {
  if (t.x <= 975 && t.x > 870) {
    // 🚆 Départ de la gare G4
    g4.move(t);
  } else if (t.x <= 870 && t.x > 833) {
    // ➡️ Avancer vers l'entrée de la déviation
    g4.train_en_gare.remove(t);
    t.avancer(833, 130);
  } else if (t.x <= 833 && t.x > 650) {
    // 🌀 Suivre la courbe déviation2
    d2.faireSuivreCourbeArriere(t);
    if (!d2.train_en_dev.contains(t)) {
      d2.train_en_dev.add(t);
    }
  } else if (t.x <= 650 && t.x > 630) {
    // 🚉 Entrée dans Gare Secondaire C
    if (d2.train_en_dev.contains(t)) {
      d2.train_en_dev.remove(t);
    }
    gsc2.basculer(GareS_C);
    GareS_C.entrer_gares(t, fsc1, fsc2);
  } else if (t.x <= 630 && t.x > 580) {
    // ⏸️ Pause à l'intérieur de la gare secondaire
    GareS_C.moveAvecPauseArriere(t); // ✅ Déplacement droite → gauche
  }

  // 🔒 Sécurité : si le train dépasse la zone, on force le retour
  if (t.x <= GareS_C.x  && !t.coresp) {
    t.coresp = true;
  }
}





void proretourg4(Train t) {
  // Mouvement arrière dans la gare secondaire C
  boolean autreTrainPresent = false;
  for (Train autre : d4.train_en_dev) {
    if (autre != t && autre.destination != t.destination) {
      autreTrainPresent = true;
      break;
    }
  }

  if (!autreTrainPresent) {
    GareS_C.moveAvecPausenormal(t);
  }
  GareS_C.moveAvecPausenormal(t);
  fsc1.mettreAJourSelonGares(GareS_C);
  fsc2.mettreAJourSelonGares(GareS_C);
  gsc1.basculer(GareS_C);

  if (t.x >= 630 && t.x < 650) {
    t.pauseDejaActivee = false;
    t.avancer(650, 395);
    t.tBezier = 0;
  } else if (t.x >= 650 && t.x < 861) {
    GareS_C.train_en_gare.remove(t);
    d4.faireSuivreCourbeInverse(t);
    if (!d4.train_en_dev.contains(t)) {
      d4.train_en_dev.add(t);
    }
  } else if (t.x >= 861 && t.x<899) {
    gc2.basculer1(g3);
    g3.entrer_gare(t);
    if (d4.train_en_dev.contains(t)) {
      d4.train_en_dev.remove(t);
    }
  } else if (t.x>=899) {
    g3.quitter_gare(t);
    if (!g3.train_en_gare.contains(t)) {
      g3.train_en_gare.add(t);
    }
  }
}

void trajetG4versG3(Train t) {
  if (!t.coresp) {
    proallerg4(t);
  } else {
    proretourg4(t);
  }
}


void proallerg3(Train t) {
  if (t.x <= 975 && t.x > 870) {
    g3.move(t); // 🚆 Départ de la gare G3
  } else if (t.x <= 870 && t.x > 833) {
    g3.train_en_gare.remove(t);
    t.avancer(833, 630); // ➡️ Avancer vers l'entrée de la déviation
  } else if (t.x <= 833 && t.x > 650) {
    d4.faireSuivreCourbeArriere(t);
    if (!d4.train_en_dev.contains(t)) {
      d4.train_en_dev.add(t);
    }
  } else if (t.x <= 650 && t.x > 630) {
    if (d4.train_en_dev.contains(t)) {
      d4.train_en_dev.remove(t);
    }
    gsc2.basculer(GareS_C);
    if (GareS_C.train_en_gare.size()<2)GareS_C.entrer_gares(t, fsc1, fsc2);
  } else if (t.x <= 630 && t.x > 580) {
    // ⏸️ Pause uniquement dans l’aller
    GareS_C.moveAvecPauseArriere(t);
  }

  if (t.x <= GareS_C.x  && !t.coresp) {
    t.coresp = true;
  }
}

void proretourg3(Train t) {
  // Retour sans pause → mouvement fluide
  boolean autreTrainPresent = false;
  for (Train autre : d2.train_en_dev) {
    if (autre != t && autre.destination != t.destination) {
      autreTrainPresent = true;
      break;
    }
  }

  if (!autreTrainPresent) {
    GareS_C.moveAvecPausenormal(t);
  }

  fsc1.mettreAJourSelonGares(GareS_C);
  fsc2.mettreAJourSelonGares(GareS_C);
  gsc1.basculer(GareS_C);

  if (t.x >= 630 && t.x < 650) {
    t.pauseDejaActivee = false;

    t.avancer(650, 395);

    t.tBezier = 0;
  } else if (t.x >= 650 && t.x < 861) {
    GareS_C.train_en_gare.remove(t);

    d2.faireSuivreCourbeInverse(t);
    if (!d2.train_en_dev.contains(t)) {
      d2.train_en_dev.add(t);
    }
  } else if (t.x >= 861 && t.x<g4.x-1) {
    if (d2.train_en_dev.contains(t)) {
      d2.train_en_dev.remove(t);
    }


    g4.entrer_gare(t);
    gd2.basculer1(g4);
  } else if (t.x>=899) {
    g4.quitter_gare(t);
    if (!g4.train_en_gare.contains(t)) {
      g4.train_en_gare.add(t);
    }
  }
}


void trajetG3versG4(Train t) {
  if (!t.coresp) {
    proallerg3(t); // Aller → avec pause
  } else {
    proretourg3(t); // Retour → sans pause
  }
}




















//colision generale

void gererRencontresD2D4() {
  // 1. réinitialiser les vitesses à la valeur normale
  for (Train t : trains) {
    t.vitesseBezier = 0.003f;
  }
  // 2. détecter s’il y a des trains dans D2 et D4
  if (!d2.train_en_dev.isEmpty() && !d4.train_en_dev.isEmpty()) {
    for (Train t2 : d2.train_en_dev) {
      for (Train t4 : d4.train_en_dev) {
        // si les positions sont proches du croisement
        if (abs(t2.x - t4.x) < 50 && abs(t2.y - t4.y) < 50) {
          // ralentir le train de la déviation 4
          t4.vitesseBezier = 0.001f;
        }
      }
    }
  }
}


void colispsodpaij() {

  if ( GareS_C.train_en_gare.size()>1) {
    boolean allTrainsToG1orG2 = true;
    for (Train t : GareS_C.train_en_gare) {
      if (t.destination != g1 && t.destination != g2) {
        allTrainsToG1orG2 = false;
        break; // Sortir de la boucle dès qu'un train ne correspond pas
      }
    }
    if (allTrainsToG1orG2) {

      // Condition 3 & 4 : Vérifier si la bande b6 contient un train
      // qui se dirige vers g4 ou g3
      if (b6.train_en_bande.size() > 0) {
        Train trainB6 = b6.train_en_bande.get(0); // On prend le premier train

        if (trainB6.destination == g4 || trainB6.destination == g3) {

          // Action : Si toutes les conditions sont remplies,
          // le premier train de GareSC est mis en état de collision
          if (GareS_C.train_en_gare.size() > 0) {
            GareS_C.train_en_gare.get(1).retourCollisiong3 = true;
            println("Collision détectée ! Le train en GareSC est redirigé vers g4.");
          }
        }
      }
      if ( GareS_C.train_en_gare.size()>1) {
        boolean allTrainsToG1orG0 = true;
        for (Train t : GareS_D.train_en_gare) {
          if (t.destination != g3 && t.destination != g4) {
            allTrainsToG1orG0 = false;
            break; // Sortir de la boucle dès qu'un train ne correspond pas
          }
        }
        if (allTrainsToG1orG0) {
          GareS_C.train_en_gare.get(0).retourCollisiong3=true;
        }
      }
    }
  } else if (GareS_B.train_en_gare.size()>1) {
    boolean allTrainsToG1orG2 = true;
    for (Train t : GareS_B.train_en_gare) {
      if (t.destination != g2) {
        allTrainsToG1orG2 = false;
        break; // Sortir de la boucle dès qu'un train ne correspond pas
      }
    }
    if (allTrainsToG1orG2) {
      if (b1.train_en_bande.size() > 0) {
        Train trainB6 = b1.train_en_bande.get(0); // On prend le premier train

        if (trainB6.destination == g4) {

          // Action : Si toutes les conditions sont remplies,
          // le premier train de GareSC est mis en état de collision
          if (GareS_B.train_en_gare.size() > 0) {
            GareS_B.train_en_gare.get(1).retourCollision = true;
            println("Collision détectée ! Le train en GareSC est redirigé vers g4.");
          }
        }
      }
    }
  }else if (GareS_D.train_en_gare.size() > 1) {
    boolean allTrainsToG3orG4 = true;
    for (Train t : GareS_D.train_en_gare) {
        if (t.destination != g3 && t.destination != g4) {
            allTrainsToG3orG4 = false;
            break; // Sortir de la boucle dès qu'un train ne correspond pas
        }
    }

    // 🔹 Nouveau test pour GareS_C
    boolean allTrainsCToG1orG2 = true;
    for (Train t : GareS_C.train_en_gare) {
        if (t.destination != g1 && t.destination != g2) {
            allTrainsCToG1orG2 = false;
            break;
        }
    }

    if (allTrainsToG3orG4 && GareS_D.train_en_gare.size() > 1
        && allTrainsCToG1orG2) {

        if (GareS_C.train_en_gare.size() > 1) { // >=2 pour accéder à index 1
            GareS_C.train_en_gare.get(1).retourCollisiong3 = true;
            GareS_D.train_en_gare.get(1).retourCollisiong5 = true;
        }
    }
}

    }
  















void bannerCollision(boolean collision) {
  if (collision) _collisionMsgUntil = millis() + 4000;  // 4 secondes

  if (millis() < _collisionMsgUntil) {
    noStroke();
    fill(230, 30, 30);
    // petit bandeau bas-droite
    float bw = 260, bh = 28, mx = 50, my = 140;
    float x = width - bw - mx, y = height - bh - my;
    rect(x, y, bw, bh, 8);

    fill(255);
    textAlign(CENTER, CENTER);
    textSize(14);
    text("COLLISION DÉTECTÉE — retour immédiat", x + bw/2f, y + bh/2f);

    // reset align pour le reste de ton dessin
    textAlign(LEFT, TOP);
  }
}














/*

 
 void trajetG3versG1(Train t) {
 if (t.x <= 975 && t.x>870) g3.move(t);
 
 else if (t.x <= 870 && t.x > 833 ) t.avancer(833, 630);
 else if (t.x<=833 && t.x>b3.x)t.avancer(b3.x, b3.y);
 else if (t.x<=b3.x && t.x>532) {
 ga2.basculer(GareS_A);
 GareS_A.entrer_gares(t);
 } else if (t.x<=GareS_B.x+GareS_B.width  && t.x >GareS_B.x) {
 GareS_A.moveAvecPauseArriere(t);
 fsa1.mettreAJourSelonGares(GareS_A);
 fsa2.mettreAJourSelonGares(GareS_A);
 ga2.basculerSortie(t);
 } else if (t.x<=GareS_A.x && t.x>b2.x)t.avancer(b2.x, b2.y);
 else if (t.x<=b1.x && t.x>g1.x+g1.width-t.largeur) {
 
 t.avancer(g1.x+g1.width-t.largeur, g1.y);
 g3.train_en_gare.remove(t);
 }
 }
 
 
 
 
 
 void trajetG1versG3(Train t) {
 if (t.x < 160) {
 g1.move(t);
 ga1.faireSuivreAiguillage(t);
 } else if (t.x>=160 && t.x<b1.x+b1.width)t.avancer(b1.x+b1.width, b2.y);
 else if (t.x>=b1.x+b1.width && t.x<GareS_A.x) {
 ga2.basculer(GareS_A);
 GareS_A.entrer_gares(t);
 } else if (t.x>=GareS_A.x && t.x <GareS_A.x+GareS_A.width ) {
 GareS_A.moveAvecPause(t);
 fsa1.mettreAJourSelonGares(GareS_A);
 fsa2.mettreAJourSelonGares(GareS_A);
 gc1.basculerSortie(t);
 } else if (t.x>=GareS_A.x+GareS_A.width && t.x<b4.x)t.avancer(b4.x, b3.y);
 else if (t.x>=b4.x && t.x<b4.x+b4.width)t.avancer(b4.x+b4.width, b3.y);
 else if (t.x>=b4.x+b4.width && t.x<g3.x)t.avancer(g3.x, g3.y);
 }
 */

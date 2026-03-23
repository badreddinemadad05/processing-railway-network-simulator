class Deviation {
  int x1, y1, x2, y2;
  int cx1, cy1, cx2, cy2;
  String nom;
  ArrayList<Train> train_en_dev = new ArrayList<Train>();

  Deviation(int x1, int y1, int cx1, int cy1, int cx2, int cy2, int x2, int y2, String nom) {
    this.x1 = x1;
    this.y1 = y1;
    this.cx1 = cx1;
    this.cy1 = cy1;
    this.cx2 = cx2;
    this.cy2 = cy2;
    this.x2 = x2;
    this.y2 = y2;
    this.nom = nom;
  }

  void afficher() {
  // --- Réglages visuels (identiques à tes gares/bandes) ---
  float gauge = 5;          // écart entre les 2 rails (px)
  float railWeight = 1;     // épaisseur rails
  float tieWeight = 2;      // épaisseur traverses
  float step = 0.001f;       // pas d'échantillonnage [0..1]
  float tieSpacing = 10;    // espacement des traverses en pixels le long de la voie
  float depasse = 2.5;        // traverses qui dépassent un peu (px)

  noFill();

  // Polylignes rails (on échantillonne la courbe)
  stroke(255);
  strokeWeight(railWeight);

  PVector prevL = null, prevR = null;
  float prevPX = Float.NaN, prevPY = Float.NaN;
  float accum = 0; // accumulateur de longueur pour placer les traverses régulièrement

  for (float t = 0; t <= 1.0001f; t += step) {
    float px = bezierPoint(x1, cx1, cx2, x2, t);
    float py = bezierPoint(y1, cy1, cy2, y2, t);

    float tx = bezierTangent(x1, cx1, cx2, x2, t);
    float ty = bezierTangent(y1, cy1, cy2, y2, t);
    float m = sqrt(tx*tx + ty*ty);
    if (m < 1e-6) continue;
    float nx = -ty / m, ny = tx / m;  
    float half = gauge * 0.5f;

    PVector L = new PVector(px + nx*half, py + ny*half);
    PVector R = new PVector(px - nx*half, py - ny*half);

    if (prevL != null) {
      line(prevL.x, prevL.y, L.x, L.y);
      line(prevR.x, prevR.y, R.x, R.y);
    }

    if (!Float.isNaN(prevPX)) {
      float dx = px - prevPX, dy = py - prevPY;
      accum += sqrt(dx*dx + dy*dy);
    }

    // Traverse quand on dépasse le pas choisi
    if (accum >= tieSpacing) {
      stroke(222, 184, 135);
      strokeWeight(tieWeight);
      // petite extension au-delà des rails
      line(L.x + nx*depasse, L.y + ny*depasse, R.x - nx*depasse, R.y - ny*depasse);

      // reset en gardant le reste pour rester régulier
      accum -= tieSpacing;

      // revenir au style rails
      stroke(255);
      strokeWeight(railWeight);
    }

    prevL = L; prevR = R;
    prevPX = px; prevPY = py;
  }

  // Trains sur la déviation
  for (Train t : train_en_dev) t.afficher();

  // Nom au milieu de la courbe (t = 0.5 plutôt que moyenne x1/x2)
  fill(255);
  noStroke();
  textSize(12);
  float mx = bezierPoint(x1, cx1, cx2, x2, 0.5f);
  float my = bezierPoint(y1, cy1, cy2, y2, 0.5f);
  text(this.nom, mx + 6, my - 6);

  // (Option) ligne guide orange si tu veux garder le tracé de référence :
  // stroke(255, 165, 0); strokeWeight(1); noFill();
  // bezier(x1, y1, cx1, cy1, cx2, cy2, x2, y2);
}


  // Suivre la courbe normale
  void faireSuivreCourbe(Train train) {
    
    if ((this == d2 || this == d4) 
      && GareS_C.train_en_gare.size() >= 2
      && !train.retourCollisiong3 && !train.retourCollisiong4   && !train.retourCollisiong6 && 
      (train.destination==g2 ||train.destination==g1)) {
         if (ui != null) {
    ui.p.fill(255, 0, 0);      // rouge
    ui.p.textSize(20);         // grand
    ui.p.text(" A tous les trains de destination \n gare sc  veiller rallentir ",  670, 880); // coordonnées fixes ou calculées
    ui.p.textSize(12);         // remettre normal
}

    return;
  }
  
   if ((this == d1 || this == d3) 
    && GareS_D.train_en_gare.size() >= 2
    && ( (train.destination == g4 && !train.retourCollisiong5) || train.destination == g3  ||
    (train.destination == g1 && train.depart == g2 ) || (train.destination == g2 && train.depart == g1 && !train.retourCollisiong5) ) ) {
    if (ui != null) {
    ui.p.fill(255, 0, 0);      // rouge
    ui.p.textSize(20);         // grand
    ui.p.text(" A tous les trains de destination \n gare sc  veiller rallentir ", 670, 800); // coordonnées fixes ou calculées
    ui.p.textSize(12);         // remettre normal
}

    train.vitesseBezier=0.00035f;

    }
    else {
       train.vitesseBezier= 0.003f;
      
    }

    if (train.x == x1 && train.y == y1) {
      float tx = bezierPoint(x1, cx1, cx2, x2, train.tBezier);
      float ty = bezierPoint(y1, cy1, cy2, y2, train.tBezier);
      train.x = int(tx);
      train.y = int(ty);

      train.tBezier += train.vitesseBezier;
      if (train.tBezier > 1) train.tBezier = 1;
    }
  }

  void procedure_retour(Train t ) {
    if (t.aFiniCourbeInverse) {
      g3.entrer_garerecours(t);
    }
    if (t.x < 650) {
      t.avancer(650, 395);
      GareS_C.train_en_gare.remove(t);
      d4.train_en_dev.add(t);
    } else if (t.tBezier >= 0 && t.tBezier < 1) {
      if ( t.tBezier == 0) {
        t.tBezier = d4.retrouverTBezier(t, d4);
      }
      d4.faireSuivreCourbeInverse(t);
      d4.train_en_dev.remove(t);
      return;
    } else if (t.tBezier >= 1) {
      t.aFiniCourbeInverse = true;
      if (!t.depart.train_en_gare_apres_retour.contains(t)) {
        t.depart.train_en_gare_apres_retour.add(t);}
      fsc1.mettreAJourSelonGares(GareS_C);
      fsc2.mettreAJourSelonGares(GareS_C);
    }
  }


 void procedure_retourG4(Train t) {
  // 1️⃣ Déplacer et gérer le retour (inchangé)
  if (t.aFiniCourbeInverse) {
    g4.entrer_garerecours(t);
  }
  if (t.x < 650) {
    t.avancer(650, 395);
    if (GareS_C.train_en_gare.contains(t)) {
      GareS_C.train_en_gare.remove(t);
    }
    if (!d2.train_en_dev.contains(t)) d2.train_en_dev.add(t);
  } 
  else if (t.tBezier >= 0 && t.tBezier < 1) {
    if (t.tBezier == 0) {
      t.tBezier = d2.retrouverTBezier(t, d2);
    }
    d2.faireSuivreCourbeInverse(t);
    d2.train_en_dev.remove(t);
    return;
  } 
  else if (t.tBezier >= 1) {
    t.aFiniCourbeInverse = true;
    if (!t.depart.train_en_gare_apres_retour.contains(t)) {
      t.depart.train_en_gare_apres_retour.add(t);
    }
  }

  // 2️⃣ 🔥 Nettoyage complet → on supprime tous les trains G4 terminés
  for (int i = GareS_C.train_en_gare.size() - 1; i >= 0; i--) {
    Train tr = GareS_C.train_en_gare.get(i);
    if (tr.depart == g4 && tr.aFiniCourbeInverse) {
      GareS_C.train_en_gare.remove(i);
      println("🚦 Train G4 retiré → feu repasse vert");
    }
  }

  // 3️⃣ ✅ Mise à jour feux après nettoyage
  fsc1.mettreAJourSelonGares(GareS_C);
  fsc2.mettreAJourSelonGares(GareS_C);
}




  void faireSuivreCourbeArriere(Train train) {
     if ((this == d2 || this == d4) 
      && GareS_C.train_en_gare.size() >= 2
      && !train.retourCollisiong3 && !train.retourCollisiong4  && !train.retourCollisiong5 &&!train.retourCollisiong6 &&( (train.destination==g2 ||train.destination==g1) 
      || (train.destination==g3 && train.depart==g4 && train.y<395 )||
      (train.destination==g4 && train.depart==g3 && train.y>395)))  {
          if (ui != null) {
    ui.p.fill(255, 0, 0);      // rouge
    ui.p.textSize(20);         // grand
    ui.p.text(" A tous les trains de destination \n gare sc  veiller rallentir ", 670, 840); // coordonnées fixes ou calculées
    ui.p.textSize(12);         // remettre normal
}

    return;
  }
  
 

  if (!train_en_dev.contains(train)) {
    train_en_dev.add(train);
  }
  if (train.tBezier1 >= 0) {
    float tx = bezierPoint(x1, cx1, cx2, x2, 1 - train.tBezier1);
    float ty = bezierPoint(y1, cy1, cy2, y2, 1 - train.tBezier1);

    train.x = int(tx);
    train.y = int(ty);

    train.tBezier1 -= 0.003;
    if (train.tBezier1 < 0) train.tBezier1 = 0;
  }
}


// Suivre la courbe en sens inverse
void faireSuivreCourbeInverse(Train train) {
  
  
   if ((this == d2 || this == d4) 
     && GareS_C.train_en_gare.size() >= 2
      && !train.retourCollisiong3 && !train.retourCollisiong4  && !train.retourCollisiong5 &&!train.retourCollisiong6 &&( (train.destination==g2 ||train.destination==g1) 
      || (train.destination==g3 && train.depart==g4 && train.y<395 )||
      (train.destination==g4 && train.depart==g3 && train.y>395))) {
        
        if (ui != null) {
    ui.p.fill(255, 0, 0);      // rouge
    ui.p.textSize(20);         // grand
    ui.p.text(" A tous les trains de destination \n gare sc  veiller rallentir ",670, 820); // coordonnées fixes ou calculées
    ui.p.textSize(12);         // remettre normal
}


        
        
        
      return;
  }
  
 
 
  if (train.tBezier < 1) {
    float t = 1 - train.tBezier;

    float tx = bezierPoint(x1, cx1, cx2, x2, t);
    float ty = bezierPoint(y1, cy1, cy2, y2, t);

    train.x = int(tx);
    train.y = int(ty);

    train.tBezier += train.vitesseBezier;
    if (train.tBezier > 1) train.tBezier = 1;
  }
}





float retrouverTBezier(Train train, Deviation d) {
  float meilleurT = 0;
  float minDistance = Float.MAX_VALUE;

  for (float t = 0; t <= 1.0; t += 0.01) {
    float bx = bezierPoint(d.x2, d.cx2, d.cx1, d.x1, t);
    float by = bezierPoint(d.y2, d.cy2, d.cy1, d.y1, t);
    float d2 = dist(train.x, train.y, bx, by);
    if (d2 < minDistance) {
      minDistance = d2;
      meilleurT = t;
    }
  }

  return meilleurT;
}




void retourCollision(Train t, Gare retour) {
  if (!train_en_dev.contains(t)) {
    train_en_dev.add(t);
  }

  faireSuivreCourbeArriere(t); // ⬅️ sens inverse

  if (abs(t.x - retour.x) < 2 && abs(t.y - retour.y) < 2) {
    train_en_dev.remove(t);
    retour.entrer_garerecours(t); // revient à la gare d’origine
  }
}



void detecter_colisiong2g3(Train t) {
  // On ne s'intéresse qu'aux trains en provenance de G3
  if (t.depart != g3) return;

  for (Train t1 : trains) {
    // On cherche un train d'une autre gare
    if (t1.depart == g3) continue;

    // Conditions existantes sur le nombre de trains
    boolean conditionTaille = (GareS_D.train_en_gare.size() > 1 || b6.train_en_bande.size() > 1)
      && (GareS_C.train_en_gare.size() > 1);

    // Nouvelle condition existante : au moins un train dans SD a pour destination G4
    boolean conditionDestination = false;
    for (Train trSD : GareS_D.train_en_gare) {
      if (trSD.destination == g3  || trSD.destination == g4) {
        conditionDestination = true;
        break;
      }
    }

    // Si les conditions existantes sont remplies
    if (conditionTaille && conditionDestination) {

      // NOUVELLE LOGIQUE : Vérifier les destinations des trains dans GareS_C
      boolean allTrainsToG1orG2 = true;
      for (Train trainSC : GareS_C.train_en_gare) {
        if (trainSC.destination != g1 && trainSC.destination != g2) {
          allTrainsToG1orG2 = false;
          break;
        }
      }

      // Si tous les trains de GareS_C vont vers g1 ou g2
      if (allTrainsToG1orG2) {
        // Vérifier si la bande b6 contient un train pour g4 ou g3
        if (b6.train_en_bande.size() > 0) {
          Train trainB6 = b6.train_en_bande.get(0);

          if (trainB6.destination == g4 || trainB6.destination == g3) {

            // ACTION : Activer la collision pour le deuxième train de GareS_C
            // (on vérifie la taille > 1 pour éviter une erreur d'index)
            if (GareS_C.train_en_gare.size() > 1) {
              GareS_C.train_en_gare.get(1).retourCollisiong3 = true;
            }
          }
        }
      }
      
      // La logique existante pour marquer les trains sur la déviation 4
      for (Train t2 : d4.train_en_dev) {
        if (t2.depart == g3 && !t2.retourCollisiong3) {
          t2.retourCollisiong3 = true;
        }
      }

      // Reste de la logique...
      boolean tousOntFini = true;
      if (!d4.train_en_dev.isEmpty()) {
        for (Train t2 : d4.train_en_dev) {
          if (t2.depart == g3 && !t2.aFiniCourbeInverse) {
            tousOntFini = false;
            break;
          }
        }
      }

      if (tousOntFini) {
        if (GareS_C.train_en_gare.size() > 1
          && GareS_C.train_en_gare.get(1).depart == g3
          && GareS_C.train_en_gare.get(0).depart == g3) {
          GareS_C.train_en_gare.get(1).retourCollisiong3 = true;
        }
      }
    }
  }
}

void detecter_colisiong2g4(Train t) {
  if (t.depart != g4) return;

  for (Train t1 : trains) {
    if (t1.depart == g4) continue;

    boolean conditionTaille = (GareS_D.train_en_gare.size() > 1 || b6.train_en_bande.size() > 1)
      && (GareS_C.train_en_gare.size() > 1);

    boolean conditionDestination = false;
    for (Train trSD : GareS_D.train_en_gare) {
      if (trSD.destination == g4 || trSD.destination == g3) { // même logique que G3 mais adapté
        conditionDestination = true;
        break;
      }
    }

    if (conditionTaille && conditionDestination) {
      // Marquer les trains sur la déviation 2
      for (Train tr : d2.train_en_dev) {
        if (tr.depart == g4 && !tr.retourCollisiong4) {
          tr.retourCollisiong4 = true;
          println("Collision détectée sur G4 : drapeau retourCollisiong4 activé pour le train " + tr.id);
        }
      }

      // Vérifier si tous les trains collisionnés ont fini
      boolean tousOntFini = true;
      if (!d2.train_en_dev.isEmpty()) {
        for (Train tr : d2.train_en_dev) {
          if (tr.depart == g4 && !tr.aFiniCourbeInverse) {
            tousOntFini = false;
            break;
          }
        }
      }

      // 🔥 Gestion du deuxième train de SC
      if (tousOntFini) {
        if (GareS_C.train_en_gare.size() > 1
          && GareS_C.train_en_gare.get(0).depart == g4
          && GareS_C.train_en_gare.get(1).depart == g4) {
          GareS_C.train_en_gare.get(1).retourCollisiong4 = true;
          println("Deuxième train en SC marqué pour retour G4");
        }
      }
    }
  }
}













}

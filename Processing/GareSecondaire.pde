class GareSecondaire {
  int x, y;
  ArrayList<Train> train_en_gare = new ArrayList<Train>();
  int width = 50;
  int length = 5;
  int ampleur = 18;
  String nom;


  GareSecondaire(int x, int y, String nom) {
    this.x = x;
    this.y = y;
    this.nom = nom;
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

 void afficher() {
  // Titre (bleu ciel)
  fill(0, 191, 255);
  text(this.nom, this.x, this.y - 12);

  // Réglages identiques à la gare principale
  float gauge = 4;              // écart entre les 2 rails
  float espaceInterVoies = 13;  // espace entre 2 voies
  float pasVoies = gauge + espaceInterVoies;

  float longueur = this.width - 4; // longueur visible des rails
  float yTop = this.y + 1;         // léger décalage sous le bâtiment

  int nbTraverses = 7;
  float depasse = 2;

  // Dessiner 2 voies
  strokeWeight(1);
  for (int i = 0; i < 2; i++) {
    float yCentre = yTop + i * pasVoies;
    dessinerVoie(this.x, yCentre, longueur, gauge, nbTraverses, depasse);
  }

  // (optionnel) Afficher le nombre de trains en gare
  fill(255, 255, 0);
  textSize(10);
  text("(" + train_en_gare.size() + ")", this.x + this.width - 20, this.y +60);

  // Trains présents
  for (Train t : train_en_gare) {
    t.afficher();
  }
}



  void moveAvecPause(Train t) {

    if (!train_en_gare.contains(t) && t.x == this.x + 10) {
      train_en_gare.add(t);
    }


    if (t.pause > 0) {
      t.pause--;
      return;
    }


    if (t.x == this.x + 10 && !t.pauseDejaActivee) {
      t.pause = 300;
      t.pauseDejaActivee = true;
      return;
    }


    if (t.x < this.x + this.width) {
      t.x++;
    }


    if ( t.x >= this.x + this.width) {
   
      train_en_gare.remove(t);
    }
  }

  void moveAvecPausenormal(Train t) {

    if (!train_en_gare.contains(t) && t.x == this.x + 10) {
      train_en_gare.add(t);
    }


    if (t.pause > 0) {
      t.pause--;
      return;
    }


    if (t.x == this.x + 10 && !t.pauseDejaActivee) {
      t.pause = 300;
      t.pauseDejaActivee = true;

      return;
    }


    if (t.x < this.x + this.width) {
      t.x++;
    }
  }




  void moveAvecPauseArriere(Train t) {

    if (!train_en_gare.contains(t) && t.x == this.x+this.width-t.largeur) {
      train_en_gare.add(t);
    }



    if (t.pause > 0) {
      t.pause--;
      return;
    }

    if (t.x == this.x + this.width - 37 && !t.pauseDejaActivee) {
      t.pause = 300;
      t.pauseDejaActivee = true;
      return;
    }

    if (t.x > this.x) {
      t.x--;
    }

    if (t.x <= this.x-t.largeur-5) {
      train_en_gare.remove(t);
    }
  }





  int voieLibre() {
    for (int voie = 0; voie < 2; voie++) {
      int yCible = this.y + this.ampleur * voie;
      boolean occupee = false;

      for (Train t : train_en_gare) {
        if (t.y == yCible) {
          occupee = true;
          break;
        }
      }

      if (!occupee) return voie;
    }

    return -1;
  }

  void entrer_gares(Train t, Feu feu1, Feu feu2) {
    if (!train_en_gare.contains(t) && (  t.x == this.x+this.width )) {
      train_en_gare.add(t);
    }
    if (feu1.estVert && feu2.estVert) {
      int voie = voieLibre();
      t.avancer(this.x, this.y + (this.ampleur) * voie);
    }
    // Sinon, on ne fait rien (le train attend que les deux feux passent au vert)
  }
  
  

void gerercolisiong1g2(Train t) {
    if (this.train_en_gare.size() > 1) {
        boolean tousVersG1G2 = true;

        // ✅ Inclure aussi les trains qui vont vers G4
        for (Train tr : this.train_en_gare) {
            if (tr.destination == g1 ) {
                tousVersG1G2 = false;
                break;
            }
        }

        boolean trainSurDeviationD3 = false;

        for (Train tr : d3.train_en_dev) {
            if ((tr.depart == g1 && tr.destination == g2) ||
                (tr.depart == g1 && tr.destination == g4)) {
                trainSurDeviationD3 = true;
                break;
            }
        }

        if (!tousVersG1G2 && trainSurDeviationD3) {
            for (Train t1 : d3.train_en_dev) {
                if (t1.depart == g1 &&
                    (t1.destination == g2 || t1.destination == g4)) {
                    
                    t1.retourCollisiong5 = true;
                }
            }
        }
    }
}



void procedure_retour_g1g2(Train t) {
    if (t.retourCollisiong5) {

        // ✅ Initialiser une seule fois
        if (!t.dejaEnRetour) {
            t.tBezier = d3.retrouverTBezier(t, d3); 
            t.dejaEnRetour = true;
            
            // 🔹 Forcer une vitesse minimale au retour
            if (t.vitesseBezier <= 0) {
                t.vitesseBezier = 0.005f; // ajustable
            }

            println("[DEBUG] Initialisation retour -> tBezier=" + t.tBezier + " vitesse=" + t.vitesseBezier);
        }

        // 🔄 Déplacement inverse
        t.tBezier = max(0, t.tBezier - t.vitesseBezier);

        // 🚂 Tant qu’on n’est pas revenu → continuer à suivre la courbe
        if (t.tBezier > 0 && t.tBezier < 1) {
            d3.faireSuivreCourbeInverse(t);
        }

        // 🎯 Arrivé à G1
        if (t.x <= 162) {
            t.x = g1.x;
            t.y = g1.y;
            d3.train_en_dev.remove(t);
            t.tBezier = 0;
            t.aFiniCourbeInverse = false;
            t.dejaEnRetour = false;
            t.vitesseBezier = 0;
            t.depart.entrer_gare(t);
        }
    }
}


void gerercolisiong4g3(Train t) {
    if (GareS_C.train_en_gare.size() > 1) { 
        boolean auMoinsUnVersG3 = false;

        // Vérifier au moins un train en GareS_C qui va vers G3
        for (Train tr : GareS_C.train_en_gare) {
            if (tr.destination == g3) {
                auMoinsUnVersG3 = true;
                break;
            }
        }

        if (auMoinsUnVersG3) {
            // Vérifier les trains dans la déviation d4
            for (Train t1 : d4.train_en_dev) {
                if (t1.destination == g4 || t1.destination == g2) {
                    t1.retourCollisiong6 = true;
                }
            }
            
        }
    }
}


void procedure_retour_g3g4(Train t) {
  if (t.aFiniCourbeInverse) {
    g3.entrer_garerecours(t);
    return;
  }

  if (t.tBezier >= 0 && t.tBezier < 1) {
    if (t.tBezier == 0) {
      t.tBezier = d4.retrouverTBezier(t, d4);
    }
    d4.faireSuivreCourbeInverse(t);
    return; // ❌ pas de remove ici
  }

  if (t.tBezier >= 1) {
    t.aFiniCourbeInverse = true;
    d4.train_en_dev.remove(t); // ✅ remove ici, une seule fois
    if (!t.depart.train_en_gare_apres_retour.contains(t)) {
      t.depart.train_en_gare_apres_retour.add(t);
    }
    fsc1.mettreAJourSelonGares(GareS_C);
    fsc2.mettreAJourSelonGares(GareS_C);
  }
}













}

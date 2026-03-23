// Dispatching.pde (ou onglet séparé)
// Affiche un panneau en BAS-DROITE, avec titre + lignes d'infos.
class Dispatching {
  final PApplet p;
  float w, h;
  float marge = 12;         // marge du bord
  boolean visible = true;
  String titre = "Dispatching";
  String[] lignes = new String[0];



  ArrayList<Train> trains = null;
  Train trainSelectionne = null;  
  
  
  // train cliqué
  long showInfoUntil = 0;             // timer d'affichage
  float pickRadius = 16;
  float hitCenterRadius = 30;     // rayon "clic centre" (zone large, facile)
  float hitRingHalfThickness = 10;

  float gare2AnchorX = 0;
  float gare2AnchorY = 0;


  void setGare2Anchor(float x, float y) {
    this.gare2AnchorX = x;
    this.gare2AnchorY = y;
  }


  // Binder la liste des trains
  void setTrains(ArrayList<Train> liste) {
    this.trains = liste;
  }

 void onMousePressed(int mx, int my) {
  if (trains == null) return;

  final float PICK_RADIUS = 16f;          // rayon de l’anneau bleu
  final float HIT_CENTER_RADIUS = 50;    // zone facile au centre
  final float HIT_RING_HALF_THICKNESS = 10f; // tolérance autour de l’anneau

  Train best = null;
  float bestScore = Float.MAX_VALUE;

  for (Train t : trains) {
    if (t == null) continue;

    float d = p.dist(mx, my, t.x, t.y);
    boolean inCenter = (d <= HIT_CENTER_RADIUS);
    float ringInner = Math.max(0, PICK_RADIUS - HIT_RING_HALF_THICKNESS);
    float ringOuter = PICK_RADIUS + HIT_RING_HALF_THICKNESS;
    boolean onRing  = (d >= ringInner && d <= ringOuter);

    if (inCenter || onRing) {
      float score = inCenter ? d : Math.abs(d - PICK_RADIUS);
      if (score < bestScore) { bestScore = score; best = t; }
    }
  }

  if (best != null) {
    trainSelectionne = best;
    showInfoUntil = p.millis() + 3000;
    setLignes("information du train afficher");
  }
}


  Dispatching(PApplet parent, float w, float h) {
    this.p = parent;
    this.w = w;
    this.h = h;
  }

  void setTitre(String t) {
    this.titre = t;
  }
  void setLignes(String... ls) {
    this.lignes = ls;
  }
  void toggle() {
    visible = !visible;
  }

  void draw() {

    if (!visible) return;
    

    // Ancrage bas-droite
    float x = p.width  - w - marge;
    float y = p.height - h - marge;
 

    // Ombre
    p.noStroke();
    p.fill(0, 100);
    p.rect(x + 4, y + 6, w, h, 16);

    // Fond
    p.fill(245);
    p.rect(x, y, w, h, 16);

    // Titre
    p.fill(32);
    p.textAlign(PConstants.LEFT, PConstants.TOP);
    p.textSize(14);
    p.text(titre, x + 12, y + 10);

    // Séparateur
    p.stroke(220);
    p.line(x + 10, y + 32, x + w - 10, y + 32);
    p.noStroke();
    
    

    // Lignes
    p.fill(40);
    p.textSize(12);
    float ty = y + 40;
    for (String s : lignes) {
      p.text(s, x + 12, ty);
      ty += 16;
      if (ty > y + h - 10) break; // évite de déborder
      // --- Affichage fixe au-dessus de la gare 2 pour le train sélectionné ---
      if (trainSelectionne != null) {
        p.fill(0);                       // texte rouge
        p.textAlign(PConstants.CENTER, PConstants.BOTTOM);

        p.textSize(17);
        String nom_gare_destination="gare2";
        if ( trainSelectionne.destination==g2 )nom_gare_destination="gare2";
        else if ( trainSelectionne.destination==g1 )nom_gare_destination="gare1";
        else if ( trainSelectionne.destination==g3 )nom_gare_destination="gare3";
        else if ( trainSelectionne.destination==g4 )nom_gare_destination="gare4";
        p.text("destination: "+nom_gare_destination, gare2AnchorX+5, gare2AnchorY+30);
        
        
        
        
        String nom_gare_depart="gare2";
        if ( trainSelectionne.depart==g2 )nom_gare_depart="gare2";
        else if ( trainSelectionne.depart==g1 )nom_gare_depart="gare1";
        else if ( trainSelectionne.depart==g3 )nom_gare_depart="gare3";
        else if ( trainSelectionne.depart==g4 )nom_gare_depart="gare4";
        p.text("depart de: "+nom_gare_depart, gare2AnchorX+5, gare2AnchorY+80);
        
        
        
        String en_colision="non";
        if ( trainSelectionne.retourCollision || trainSelectionne.retourCollisiong3|| trainSelectionne.retourCollisiong4 
        || trainSelectionne.retourCollisiong6  )en_colision="oui";
        else en_colision="non";
        
        p.text("en colision ? : "+en_colision, gare2AnchorX+5, gare2AnchorY+120);
        

        p.textSize(17);
        p.text("x=" + trainSelectionne.x + "  y=" + trainSelectionne.y,
          gare2AnchorX, gare2AnchorY - 20);

        p.textAlign(PConstants.LEFT, PConstants.TOP); // reset
      }
      
      
      // --- Signe visuel sur le train sélectionné (anneau + point bleu) ---
      if (trainSelectionne != null) {
        p.pushStyle();                      // évite d'impacter le reste du dessin

        float r = (pickRadius > 0 ? pickRadius : 16); 
        
        // Petit rond bleu au-dessus du train
        p.noStroke();
        p.fill(0, 140, 255);
        p.circle(trainSelectionne.x+trainSelectionne.largeur/2, trainSelectionne.y - (r + 1), 10);

        p.popStyle();
      }
    }
  }
}

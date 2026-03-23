class Feu {
  int x, y;
  boolean estVert = true; // par défaut rouge

  Feu(int x, int y) {
    this.x = x;
    this.y = y;
  }

  void afficher() {
    if (estVert) {
      fill(0, 255, 0); // vert
    } else {
      fill(255, 0, 0); // rouge
    }
    ellipse(x, y-22, 15, 15);

    stroke(255); // ligne toujours blanche
    strokeWeight(1);
    line(x, y, x, y - 14);
  }

  void mettreVert() {
    estVert = true;
  }

  void mettreRouge() {
    estVert = false;
  }

  void mettreAJourSelonGare(Gare g) {

    if (g.train_en_gare.size()>=4) {
      mettreRouge(); // ❌ gare pleine
    } else {
      mettreVert(); // ✅ au moins une place libre
    }
  }


  void mettreAJourSelonGares(GareSecondaire g) {
    if (g.train_en_gare.size()>=2) {
      mettreRouge(); // ❌ gare pleine
    } else {
      mettreVert(); // ✅ au moins une place libre
    }
  }
}

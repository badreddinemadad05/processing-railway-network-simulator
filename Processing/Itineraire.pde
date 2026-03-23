class Itineraire {
    Gare depart;
    Gare destination;

    Itineraire(Gare depart, Gare destination) {
        this.depart = depart;
        this.destination = destination;
    }
}

ArrayList<Itineraire> trajetsActifs = new ArrayList<>();

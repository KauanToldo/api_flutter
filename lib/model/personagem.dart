class Personagem {
  int id;
  String name;
  String status;
  String species;
  String type;
  String gender;
  //origin
  //location
  String image;
  List episodes;
  String url;
  String created;

  Personagem(
      {required this.id,
      required this.name,
      required this.status,
      required this.species,
      required this.type,
      required this.gender,
      required this.image,
      required this.episodes,
      required this.url,
      required this.created});
}

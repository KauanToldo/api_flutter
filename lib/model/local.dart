class Local {
  final int id;
  final String name;
  final String type;
  final String dimension;
  final List
      residents; // URLs dos personagens que foram vistos pela última vez no local
  final String url;
  final String created;

  Local({
    required this.id,
    required this.name,
    required this.type,
    required this.dimension,
    required this.residents,
    required this.url,
    required this.created,
  });
}

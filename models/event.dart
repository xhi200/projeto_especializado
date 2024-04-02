class Event {
  String name;
  String date;
  String imagePath;
  String descricao;

  Event({
    required this.name,
    required this.date,
    required this.imagePath,
    required this.descricao,
  });

  String get _name => name;
  String get _date => date;
  String get _imagePath => imagePath;
  String get _descricao => descricao;
}

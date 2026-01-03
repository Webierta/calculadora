class Historial {
  final String input;
  final dynamic result;

  const Historial({required this.input, required this.result});

  Historial.fromJson(Map<String, dynamic> json)
    : input = json['i'],
      result = json['r'];

  Map<String, dynamic> toJson() {
    return {'i': input, 'r': result};
  }

  @override
  String toString() {
    return '$input = $result';
  }
}

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

  // Create a copyWith method for immutability
  Historial copyWith({String? input, dynamic result}) {
    return Historial(input: input ?? this.input, result: result ?? this.result);
  }

  @override
  String toString() {
    return '$input = $result';
  }
}

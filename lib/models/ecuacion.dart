class Ecuacion {
  final String input;
  final dynamic result;

  const Ecuacion({required this.input, required this.result});

  Ecuacion.fromJson(Map<String, dynamic> json)
    : input = json['i'],
      result = json['r'];

  Map<String, dynamic> toJson() {
    return {'i': input, 'r': result};
  }

  // Create a copyWith method for immutability
  Ecuacion copyWith({String? input, dynamic result}) {
    return Ecuacion(input: input ?? this.input, result: result ?? this.result);
  }

  @override
  String toString() {
    return '$input = $result';
  }
}

class Receita {
  final String name;
  final double amount;
  final String category;
  final DateTime date;

  Receita({
    required this.name,
    required this.amount,
    required this.category,
    required this.date,
  });

  // Função para converter a despesa em um mapa
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
    };
  }

  // Função para criar uma despesa a partir de um mapa
  factory Receita.fromMap(Map<String, dynamic> map) {
    return Receita(
      name: map['name'],
      amount: map['amount'],
      category: map['category'],
      date: DateTime.parse(map['date']),
    );
  }
}

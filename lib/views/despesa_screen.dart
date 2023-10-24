import 'package:flutter/material.dart';
import 'package:gastei/models/despesa.dart';

class DespesaScreen extends StatefulWidget {
  const DespesaScreen({super.key});

  @override
  _DespesaScreenState createState() => _DespesaScreenState();
}

class _DespesaScreenState extends State<DespesaScreen> {
  final List<Despesa> despesas = [];
  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  void _addDespesa() {
    setState(() {
      despesas.add(Despesa(
        name: nameController.text,
        amount: double.parse(amountController.text),
        category: categoryController.text,
        date: DateTime.now(),
      ));

      // Limpar os campos de entrada após a adição da despesa
      nameController.clear();
      amountController.clear();
      categoryController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Despesas'),
      ),
      body: Column(
        children: [
          // Formulário para inserir despesas
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Nome da Despesa'),
                ),
                TextField(
                  controller: amountController,
                  decoration: InputDecoration(labelText: 'Valor'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: categoryController,
                  decoration: InputDecoration(labelText: 'Categoria'),
                ),
                ElevatedButton(
                  onPressed: _addDespesa,
                  child: Text('Inserir Despesa'),
                ),
              ],
            ),
          ),
          // Lista de despesas inseridas
          Expanded(
            child: ListView.builder(
              itemCount: despesas.length,
              itemBuilder: (ctx, index) {
                final despesa = despesas[index];
                return ListTile(
                  title: Text(despesa.name),
                  subtitle: Text('Valor: ${despesa.amount.toStringAsFixed(2)} - Categoria: ${despesa.category}'),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      // Implemente a edição da despesa
                    },
                  ),
                  onLongPress: () {
                    // Implemente a exclusão da despesa
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

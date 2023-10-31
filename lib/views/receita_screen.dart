import 'package:flutter/material.dart';
import 'package:gastei/models/receita.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ReceitasScreen extends StatefulWidget {
  const ReceitasScreen({Key? key}) : super(key: key);

  @override
  _ReceitasScreenState createState() => _ReceitasScreenState();
}

class _ReceitasScreenState extends State<ReceitasScreen> {
  final List<Receita> receitas = [];
  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  // Função para salvar as receitas no SharedPreferences
  Future<void> _saveReceitas() async {
    final prefs = await SharedPreferences.getInstance();
    final receitasList = receitas.map((receita) => receita.toMap()).toList();
    await prefs.setString('receitas', json.encode(receitasList));
  }

  // Função para carregar as receitas do SharedPreferences
  Future<void> _loadReceitas() async {
    final prefs = await SharedPreferences.getInstance();
    final receitasJson = prefs.getString('receitas');
    if (receitasJson != null) {
      final receitasList = json.decode(receitasJson) as List;
      receitasList.forEach((receitaMap) {
        final receita = Receita.fromMap(receitaMap);
        setState(() {
          receitas.add(receita);
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadReceitas();
  }

  void _addReceita() {
    if (nameController.text.isEmpty ||
        amountController.text.isEmpty ||
        categoryController.text.isEmpty) {
      return;
    }

    double amount;
    try {
      amount = double.parse(amountController.text);
    } catch (e) {
      return;
    }

    setState(() {
      receitas.add(Receita(
        name: nameController.text,
        amount: amount,
        category: categoryController.text,
        date: DateTime.now(),
      ));

      nameController.clear();
      amountController.clear();
      categoryController.clear();

      _saveReceitas();
    });
  }

  void _editReceita(int index) {
    nameController.text = receitas[index].name;
    amountController.text = receitas[index].amount.toString();
    categoryController.text = receitas[index].category;

    setState(() {
      receitas.removeAt(index);
      _saveReceitas();
    });
  }

  void _deleteReceita(int index) {
    setState(() {
      receitas.removeAt(index);
      _saveReceitas();
    });
  }

  @override
  Widget build(BuildContext context) {
    double totalAmount = receitas.fold(0, (sum, item) => sum + item.amount);

    return Scaffold(
      appBar: AppBar(
        title: Text('Receitas'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, totalAmount),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Total de Receitas: R\$${totalAmount.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Nome da Receita',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: amountController,
                  decoration: InputDecoration(
                    labelText: 'Valor',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10),
                TextField(
                  controller: categoryController,
                  decoration: InputDecoration(
                    labelText: 'Categoria',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _addReceita,
                  child: Text('Inserir Receita'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: receitas.length,
              itemBuilder: (ctx, index) {
                final receita = receitas[index];
                return ListTile(
                  title: Text(receita.name),
                  subtitle: Text('Valor: R\$${receita.amount.toStringAsFixed(2)} - Categoria: ${receita.category}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _editReceita(index),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteReceita(index),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

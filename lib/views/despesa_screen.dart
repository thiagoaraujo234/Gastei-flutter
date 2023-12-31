import 'package:flutter/material.dart';
import 'package:gastei/models/despesa.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DespesaScreen extends StatefulWidget {
  const DespesaScreen({Key? key}) : super(key: key);

  @override
  _DespesaScreenState createState() => _DespesaScreenState();
}

class _DespesaScreenState extends State<DespesaScreen> {
  final List<Despesa> despesas = [];
  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  // Função para salvar as despesas no SharedPreferences
  Future<void> _saveDespesas() async {
    final prefs = await SharedPreferences.getInstance();
    final despesasList = despesas.map((despesa) => despesa.toMap()).toList();
    await prefs.setString('despesas', json.encode(despesasList));
  }

  // Função para carregar as despesas do SharedPreferences
  Future<void> _loadDespesas() async {
    final prefs = await SharedPreferences.getInstance();
    final despesasJson = prefs.getString('despesas');
    if (despesasJson != null) {
      final despesasList = json.decode(despesasJson) as List;
      despesasList.forEach((despesaMap) {
        final despesa = Despesa.fromMap(despesaMap);
        setState(() {
          despesas.add(despesa);
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadDespesas();
  }

  void _addDespesa() {
    if (nameController.text.isEmpty ||
        amountController.text.isEmpty ||
        categoryController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Erro'),
            content: Text('Preencha todos os campos corretamente.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    double amount;
    try {
      amount = double.parse(amountController.text);
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Erro'),
            content: Text('O valor deve ser um número válido.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    setState(() {
      despesas.add(Despesa(
        name: nameController.text,
        amount: amount,
        category: categoryController.text,
        date: DateTime.now(),
      ));

      nameController.clear();
      amountController.clear();
      categoryController.clear();

      _saveDespesas();
    });
  }

  void _editDespesa(int index) {
    nameController.text = despesas[index].name;
    amountController.text = despesas[index].amount.toString();
    categoryController.text = despesas[index].category;

    setState(() {
      despesas.removeAt(index);
      _saveDespesas();
    });
  }

  void _deleteDespesa(int index) {
    setState(() {
      despesas.removeAt(index);
      _saveDespesas();
    });
  }

  @override
  Widget build(BuildContext context) {
    double totalAmount = despesas.fold(0, (sum, item) => sum + item.amount);

    return Scaffold(
      appBar: AppBar(
        title: Text('Despesas'),
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
              'Total de Despesas: R\$${totalAmount.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Nome da Despesa',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    prefixIcon: Icon(Icons.note),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: amountController,
                  decoration: InputDecoration(
                    labelText: 'Valor',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: categoryController,
                  decoration: InputDecoration(
                    labelText: 'Categoria',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    prefixIcon: Icon(Icons.category),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _addDespesa,
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    child: Text(
                      'Inserir Despesa',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Card(
              elevation: 8, // Adicionei uma sombra ao redor da lista de itens
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0), // Bordas arredondadas
              ),
              margin: EdgeInsets.all(16),
              child: ListView.builder(
                itemCount: despesas.length,
                itemBuilder: (ctx, index) {
                  final despesa = despesas[index];
                  return ListTile(
                    title: Text(despesa.name),
                    subtitle: Text('Valor: R\$${despesa.amount.toStringAsFixed(2)} - Categoria: ${despesa.category}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _editDespesa(index),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteDespesa(index),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

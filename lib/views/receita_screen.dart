import 'package:flutter/material.dart';
import 'package:gastei/models/receita.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

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
  DateTime? selectedDate;

  // Lista de sugestões para o campo de categorias
  final List<String> categorySuggestions = [];

  // Formatador de data
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    _loadReceitas();
    _loadCategorySuggestions();
  }

  Future<void> _loadCategorySuggestions() async {
    final prefs = await SharedPreferences.getInstance();
    final categories = prefs.getStringList('categories');
    if (categories != null) {
      setState(() {
        categorySuggestions.addAll(categories);
      });
    }

    // Sugestões de exemplo
    categorySuggestions.addAll(['Exemplo 1', 'Exemplo 2']);
  }

  Future<void> _saveReceitas() async {
    final prefs = await SharedPreferences.getInstance();
    final receitasList = receitas.map((receita) => receita.toMap()).toList();
    await prefs.setString('receitas', json.encode(receitasList));
  }

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

  void _addReceita() {
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
      receitas.add(Receita(
        name: nameController.text,
        amount: amount,
        category: categoryController.text,
        date: selectedDate ?? DateTime.now(),
      ));

      nameController.clear();
      amountController.clear();
      categoryController.clear();
      selectedDate = null;

      _saveReceitas();
    });
  }

  void _editReceita(int index) {
    nameController.text = receitas[index].name;
    amountController.text = receitas[index].amount.toString();
    categoryController.text = receitas[index].category;
    selectedDate = receitas[index].date;

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

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
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
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Nome da Receita',
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
                TypeAheadField<String>(
                  textFieldConfiguration: TextFieldConfiguration(
                    controller: categoryController,
                    decoration: InputDecoration(
                      labelText: 'Categoria',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      prefixIcon: Icon(Icons.category),
                    ),
                  ),
                  suggestionsCallback: (pattern) {
                    return categorySuggestions.where((category) => category.toLowerCase().contains(pattern.toLowerCase()));
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(suggestion),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    categoryController.text = suggestion;
                  },
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue, // Alterei a cor para azul
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 10),
                        Text(
                          'Data ',
                          style: TextStyle(color: Colors.white), // Alterei a cor do texto para branco
                        ),
                        Icon(Icons.calendar_today, color: Colors.white), // Alterei a cor do ícone para branco
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                if (selectedDate != null)
                  Text(
                    'Data selecionada: ${dateFormat.format(selectedDate!)}',
                  ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _addReceita,
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
                      'Inserir Receita',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              margin: EdgeInsets.all(16),
              child: ListView.builder(
                itemCount: receitas.length,
                itemBuilder: (ctx, index) {
                  final receita = receitas[index];
                  return ListTile(
                    title: Text(receita.name),
                    subtitle: Text('Valor: R\$${receita.amount.toStringAsFixed(2)} - Categoria: ${receita.category} - Data: ${dateFormat.format(receita.date)}'),
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
          ),
        ],
      ),
    );
  }
}

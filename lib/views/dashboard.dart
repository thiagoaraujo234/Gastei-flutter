import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class DashboardScreen extends StatelessWidget {
  final double totalDespesas;
  final double totalReceitas;

  DashboardScreen({required this.totalDespesas, required this.totalReceitas});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildTotalCard('Total de Receitas', totalReceitas),
              _buildTotalCard('Total de Despesas', totalDespesas),
              SizedBox(height: 16),
              _buildChartCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTotalCard(String title, double amount) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'R\$ ${amount.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text(
                'Legenda do Gráfico:',
                style: TextStyle(fontSize: 18),
              ),
              Text('Receitas', style: TextStyle(color: const Color(0xff0293ee))),
              Text('Despesas', style: TextStyle(color: const Color(0xfff8b250)),
              )
                ],

              ),
            ),
            Expanded(
              flex: 3,
              child: AspectRatio(
                aspectRatio: 1.3,
                child: charts.PieChart(
                  _createPieData(),
                  animate: true,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: AspectRatio(
                aspectRatio: 2.0,
                child: charts.BarChart(
                  _createBarData(),
                  animate: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<charts.Series<Expense, String>> _createBarData() {
    final data = [
      Expense('Receitas', totalReceitas),
      Expense('Despesas', totalDespesas),
    ];

    return [
      charts.Series<Expense, String>(
        id: 'Expense',
        domainFn: (Expense expense, _) => expense.category,
        measureFn: (Expense expense, _) => expense.amount,
        data: data,
        colorFn: (Expense expense, _) {
          if (expense.category == 'Despesas') {
            return charts.MaterialPalette.deepOrange.shadeDefault;
          } else {
            return charts.MaterialPalette.blue.shadeDefault;
          }
        },
        labelAccessorFn: (Expense expense, _) =>
        '${expense.category}: R\$${expense.amount.toStringAsFixed(2)}',
      ),
    ];
  }

  List<charts.Series<Expense, String>> _createPieData() {
    final data = [
      Expense('Receitas', totalReceitas),
      Expense('Despesas', totalDespesas),
    ];

    return [
      charts.Series<Expense, String>(
        id: 'Expense',
        domainFn: (Expense expense, _) => expense.category,
        measureFn: (Expense expense, _) => expense.amount,
        data: data,
        colorFn: (Expense expense, _) {
          if (expense.category == 'Despesas') {
            return charts.MaterialPalette.deepOrange.shadeDefault;
          } else {
            return charts.MaterialPalette.blue.shadeDefault;
          }
        },
        labelAccessorFn: (Expense expense, _) =>
        '${expense.category}: R\$${expense.amount.toStringAsFixed(2)}',
      ),
    ];
  }
}

class Expense {
  final String category;
  final double amount;

  Expense(this.category, this.amount);
}

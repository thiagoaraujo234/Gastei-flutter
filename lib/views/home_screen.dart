import 'package:flutter/material.dart';
import 'package:gastei/views/dashboard.dart';
import 'package:gastei/views/despesa_screen.dart';
import 'package:gastei/views/receita_screen.dart';
import 'package:gastei/views/login.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double totalDespesas = 0.0;
  double totalReceitas = 0.0;
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    double saldo = totalReceitas - totalDespesas;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  color: Colors.white, // Cor branca para o saldo atual
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: Container(
                    width: 300,
                    height: 100, // Diminuir o tamanho pela metade
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Saldo', style: TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold)), // Tamanho da fonte aumentado
                          Text('R\$ ${saldo.toStringAsFixed(2)}', style: TextStyle(fontSize: 30, color: Colors.black, fontWeight: FontWeight.bold)), // Tamanho da fonte aumentado
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                InkWell(
                  onTap: () async {
                    final result = await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return ReceitasScreen();
                      },
                    ));
                    if (result != null) {
                      setState(() {
                        totalReceitas = result;
                      });
                    }
                  },
                  child: Card(
                    color: Colors.grey[800], // Cor cinza escuro para Receita
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: Container(
                      width: 700,
                      height: 200,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('Receita', style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)), // Tamanho da fonte aumentado
                            Text('Total R\$ ${totalReceitas.toStringAsFixed(2)}', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)), // Tamanho da fonte aumentado
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                InkWell(
                  onTap: () async {
                    final result = await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return DespesaScreen();
                      },
                    ));
                    if (result != null) {
                      setState(() {
                        totalDespesas = result;
                      });
                    }
                  },
                  child: Card(
                    color: Colors.grey[900], // Cor cinza escuro para Despesas
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: Container(
                      width: 700,
                      height: 200,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('Despesas', style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)), // Tamanho da fonte aumentado
                            Text('Total R\$ ${totalDespesas.toStringAsFixed(2)}', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)), // Tamanho da fonte aumentado
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.login),
            label: 'Login',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: (index) {
          if (index == 0) {
            // Navegue para a tela de Dashboard
          } else if (index == 1) {
            // Navegue para a tela de Login
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                return DashboardScreen(totalDespesas: totalDespesas, totalReceitas: totalReceitas);
              },
            ));
          }
          else if (index == 2) {
            // Navegue para a tela de Login
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                return LoginPage();
              },
            ));
          }
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gastei/views/despesa_screen.dart';
import 'package:gastei/views/receita_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double totalDespesas = 0.0;
  double totalReceitas = 0.0;

  @override
  Widget build(BuildContext context) {
    double saldo = totalReceitas - totalDespesas;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Home Screen'),
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
                Text('Saldo Atual R\$ ${saldo.toStringAsFixed(2)}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
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
                    color: Colors.white.withOpacity(0.5),
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
                            Text('Receita', style: TextStyle(fontSize: 20)),
                            Text('Total R\$ ${totalReceitas.toStringAsFixed(2)}', style: TextStyle(fontSize: 16)),
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
                    color: Colors.white.withOpacity(0.5),
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
                            Text('Despesas', style: TextStyle(fontSize: 20)),
                            Text('Total R\$ ${totalDespesas.toStringAsFixed(2)}', style: TextStyle(fontSize: 16)),
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
    );
  }
}

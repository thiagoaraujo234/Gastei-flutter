import 'package:flutter/material.dart';
import 'package:gastei/views/despesa_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Rounded border cards
                  InkWell(
                    onTap: () {
                      // Implementar ação quando o Card 1 for clicado
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      child: Container(
                        width: 700, // Largura
                        height: 200, // Comprimento
                        child: Center(
                          child: Text('Card 1', style: TextStyle(fontSize: 20)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16), // Espaço entre os cards
                  InkWell(
                    onTap: () {
                      // Navegar para a tela de despesas quando o Card 2 for clicado
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                        return DespesaScreen();
                      }));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      child: Container(
                        width: 700, // Largura
                        height: 200, // Comprimento
                        child: Center(
                          child: Text('Despesas', style: TextStyle(fontSize: 20)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

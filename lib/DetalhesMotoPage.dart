import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class DetalhesMotoPage extends StatelessWidget {
  final dynamic moto;
  final bool loggedIn;

  DetalhesMotoPage({required this.moto, required this.loggedIn});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes da Moto'),
        leading: IconButton(
          icon: Icon(LineIcons.arrowLeft),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Nome: ${moto['nome']}'),
            Text('Marca: ${moto['marca']}'),
            Text('Cilindradas: ${moto['cilindradas']}'),
            Text('Valor: ${moto['valor']}'),
            SizedBox(height: 20.0),
            if (loggedIn)
              TextFormField(
                decoration: InputDecoration(labelText: 'Deixe um comentário'),
              ),
            if (loggedIn)
              ElevatedButton(
                onPressed: () {
                  // Lógica para enviar comentário
                },
                child: Text('Enviar Comentário'),
              ),
          ],
        ),
      ),
    );
  }
}

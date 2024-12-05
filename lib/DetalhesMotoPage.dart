import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetalhesMotoPage extends StatefulWidget {
  final dynamic moto;
  final bool loggedIn;

  DetalhesMotoPage({required this.moto, required this.loggedIn});

  @override
  _DetalhesMotoPageState createState() => _DetalhesMotoPageState();
}

class _DetalhesMotoPageState extends State<DetalhesMotoPage> {
  List<String> comentarios = [];
  final TextEditingController _comentarioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregarComentarios();
  }

  
  Future<void> _carregarComentarios() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      comentarios = prefs.getStringList('comentarios_${widget.moto['nome']}') ?? [];
    });
  }

  
  Future<void> _salvarComentario(String comentario) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      comentarios.add(comentario);
    });
    await prefs.setStringList('comentarios_${widget.moto['nome']}', comentarios);
    _comentarioController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Comentário salvo com sucesso!')),
    );
  }

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
            Text('Nome: ${widget.moto['nome']}'),
            Text('Marca: ${widget.moto['marca']}'),
            Text('Cilindradas: ${widget.moto['cilindradas']}'),
            Text('Valor: ${widget.moto['valor']}'),
            SizedBox(height: 20.0),
            if (widget.loggedIn)
              TextFormField(
                controller: _comentarioController,
                decoration: InputDecoration(labelText: 'Deixe um comentário'),
              ),
            if (widget.loggedIn)
              ElevatedButton(
                onPressed: () {
                  String comentario = _comentarioController.text.trim();
                  if (comentario.isNotEmpty) {
                    _salvarComentario(comentario);
                  }
                },
                child: Text('Enviar Comentário'),
              ),
            SizedBox(height: 20.0),
            Divider(),
            Text('Comentários:', style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: comentarios.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(comentarios[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

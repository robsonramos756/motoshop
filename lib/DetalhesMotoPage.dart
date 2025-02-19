import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DetalhesMotoPage extends StatefulWidget {
  final Map<String, dynamic> moto;
  final bool loggedIn;

  DetalhesMotoPage({required this.moto, required this.loggedIn});

  @override
  _DetalhesMotoPageState createState() => _DetalhesMotoPageState();
}

class _DetalhesMotoPageState extends State<DetalhesMotoPage> {
  List<dynamic> comentarios = [];
  final TextEditingController _comentarioController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchComentarios();
  }

  Future<void> _fetchComentarios() async {
    setState(() => isLoading = true);

    final response = await http.get(
      Uri.parse('http://192.168.1.145:8000/motos/${widget.moto['id']}/comentarios'),
    );

    if (response.statusCode == 200) {
      setState(() {
        comentarios = json.decode(utf8.decode(response.bodyBytes));
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  Future<void> _enviarComentario() async {
    if (_comentarioController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, escreva um comentário!')),
      );
      return;
    }

    final response = await http.post(
      Uri.parse('http://192.168.1.145:8000/comentarios'),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
      },
      body: json.encode({
        'moto_id': widget.moto['id'],
        'usuario': 'Usuário Logado',
        'comentario': _comentarioController.text,
      }),
    );

    if (response.statusCode == 200) {
      _comentarioController.clear();
      _fetchComentarios();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Comentário enviado com sucesso!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao enviar comentário!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes da Moto', style: TextStyle(fontFamily: 'Roboto')),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            
              Center(
                child: Text(
                  widget.moto['nome'],
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
              SizedBox(height: 8),

             
              Center(
                child: Image.network(
                  widget.moto['imagem'],
                  height: 280,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16),

              
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Marca: ${widget.moto['marca']}',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, fontFamily: 'Roboto'),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Cilindradas: ${widget.moto['cilindradas']}',
                        style: TextStyle(fontSize: 18, fontFamily: 'Roboto'),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Valor: ${widget.moto['valor']}',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),

              Text(
                'Comentários',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                ),
              ),
              SizedBox(height: 8),

              Container(
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : comentarios.isEmpty
                        ? Center(
                            child: Text(
                              'Nenhum comentário ainda.',
                              style: TextStyle(fontSize: 16, fontFamily: 'Roboto', color: Colors.grey[700]),
                            ),
                          )
                        : ListView.builder(
                            itemCount: comentarios.length,
                            itemBuilder: (context, index) {
                              final comentario = comentarios[index];
                              return Card(
                                margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                child: ListTile(
                                  title: Text(
                                    comentario['usuario'] ?? 'Anônimo',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                  subtitle: Text(
                                    comentario['comentario'] ?? '',
                                    style: TextStyle(fontFamily: 'Roboto'),
                                  ),
                                ),
                              );
                            },
                          ),
              ),
              SizedBox(height: 20),

              
              if (widget.loggedIn) ...[
                TextField(
                  controller: _comentarioController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Digite seu comentário',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  style: TextStyle(fontFamily: 'Roboto'),
                ),
                SizedBox(height: 12),
                Center(
                  child: ElevatedButton(
                    onPressed: _enviarComentario,
                    child: Text('Enviar Comentário', style: TextStyle(fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                  ),
                ),
              ] else ...[
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Icon(Icons.lock_outline, size: 50, color: Colors.redAccent),
                        SizedBox(height: 10),
                        Text(
                          '⚠️ Faça login para comentar!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

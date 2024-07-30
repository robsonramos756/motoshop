import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_icons/line_icons.dart';
import 'DetalhesMotoPage.dart';
import 'google_sign_in.dart';

class FeedPage extends StatefulWidget {
  final bool loggedIn;

  FeedPage({required this.loggedIn});

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final ScrollController _scrollController = ScrollController();
  List<dynamic> motos = [];
  int page = 0;
  bool isLoading = false;
  bool allLoaded = false;
  bool showToTopButton = false;

  @override
  void initState() {
    super.initState();
    _loadMoreMotos();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent &&
          !isLoading && !allLoaded) {
        _loadMoreMotos();
      }

      setState(() {
        showToTopButton = _scrollController.offset >= 200;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMoreMotos() async {
    setState(() {
      isLoading = true;
    });

    try {
      String jsonString = await rootBundle.loadString('assets/json/motos.json');
      List<dynamic> allMotos = json.decode(jsonString);

      await Future.delayed(Duration(seconds: 2));
      setState(() {
        int itemsToLoad = 3;
        int startIndex = page * itemsToLoad;
        int endIndex = startIndex + itemsToLoad;
        if (startIndex < allMotos.length) {
          if (endIndex > allMotos.length) {
            endIndex = allMotos.length;
            allLoaded = true;
          }
          motos.addAll(allMotos.sublist(startIndex, endIndex));
          page++;
        } else {
          allLoaded = true;
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0.0,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _logout() async {
    await GoogleSignInService().signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modelos de motos disponíveis'),
        leading: SizedBox.shrink(),
        actions: [
          if (widget.loggedIn)
            IconButton(
              icon: Icon(LineIcons.alternateSignOut, size: 24),
              onPressed: _logout,
              tooltip: 'Sair',
            ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          ListView.builder(
            controller: _scrollController,
            itemCount: motos.length + (isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == motos.length) {
                return _buildProgressIndicator();
              } else {
                String imagePath = 'assets/imagens/';
                switch (index % 14) {
                  case 0:
                    imagePath += 'BMWF750.jpeg';
                    break;
                  case 1:
                    imagePath += 'BMWF850GS.jpeg';
                    break;
                  case 2:
                    imagePath += 'BWMS1000.jpeg';
                    break;
                  case 3:
                    imagePath += 'HondaCB1000R.jpeg';
                    break;
                  case 4:
                    imagePath += 'HondaCBR1000RRR.jpeg';
                    break;
                  case 5:
                    imagePath += 'KawasakiVersys1000.jpeg';
                    break;
                  case 6:
                    imagePath += 'Kawasakiz900.jpeg';
                    break;
                  case 7:
                    imagePath += 'KawasakiZ1000.jpeg';
                    break;
                  case 8:
                    imagePath += 'SuzukiGXSS1000.jpeg';
                    break;
                  case 9:
                    imagePath += 'SuzukiVStrom1050.jpeg';
                    break;
                  case 10:
                    imagePath += 'Tracer900.jpeg';
                    break;
                  case 11:
                    imagePath += 'Triumph900.jpeg';
                    break;
                  case 12:
                    imagePath += 'TriumphStreet.jpeg';
                    break;
                  case 13:
                    imagePath += 'YamahaMT09.jpeg';
                    break;
                  default:
                    imagePath += 'placeholder.jpeg';
                    break;
                }

                return GestureDetector(
                  onTap: () async {
                    String jsonString = await rootBundle.loadString('assets/json/motos.json');
                    List<dynamic> motosJson = json.decode(jsonString);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetalhesMotoPage(moto: motosJson[index], loggedIn: widget.loggedIn),
                      ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Image.asset(
                      imagePath,
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }
            },
          ),
          if (showToTopButton)
            Positioned(
              bottom: 16,
              right: 16,
              child: FloatingActionButton(
                onPressed: _scrollToTop,
                child: Icon(LineIcons.arrowUp, size: 24),
                tooltip: 'Voltar ao topo',
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircularProgressIndicator(),
      ),
    );
  }
}

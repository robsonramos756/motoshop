import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:http/http.dart' as http;
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
  int currentIndex = 0;
  bool isLoading = false;
  bool allLoaded = false;
  bool showToTopButton = false;
  static const int itemsPerLoad = 3;

  @override
  void initState() {
    super.initState();
    _fetchMotos();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent &&
        !isLoading && !allLoaded) {
      _loadMore();
    }

    setState(() {
      showToTopButton = _scrollController.offset >= 300;
    });
  }

  Future<void> _fetchMotos() async {
    setState(() => isLoading = true);

    final response = await http.get(Uri.parse('http://192.168.1.145:8000/motos'));

    if (response.statusCode == 200) {
      List<dynamic> fetchedMotos = json.decode(response.body);
      setState(() {
        motos = fetchedMotos;
        currentIndex = (motos.length >= itemsPerLoad) ? itemsPerLoad : motos.length;
        allLoaded = motos.length <= itemsPerLoad;
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  void _loadMore() async {
    if (currentIndex >= motos.length) {
      setState(() => allLoaded = true);
      return;
    }

    setState(() => isLoading = true);

    await Future.delayed(Duration(seconds: 1)); 

    setState(() {
      int nextIndex = currentIndex + itemsPerLoad;
      currentIndex = (nextIndex > motos.length) ? motos.length : nextIndex;
      allLoaded = currentIndex >= motos.length;
      isLoading = false;
    });
  }

  void _logout() async {
    await GoogleSignInService().signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0.0,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modelos disponíveis'),
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
        children: [
          ListView.builder(
            controller: _scrollController,
            itemCount: currentIndex + (isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == currentIndex) {
                return _buildProgressIndicator();
              } else {
                final moto = motos[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetalhesMotoPage(moto: moto, loggedIn: widget.loggedIn),
                      ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Image.network(
                      moto['imagem'],
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
    return allLoaded
        ? SizedBox.shrink() 
        : Center(child: CircularProgressIndicator());
  }
}

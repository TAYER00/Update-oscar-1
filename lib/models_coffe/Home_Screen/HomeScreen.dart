import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Coffe_item.dart';
import '../menu_coffe.dart';
import '../panier_coffe/Panier.dart';
import '../panier_coffe/paniercoffescreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose(); // Nettoyez le ScrollController lorsque le widget est détruit
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF212325),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.menu),
                          onPressed: () => ZoomDrawer.of(context)!.toggle(),
                          color: Colors.white.withOpacity(0.5),
                          iconSize: 35,
                        ),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PanierCoffeScreen(),
                              ),
                            );
                          },
                          child: Icon(
                            Icons.shopping_cart,
                            color: Colors.white.withOpacity(0.5),
                            size: 35,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                  Center(
                    child: Text(
                      "Start Ur Day With Coffee",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: Colors.orange,
                          fontSize: 32, // Taille de police de grand titre
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic, // Italique
                         // decoration: TextDecoration.underline, // Souligné
                          letterSpacing: 1.5, // Espacement des lettres
                        ),
                      ),
                    ),
                  ),
                    SizedBox(height: 20),
                    ItemsWidget(coffees: coffees), // Assurez-vous que cette ligne est correcte pour afficher vos éléments
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Container(
              width: 200, // Ajustez la largeur selon vos besoins
              child: FloatingActionButton(
                onPressed: () {
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                },
                child: Center(
                  child: Text(
                    'scroll right', // Texte plus court pour éviter les débordements
                    style: TextStyle(
                      color: Colors.white, // Couleur du texte
                      fontSize: 12, // Réduit la taille de la police
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center, // Centre le texte
                  ),
                ),
                backgroundColor: Colors.orange,
              ),
            ),
          )

        ],
      ),
    );
  }
}

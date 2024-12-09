import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';


// ga3ma 7tajitha 




class MyBottomNavBar extends StatelessWidget {
  final void Function(int)? onTabChange;

  // Constructeur
  MyBottomNavBar({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: GNav(
        backgroundColor: Color(0xFFFF5500), // Fond du navbar
        color: Colors.grey[400], // Couleur des icônes non sélectionnées
        activeColor: Colors.white, // Couleur des icônes sélectionnées
        tabBackgroundColor: const Color.fromARGB(
            255, 255, 255, 255), // Couleur de fond de l'onglet sélectionné
        tabActiveBorder:
            Border.all(color: Colors.white), // Bordure de l'onglet sélectionné
        mainAxisAlignment: MainAxisAlignment.center,
        tabBorderRadius: 16, // Bord arrondi pour les onglets
        onTabChange: (value) =>
            onTabChange!(value), // Action lors du changement de tab
        tabs: const [
          GButton(
            icon: Icons.local_pizza,
            text: 'Sandwish',
            iconColor: Colors.black, // Couleur de l'icône pour cet onglet
            textColor: Colors.orange, // Couleur du texte pour cet onglet
            textStyle: TextStyle(
              color: Colors.orange,
              fontSize: 18, // Taille du texte
              fontWeight: FontWeight.w600, // Poids du texte (facultatif)
            ),
          ), // GButton 1
          // GButton 2
          GButton(
            icon: Icons.local_drink,
            text: 'JUS',
            iconColor: Colors.black, // Couleur de l'icône pour cet onglet
            textColor: Colors.orange, // Couleur du texte pour cet onglet
            textStyle: TextStyle(
              color: Colors.orange,
              fontSize: 18, // Taille du texte
              fontWeight: FontWeight.w600, // Poids du texte (facultatif)
            ),
          ),

          GButton(
            icon: Icons.tab,
            text: 'total',
            iconColor: Colors.black, // Couleur de l'icône pour cet onglet
            textColor: Colors.orange, // Couleur du texte pour cet onglet
            textStyle: TextStyle(
              color: Colors.orange,
              fontSize: 18, // Taille du texte
              fontWeight: FontWeight.w600, // Poids du texte (facultatif)
            ),
          ),
        ], // tabs
      ), // GNav
    ); // Container
  }
}

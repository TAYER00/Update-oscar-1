import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Importer le package google_fonts

class SearchBarCustom extends StatefulWidget {
  const SearchBarCustom({super.key});

  @override
  _SearchBarCustomState createState() => _SearchBarCustomState();
}

class _SearchBarCustomState extends State<SearchBarCustom> {
  // Contrôleur pour gérer le texte dans le TextField
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Ajouter un listener au TextEditingController pour suivre les changements
    _controller.addListener(() {
      setState(() {}); // Rafraîchir l'interface chaque fois que le texte change
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Libérer les ressources quand le widget est supprimé
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 350,
      child: TextField(
        controller: _controller, // Lier le contrôleur au TextField
        style: GoogleFonts.poppins(
          color: const Color(0xff020202),
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Color.fromARGB(255, 255, 255, 255), // Couleur de fond douce
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25), // Bord arrondi
            borderSide: BorderSide.none, // Suppression de la bordure extérieure
          ),
          hintText: "Search for items", // Texte de l'indication
          hintStyle: GoogleFonts.poppins(
            color: const Color(0xFFFF5500), // Couleur de l'indication
            fontSize: 16,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.5,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: Color(0xFFFF5500), // Icône de recherche
          ),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.clear,
                    color: Colors.black, // Icône de suppression (clear)
                  ),
                  onPressed: () {
                    // Effacer le texte du TextField
                    _controller.clear();
                  },
                )
              : null, // Ne pas afficher l'icône clear si le champ est vide
          contentPadding: const EdgeInsets.symmetric(horizontal: 20), // Espacement interne
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: Colors.blue, width: 2), // Bordure bleue au focus
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: Colors.transparent), // Bordure transparente quand non focus
          ),
        ),
      ),
    );
  }
}

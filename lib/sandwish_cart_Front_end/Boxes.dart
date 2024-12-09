import 'package:app_ecomerce/models/sandwich/Sandwich.dart';
import 'package:flutter/material.dart';
import 'package:app_ecomerce/models/sandwich/Cart_Sandwish.dart';
import 'package:provider/provider.dart';

class BoxTile extends StatelessWidget {
  final Sandwich sandwich; // Sandwich data passed into the widget
  final void Function()?
      addSandwichToCart; // Function to add the sandwich to the cart

  BoxTile({super.key, required this.sandwich, required this.addSandwichToCart});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 15),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            // Détecte le tap sur l'image
            onTap: () {
              // Lorsque l'utilisateur clique sur l'image, afficher l'image dans un Dialog
              _showImageDialog(context);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Image.asset(
                sandwich.imagePath, // Utilise le chemin d'image du sandwich
                fit: BoxFit.cover,
                width: double.infinity,
                height: 180,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sandwich.name, // Affiche le nom du sandwich
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  sandwich.description, // Affiche la description du sandwich
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  sandwich.price, // Affiche le prix du sandwich
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                ElevatedButton(
                  onPressed:
                      addSandwichToCart, // Appelle la fonction pour ajouter au panier
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    '+',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Fonction pour afficher l'AlertDialog avec l'image
  void _showImageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          contentPadding: EdgeInsets.zero, // Enlève les padding par défaut
          content: Center(
            // Centrer l'image dans le Dialog
            child: Image.asset(
              sandwich
                  .imagePath, // Utilise le même chemin d'image pour l'agrandir
              fit: BoxFit.contain, // L'image s'adapte à la taille du Dialog
              width: MediaQuery.of(context).size.width *
                  0.8, // Limite la largeur de l'image
              height: MediaQuery.of(context).size.height *
                  0.6, // Limite la hauteur de l'image
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Ferme le Dialog
              },
              child: Text("Fermer", style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }
}

import 'package:app_ecomerce/Jus_cart_Front_end/Cart_Item_Juice.dart';
import 'package:app_ecomerce/Les_commandes/Cart_Items.dart';
import 'package:app_ecomerce/Les_commandes/Items.dart';
import 'package:app_ecomerce/models/jus/Jus.dart';
import 'package:app_ecomerce/showdialogue/Emport%C3%A9/Emport%C3%A9%20Form.dart';
import 'package:app_ecomerce/showdialogue/Sur_place_form.dart';
import 'package:app_ecomerce/models/sandwich/Sandwich.dart';
import 'package:app_ecomerce/sandwish_cart_Front_end/Cart_Item_Sandwish.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Cart_Page_Total extends StatelessWidget {
  const Cart_Page_Total({super.key});

  // Fonction pour afficher le dialog en fonction de itemCount
  void _showDialog(BuildContext context, int itemCount) {
    if (itemCount == 0) {
      // Afficher le message "Veuillez choisir"
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Panier vide'),
            content: const Text(
                'Veuillez choisir des articles à ajouter au panier.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Ferme le dialog
                },
                child: const Text('Fermer'),
              ),
            ],
          );
        },
      );
    } else {
      // Afficher le message "Validé" avec les options "Sur place" et "Emporté"
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Panier validé'),
            content: const Text(
                'Votre commande est prête. Où souhaitez-vous la récupérer ?'),
            actions: [
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceEvenly, // Espacement uniforme
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        // Utilisation de addPostFrameCallback pour garantir que
                        //le showDialog s'affiche après le rendu du widget
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          showNameDialog(context);
                        });

                        Navigator.of(context).pop(); // Fermer le dialog
                        print("Sur_place");
                      },
                      style: TextButton.styleFrom(
                        backgroundColor:
                            Colors.blue, // Couleur de fond du bouton
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10), // BorderRadius pour arrondir les coins
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      ),
                      child: const Text(
                        'Sur place',
                        style: TextStyle(
                          color: Colors.white, // Couleur du texte
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        // Afficher le formulaire de localisation avec LocationFormDialog
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          showLocationFormDialog(context);

                          Navigator.of(context).pop();
                        });

                        print("Commande emporté");
                      },
                      child: const Text(
                        'Emporté',
                        style: TextStyle(
                          color: Color.fromARGB(255, 185, 76, 76),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CombinedCart>(
      builder: (context, combinedCart, child) => Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, Color(0xFFFF5500)], // Décoration de fond
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  'My Cart total',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.white),
                ),
                const SizedBox(height: 10),

                Expanded(
                  child: ListView.builder(
                    itemCount: combinedCart
                        .items.length, // Nombre d'articles dans le panier
                    itemBuilder: (context, index) {
                      CartItem cartItem = combinedCart.items[index];

                      // Si c'est un sandwich
                      if (cartItem.itemType == 'sandwich') {
                        Sandwich sandwich =
                            cartItem.item; // Récupérer l'objet Sandwich

                        return Cart_Item_Sandwish(sandwich: sandwich);
                      }
                      // Si c'est un jus
                      else {
                        Juice juice = cartItem.item; // Récupérer l'objet Juice

                        return Cart_Item_Juice(juice: juice);
                      }
                    },
                  ),
                ),

                // Ajouter le bouton ici
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0,
                      horizontal: 30.0), // Padding externe autour du bouton

                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange, // Couleur du bouton
                      padding: EdgeInsets.symmetric(
                          vertical: 18.0,
                          horizontal:
                              40.0), // Padding interne pour rendre le bouton plus grand
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            12), // Arrondir les coins du bouton
                      ),
                      elevation:
                          5, // Ajout d'une ombre légère pour l'effet de profondeur
                    ),
                    onPressed: () {
                      // Appeler la fonction _showDialog
                      _showDialog(context, combinedCart.items.length);
                    },
                    child: const Text(
                      'Checkout',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

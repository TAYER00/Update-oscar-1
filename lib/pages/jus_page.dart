import 'package:app_ecomerce/Components/search_bar.dart';
import 'package:app_ecomerce/Jus_cart_Front_end/Boxe.dart';
import 'package:app_ecomerce/Les_commandes/Cart_Items.dart';
import 'package:app_ecomerce/models/jus/Cart_jus.dart';
import 'package:app_ecomerce/models/jus/Jus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Jus_Page extends StatefulWidget {
  const Jus_Page({super.key});

  @override
  State<Jus_Page> createState() => _Jus_PageState();
}

class _Jus_PageState extends State<Jus_Page> {
  final Cart_Juice jus = Cart_Juice();

  // affichage dans la console log la list des commande ( sandwish / jus )

  void _logCartItems(BuildContext context) {
    final cart = Provider.of<CombinedCart>(context, listen: false);
    print('Contenu du Panier :');
    cart.items.forEach((item) {
      print(
          'Item: ${item.name}, Type: ${item.itemType}, Price: \$${item.price}');
    });
  }

  void addJuiceToCart(Juice juice) {
    // Ajouter le sandwich au panier
    Provider.of<Cart_Juice>(context, listen: false).addItemToCart(juice);
    // l'ajout dans la cart_page_total
    Provider.of<CombinedCart>(context, listen: false).addJuice(juice);
    // Appel pour afficher les éléments du panier dans la console après l'ajout
    _logCartItems(context);

    // Afficher une fenêtre de confirmation
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // Bordures arrondies
          ),
          backgroundColor: Colors.black, // Fond orange de la boîte de dialogue
          title: Text(
            'Added to Cart',
            style: TextStyle(
              fontSize: 22,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          content: Text(
            'You can now check your cart.',
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'Roboto',
              color: Colors.white,
            ),
          ),
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop(); // Fermer la fenêtre de dialogue
              },
              child: Container(
                width: 50, // Largeur du bouton
                height: 50, // Hauteur du bouton (forme circulaire)
                decoration: BoxDecoration(
                  shape: BoxShape.circle, // Rendre le bouton circulaire
                  color: Colors.orange, // Fond orange
                ),
                child: Center(
                  child: Text(
                    'OK',
                    style: TextStyle(
                      fontSize: 16, // Taille de la police du texte
                      fontWeight: FontWeight.bold, // Texte en gras
                      color: Colors.white, // Texte blanc
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

// l'affichage de produits
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Color(0xFFFF5500)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //SearchBarCustom(),
              const SizedBox(height: 20),
              const Text(
                'Search for your items here!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: ListView.builder(
                    itemCount: jus.getJuiceList().length,
                    itemBuilder: (context, index) {
                      // Get the current sandwich from the list
                      Juice juice = jus.getJuiceList()[index];

                      // Return BoxTile for each sandwich
                      return BoxTileJuice(
                        juice: juice,
                        addJuiceToCart: () =>
                            addJuiceToCart(juice), // Pass the callback
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}

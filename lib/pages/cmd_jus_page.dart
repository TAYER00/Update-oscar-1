import 'package:app_ecomerce/Jus_cart_Front_end/Cart_Item_Juice.dart';
import 'package:app_ecomerce/Les_commandes/Cart_Items.dart';
import 'package:app_ecomerce/models/jus/Cart_jus.dart';
import 'package:app_ecomerce/models/jus/Jus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Cart_jus_page extends StatelessWidget {
  const Cart_jus_page({super.key});

  @override
  Widget build(BuildContext context) {
    // Consumer<Cart_Juice>
    return Consumer<Cart_Juice>(
      builder: (context, value, child) => Scaffold(
        // Appliquer la décoration de fond avec un gradient ici
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, Color(0xFFFF5500)], // Couleurs du gradient
              begin: Alignment.topCenter, // Début du gradient
              end: Alignment.bottomCenter, // Fin du gradient
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              children: [
                // Heading
                const Text(
                  'My Cart',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.white),
                ), // Text

                const SizedBox(height: 10),

                // List of items in the cart
                Expanded(
                  child: ListView.builder(
                    itemCount: value
                        .getUserCart()
                        .length, // Obtenir le nombre d'éléments dans le panier
                    itemBuilder: (context, index) {
                      // Obtenir l'élément du panier
                      Juice individualsandwish = value.getUserCart()[index];
                      // Provider.of<CombinedCart>(context, listen: false).addJuice(individualsandwish);

                      // Retourner le widget Cart_Item_Sandwish pour afficher chaque article du panier
                      return Cart_Item_Juice(juice: individualsandwish);
                    },
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

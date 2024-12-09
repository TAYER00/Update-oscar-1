import 'package:flutter/material.dart';

import 'Panier.dart';


class PanierCoffeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Panier'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Contenu du panier ici...'),
            ElevatedButton(
              onPressed: () {
                // Exemple d'ajout de commande
                PanierCoffeController.addOrder(context, {
                  'productName': 'Coffee',
                  'quantity': 1,
                  'price': 3.99,
                });
              },
              child: Text('Ajouter une commande'),
            ),
          ],
        ),
      ),
    );
  }
}

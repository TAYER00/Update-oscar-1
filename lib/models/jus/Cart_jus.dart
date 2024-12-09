import 'package:app_ecomerce/Les_commandes/Items.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Nécessaire pour accéder au Provider

import 'package:app_ecomerce/models/jus/Jus.dart';
import 'package:app_ecomerce/Les_commandes/Cart_Items.dart'; // Assurez-vous que CartItem est bien importé

class Cart_Juice extends ChangeNotifier {
  // Liste des jus à vendre dans le shop
  List<Juice> juiceShop = [
    Juice(
      name: 'Orange Juice',
      price: '\$4.99',
      imagePath: 'lib/images/jus_.png', // Remplacez par le bon chemin d'image
      description: 'Freshly squeezed orange juice, rich in vitamin C.',
    ),
    Juice(
      name: 'Apple Juice',
      price: '\$3.99',
      imagePath: 'lib/images/aboca.png',
      description: 'A refreshing juice made with crisp apples.',
    ),
    Juice(
      name: 'Carrot Juice',
      price: '\$5.99',
      imagePath: 'lib/images/melonge.png',
      description:
          'A healthy juice made with fresh carrots, great for your skin.',
    ),
    Juice(
      name: 'Pineapple Juice',
      price: '\$6.99',
      imagePath: 'lib/images/orange.png',
      description: 'Sweet and tangy juice made from fresh pineapples.',
    ),
  ];

  // Liste des articles dans le panier de l'utilisateur
  List<Juice> userCart = []; // Le panier de l'utilisateur pour les jus

  // Récupérer la liste des jus disponibles
  List<Juice> getJuiceList() {
    return juiceShop; // Renvoie la liste des jus disponibles
  }

  // Récupérer le panier de l'utilisateur
  List<Juice> getUserCart() {
    return userCart;
  }

  // Ajouter un jus au panier
  void addItemToCart(Juice juice) {
    userCart.add(juice);
    notifyListeners(); // Notifie les changements
  }

  // Retirer un jus du panier
  void removeItemFromCart(Juice juice) {
    userCart.remove(juice);
    notifyListeners(); // Notifie les changements
  }

  // Vous pouvez aussi ajouter une méthode pour initialiser juiceShop
  void loadJuiceShop(List<Juice> juices) {
    juiceShop = juices;
    notifyListeners(); // Notifie si la liste des jus change
  }













  // Supprimer un jus du panier (et également du panier combiné)
  void removeItemFromCart_total(BuildContext context, Juice juice) {
    // Retirer le jus de la liste userCart de Cart_Juice
    removeItemFromCart( juice);
    
     // Appel à la méthode de Cart_Juice pour supprimer le Juice du panier des jus
    //notifyListeners(); // Notifie les vues de la mise à jour du panier des jus

    // Supprimer le CartItem correspondant du panier combiné
    final cart = Provider.of<CombinedCart>(context, listen: false);

    // Trouver le CartItem correspondant dans la liste _items de CombinedCart
    CartItem itemToRemove = CartItem(
      name: juice.name,
      price: juice.price,
      itemType: 'juice',
      item: juice,
    );

    // Vérifier si l'élément existe dans la liste
    bool itemFound = false;

    for (var item in cart.items) {
      if (item.name == juice.name && item.itemType == 'juice') {
        // Si le Juice est trouvé dans la liste du panier combiné
        cart.removeItem(item); // Retirer le CartItem correspondant
        itemFound = true;
        break;
      }
    }

    // Afficher un message basé sur si l'élément a été trouvé ou non
    if (itemFound) {
      // Si l'élément a été supprimé, afficher ce message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Le jus ${juice.name} a été supprimé du panier combiné.')),
      );
      print('Jus ${juice.name} supprimé du panier combiné.');
      
    } else {
      // Si l'élément n'a pas été trouvé dans le panier combiné, afficher ce message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Le jus ${juice.name} n\'est pas présent dans le panier combiné.')),
      );
      print('Le jus ${juice.name} n\'a pas été trouvé dans le panier combiné.');
    }
  }
}

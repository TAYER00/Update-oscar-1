import 'package:app_ecomerce/Les_commandes/Cart_Items.dart';
import 'package:app_ecomerce/Les_commandes/Items.dart';
import 'package:app_ecomerce/models/sandwich/Sandwich.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class Cart_Sandwish extends ChangeNotifier {
  // Liste des sandwichs à vendre dans le shop
  List<Sandwich> sandwishShop = [
    Sandwich(
      name: 'Cart_Sandwi',
      price: '\$10.99',
      imagePath: 'lib/images/sanda.png', // Remplacez par le bon chemin d'image
      description:
          'A delicious sandwich with grilled chicken, lettuce, and tomato.',
    ),
    Sandwich(
      name: 'Cart_Sandwi_2',
      price: '\$8.99',
      imagePath: 'lib/images/des.png',
      description: 'A healthy sandwich with fresh veggies and hummus.',
    ),
    Sandwich(
      name: 'Cart_Sandwi_3',
      price: '\$12.99',
      imagePath: 'lib/images/sanda.png',
      description: 'Grilled chicken with Caesar dressing and crispy lettuce.',
    ),
    Sandwich(
      name: 'Turkey Bacon Sandwich',
      price: '\$11.99',
      imagePath: 'lib/images/sanda.png',
      description:
          'A hearty sandwich with turkey, bacon, and fresh vegetables.',
    ),
  ];

  // Liste des articles dans le panier de l'utilisateur
  List<Sandwich> userCart = []; // hadi hia la kat 3mer mli user ki warek ' + '

  // Récupérer la liste des sandwichs disponibles
  List<Sandwich> getSandwichList() {
    return sandwishShop; // Renvoie la liste des sandwichs disponibles
  }

  // Récupérer le panier de l'utilisateur
  List<Sandwich> getUserCart() {
    return userCart;
  }

  // Ajouter un sandwich au panier
  void addItemToCart(Sandwich sandwich) {
    userCart.add(sandwich);
    notifyListeners(); // Notifie les changements
  }

  // Retirer un sandwich du panier
  void removeItemFromCart(Sandwich sandwich) {
    userCart.remove(sandwich);
    notifyListeners(); // Notifie les changements
  }

  // Vous pouvez aussi ajouter une méthode pour initialiser sandwishShop
  void loadSandwichShop(List<Sandwich> sandwiches) {
    sandwishShop = sandwiches;
    notifyListeners(); // Notifie si la liste des sandwichs change
  }

  void removeItemFromCart_total(BuildContext context, Sandwich sandwich) {
    // Retirer le jus de la liste userCart de Cart_sandwich
    removeItemFromCart(
        sandwich); // Appel à la méthode de Cart_sandwich pour supprimer le sandwich du panier des jus
    //notifyListeners(); // Notifie les vues de la mise à jour du panier des jus

    // Supprimer le CartItem correspondant du panier combiné
    final cart = Provider.of<CombinedCart>(context, listen: false);

    // Trouver le CartItem correspondant dans la liste _items de CombinedCart
    CartItem itemToRemove = CartItem(
      name: sandwich.name,
      price: sandwich.price,
      itemType: 'sandwich',
      item: sandwich,
    );

    // Vérifier si l'élément existe dans la liste
    bool itemFound = false;
    for (var item in cart.items) {
      if (item.name == sandwich.name && item.itemType == 'sandwich') {
        // Si le sandwich est trouvé dans la liste du panier combiné
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
            content: Text(
                'Le jus ${sandwich.name} a été supprimé du panier combiné.')),
      );
      print('Jus ${sandwich.name} supprimé du panier combiné.');
    } else {
      // Si l'élément n'a pas été trouvé dans le panier combiné, afficher ce message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Le jus ${sandwich.name} n\'est pas présent dans le panier combiné.')),
      );
      print(
          'Le jus ${sandwich.name} n\'a pas été trouvé dans le panier combiné.');
    }
  }
}

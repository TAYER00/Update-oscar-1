import 'package:app_ecomerce/Les_commandes/Items.dart';
import 'package:app_ecomerce/models/jus/Jus.dart';
import 'package:app_ecomerce/models/sandwich/Sandwich.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CombinedCart extends ChangeNotifier {

  List<CartItem> _items = []; // Liste des articles du panier combiné

  // Ajouter un sandwich au panier
  void addSandwich(Sandwich sandwich) {
    _items.add(CartItem(
      name: sandwich.name,
      price: sandwich.price,
      itemType: 'sandwich',
      item: sandwich,
    ));
    notifyListeners(); // Notifier les vues que l'état a changé
  }

  // Ajouter un jus au panier
  void addJuice(Juice juice) {
    _items.add(CartItem(
      name: juice.name,
      price: juice.price,
      itemType: 'juice',
      item: juice,
    ));
    notifyListeners();
  }

  // Récupérer tous les articles du panier
  List<CartItem> get items => _items;

  // Supprimer un article du panier
  void removeItem(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  // Vider le panier
  void clearCart() {
    _items.clear(); // Vide la liste
    notifyListeners(); // Notifie les vues que l'état a changé
  }
}

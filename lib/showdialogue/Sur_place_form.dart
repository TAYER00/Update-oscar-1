import 'package:app_ecomerce/Les_commandes/Cart_Items.dart';
import 'package:app_ecomerce/Les_commandes/Items.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
 

void showNameDialog(BuildContext context) {
  final TextEditingController _nameController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Entrez votre nom'),
        content: TextField(
          controller: _nameController,
          decoration: const InputDecoration(hintText: 'Votre nom'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Fermer le dialog
            },
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              _handleUserNameSubmission(context, _nameController.text.trim());
            },
            child: const Text('Valider'),
          ),
        ],
      );
    },
  );
}

Future<void> _handleUserNameSubmission(
    BuildContext context, String name) async {
  if (name.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Veuillez entrer un nom')),
    );
    return;
  }

  // Récupérer les éléments du panier à partir de CombinedCart
  final combinedCart = Provider.of<CombinedCart>(context, listen: false);
  print("Utilisateur: $name");

  try {
    // 1. Insérer l'utilisateur dans la base de données
    final userId = await _insertUser(name);
    if (userId == null) {
      throw Exception("Erreur lors de l'inscription de l'utilisateur");
    }

    // 2. Créer la commande pour l'utilisateur
    final orderId = await _createOrder(userId);
    if (orderId == null) {
      throw Exception("Erreur lors de la création de la commande");
    }

    print("le debut de insert ordre items ");

    // 3. Insérer les éléments du panier dans la commande
    await _insertOrderItems(orderId, combinedCart.items);

    // 4. Vider le panier après la commande et afficher un message de bienvenue
    combinedCart.clearCart();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Bienvenue, $name!')),
    );

    Navigator.of(context).pop(); // Fermer le dialog
  } catch (error) {
    // Gestion des erreurs globales
    print("Erreur : $error");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error.toString())),
    );
  }
}

Future<String?> _insertUser(String name) async {
  try {
    final response = await Supabase.instance.client.from('users').insert([
      {'name': name},
    ]).select(); // Utilisation de .select() pour récupérer les données insérées

    print('Réponse d\'insertion utilisateur: $response');

    // Vérification si la réponse contient des données
    if (response != null && response.isNotEmpty) {
      final user = response[0]; // Récupérer l'utilisateur inséré
      print('Utilisateur inséré: ${user['name']}, ID: ${user['user_id']}');

      final id = user['user_id']; // L'ID est dans la clé 'user_id'
      final idAsString = id.toString(); // Convertir l'ID en String
      print('ID converti en String: $idAsString');

      return idAsString; // Retourner l'ID converti en String
    } else {
      print('Réponse d\'insertion vide ou nulle');
    }
  } catch (error) {
    print("Erreur lors de l'insertion utilisateur: $error");
  }
  return null;
}

Future<String?> _createOrder(String userId) async {
  try {
    final userIdInt =
        int.parse(userId); // Assurez-vous que userId est un entier valide

    // Insérer la commande
    final response = await Supabase.instance.client.from('orders').insert([
      {
        'user_id': userIdInt,
        'created_at': DateTime.now().toIso8601String(),
      }
    ]).select(); // Utilisation de .select() pour récupérer la ligne insérée

    // Vérifiez la réponse
    if (response.isNotEmpty) {
      final orderId =
          response[0]['order_id']; // Récupérer l'ID de la commande insérée
      print("Commande créée avec l'ID: $orderId");
      return orderId
          .toString(); // Retourner l'ID de la commande sous forme de String
    } else {
      print("Aucune commande insérée");
      return null;
    }
  } catch (e) {
    print("Erreur lors de la création de la commande: $e");
    return null;
  }
}

Future<void> _insertOrderItems(String orderId, List<CartItem> items) async {
  List<Future> insertItemFutures = [];

  // Vérification de l'ID de la commande
  final order_Id = int.tryParse(orderId);
  if (order_Id == null || order_Id == 0) {
    print("Erreur : L'ID de la commande est invalide : $orderId");
    return; // Si l'ID est invalide, arrêtez l'insertion des items
  }

  print("Insertion des items pour la commande $order_Id");

  for (var cartItem in items) {
    print("Insertion de l'item: ${cartItem.name}, Prix: ${cartItem.price}");

    String priceString = cartItem.price?.replaceAll(RegExp(r'[^0-9.]'), '') ??
        ''; // Nettoyage du prix
    int price = 0; // Valeur par défaut

    if (priceString.isNotEmpty) {
      try {
        price = double.parse(priceString)
            .toInt(); // Conversion en double puis en int
        print("Prix converti : $price");
      } catch (e) {
        print(
            "Erreur lors de la conversion du prix pour l'article ${cartItem.name}: $e");
      }
    } else {
      print("Prix vide ou invalide pour l'article ${cartItem.name}");
    }

    // Insertion dans la base de données
    insertItemFutures.add(Supabase.instance.client.from('order_items').insert([
      {
        'order_id': order_Id,
        'item_name': cartItem.name,
        'item_price': price,
      }
    ]).then((_) {
      print("Item inséré: ${cartItem.name}");
    }).catchError((error) {
      print("Erreur lors de l'insertion de l'item: $error");
    }));
  }

  print('Insertion des items de la commande validée.');

  // Attendre que tous les items soient insérés
  await Future.wait(insertItemFutures);
}

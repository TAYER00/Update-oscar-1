// Assurez-vous de bien importer la classe Juice
import 'package:app_ecomerce/Les_commandes/Cart_Items.dart';
import 'package:app_ecomerce/Les_commandes/Items.dart';
import 'package:app_ecomerce/models/jus/Cart_jus.dart';
import 'package:app_ecomerce/models/jus/Jus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Nécessaire pour accéder au Provider

class Cart_Item_Juice extends StatefulWidget {
  Juice juice; // Représente l'objet de type Juice
  Cart_Item_Juice({
    super.key,
    required this.juice,
  });

  @override
  State<Cart_Item_Juice> createState() => _Cart_Juice_Item_State();
}

class _Cart_Juice_Item_State extends State<Cart_Item_Juice> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 16.0), // Augmenter l'espacement interne du ListTile
      leading: Image.asset(
        widget.juice.imagePath,
        width: 80, // Taille de l'image
        height: 80, // Taille de l'image
        fit: BoxFit.cover, // Assurez-vous que l'image s'adapte bien
      ), // Affiche l'image du jus
      title: Text(
        widget.juice.name,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18, // Taille du texte
        ),
      ),
      subtitle: Text(
        widget.juice.price,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16, // Taille du texte
        ),
      ),
      trailing: GestureDetector(
        onTap: () {
          // Supprimer le CartItem correspondant dans CombinedCart
          Provider.of<Cart_Juice>(context, listen: false)
              .removeItemFromCart_total(context, widget.juice);

          // Supprimer le Juice du panier spécifique aux jus (Cart_Juice)
          // Provider.of<Cart_Juice>(context, listen: false)
          //     .removeItemFromCart(widget.juice);

          // Actualiser le panier combiné avec une nouvelle liste
          // Nous allons reconstruire la liste des CartItems avec les éléments restants
          // List<CartItem> updatedItems =
          //     Provider.of<CombinedCart>(context, listen: false).items;

          // Appel à updateItems pour actualiser la liste du panier combiné
          // Provider.of<CombinedCart>(context, listen: false)
          //     .updateItems(updatedItems);

          // Optionnel: Afficher un message dans la console pour le débogage
          print('Jus ${widget.juice.name} supprimé des paniers.');
          //print(updatedItems);
        },
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle, // Rendre le bouton circulaire
            color: Colors.orange, // Fond orange
          ),
          child: Icon(
            Icons.delete, // Icône "moins"
            color: Colors.white,
            size: 20, // Taille de l'icône
          ),
        ),
      ), // Bouton "moins" circulaire
    );
  }
}

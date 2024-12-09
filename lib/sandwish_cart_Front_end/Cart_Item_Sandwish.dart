import 'package:app_ecomerce/models/sandwich/Cart_Sandwish.dart';
import 'package:app_ecomerce/models/sandwich/Sandwich.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Nécessaire pour accéder au Provider

class Cart_Item_Sandwish extends StatefulWidget {
  Sandwich sandwich;
  Cart_Item_Sandwish({
    super.key,
    required this.sandwich,
  });

  @override
  State<Cart_Item_Sandwish> createState() => _Cart_Sandwish_Item_State();
}

class _Cart_Sandwish_Item_State extends State<Cart_Item_Sandwish> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 16.0), // Augmenter l'espacement interne du ListTile
      leading: Image.asset(
        widget.sandwich.imagePath,
        width: 80, // Taille de l'image
        height: 80, // Taille de l'image
        fit: BoxFit.cover, // Assurez-vous que l'image s'adapte bien
      ), // Affiche l'image du sandwich
      title: Text(
        widget.sandwich.name,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18, // Taille du texte
        ),
      ),
      subtitle: Text(
        widget.sandwich.price,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16, // Taille du texte
        ),
      ),

      trailing: GestureDetector(
        onTap: () {
          // Appeler la méthode removeItemFromCart du Cart_Sandwish pour retirer le sandwich du panier
          // Provider.of<Cart_Sandwish>(context, listen: false)
          //     .removeItemFromCart(widget.sandwich);

          Provider.of<Cart_Sandwish>(context, listen: false)
              .removeItemFromCart_total(context, widget.sandwich);

          // Optionnel: Afficher un message dans la console pour le débogage
          print('Jus ${widget.sandwich.name} supprimé des paniers.');
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

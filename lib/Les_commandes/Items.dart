class CartItem {
  final String name; // Nom de l'article
  final String price; // Prix de l'article
  final String itemType; // Type d'article ('sandwich' ou 'juice')
  final dynamic item; // L'objet réel (soit un Sandwich, soit un Juice)

  // Constructeur
  CartItem({required this.name, required this.price, required this.itemType, required this.item});
}

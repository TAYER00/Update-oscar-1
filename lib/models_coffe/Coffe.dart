// Importations nécessaires pour Flutter
import 'package:flutter/material.dart';

// Définition de l'énumération pour les catégories de café
enum CoffeeCategory {
  Espresso,
  Latte,
  Cappuccino,
  Americano,
  Mocha,
  Frappe,
}

// Classe Coffee pour représenter un café
class Coffee {
  final String name; // Nom du café
  final String description; // Description du café
  final String imageUrl; // URL de l'image du café
  final double price; // Prix du café
  final CoffeeCategory category; // Catégorie du café

  // Constructeur de la classe Coffee
  Coffee({
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.category,
  });
}

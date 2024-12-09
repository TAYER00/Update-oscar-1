import 'package:app_ecomerce/sandwish_cart_Front_end/Boxes.dart';
import 'package:app_ecomerce/Components/Drawer.dart';
import 'package:app_ecomerce/Components/search_bar.dart';
import 'package:app_ecomerce/models/sandwich/Sandwich.dart';
import 'package:app_ecomerce/pages/IntroPage.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
// Assurez-vous que cette importation pointe vers le fichier où vous avez défini la classe Sandwich

// Crée une liste d'objets Sandwich
List<Sandwich> sandwichList = [
  Sandwich(
    name: 'zbooba',
    price: '\$10.99',
    imagePath:
        'lib/images/sandwich_thone.png', // Remplacez par le bon chemin d'image
    description:
        'A delicious sandwich with grilled chicken, lettuce, and tomato.',
  ),
  Sandwich(
    name: 'Veggie zbooba',
    price: '\$8.99',
    imagePath: 'lib/images/sandwich_thone.png',
    description: 'A healthy sandwich with fresh veggies and hummus.',
  ),
  Sandwich(
    name: 'Chicken zbooba',
    price: '\$12.99',
    imagePath: 'lib/images/sandwich_thone.png',
    description: 'Grilled chicken with Caesar dressing and crispy lettuce.',
  ),
  Sandwich(
    name: 'Turkey zbooba',
    price: '\$11.99',
    imagePath: 'lib/images/sandwich_thone.png',
    description: 'A hearty sandwich with turkey, bacon, and fresh vegetables.',
  ),
  // Ajoutez d'autres objets Sandwich si nécessaire
];

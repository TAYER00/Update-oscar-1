import 'package:flutter/material.dart';
import 'Coffe.dart'; // Importez votre fichier coffee.dart

// Liste des cafés à afficher dans ItemsWidget
final List<Coffee> coffees = [
  Coffee(
    name: 'Latte',
    description: 'Smooth and creamy',
    imageUrl: 'images/emporter.png',
    price: 4.99,
    category: CoffeeCategory.Latte,
  ),
  Coffee(
    name: 'Espresso',
    description: 'Strong and bold',
    imageUrl: 'images/Espresso.png',
    price: 3.49,
    category: CoffeeCategory.Espresso,
  ),
  Coffee(
    name: 'Black Coffee',
    description: 'Rich and aromatic',
    imageUrl: 'images/Black Coffee.png',
    price: 2.99,
    category: CoffeeCategory.Americano,
  ),
  Coffee(
    name: 'Milk Coffee',
    description: 'Rich and aromatic',
    imageUrl: 'images/Latte.png',
    price: 2.99,
    category: CoffeeCategory.Americano,
  ),
  Coffee(
    name: 'Cold Coffee',
    description: 'Rich and aromatic',
    imageUrl: 'images/cold_coffe.png',
    price: 2.99,
    category: CoffeeCategory.Americano,
  ),
  Coffee(
    name: 'Nice Coffee',
    description: 'Rich and aromatic',
    imageUrl: 'images/splash_coffe.png',
    price: 2.99,
    category: CoffeeCategory.Americano,
  ),
  Coffee(
    name: 'Black Coffee',
    description: 'Rich and aromatic',
    imageUrl: 'images/emporter.png',
    price: 2.99,
    category: CoffeeCategory.Americano,
  ),

];




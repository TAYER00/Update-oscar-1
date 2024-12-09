import 'package:flutter/material.dart';

class Sandwich {
  final String name;
  final String price;
  final String imagePath;
  final String description;

  // Constructeur de la classe
  Sandwich({
    required this.name,
    required this.price,
    required this.description,
    required this.imagePath,
  });
}

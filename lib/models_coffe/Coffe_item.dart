import 'package:flutter/material.dart';


import 'Coffe.dart';
import 'Widgets/SingleItemScreen.dart';

  // Assurez-vous d'importer votre modèle de café ici

class ItemsWidget extends StatelessWidget {
  // Liste des cafés à afficher
   final List<Coffee> coffees;


   ItemsWidget({required this.coffees});


  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      childAspectRatio: (150 / 195),
      children: List.generate(
        coffees.length,
            (index) => _buildCoffeeItem(context, coffees[index]),
      ),
    );
  }

  Widget _buildCoffeeItem(BuildContext context, Coffee coffee) {
    return GestureDetector(
      onTap: () {
        // Naviguer vers SingleItemScreen et passer les données du café
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SingleItemScreen(coffee: coffee), // Passer l'objet Coffee complet
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 13),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color(0xFF212325),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              spreadRadius: 1,
              blurRadius: 8,
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.all(10),
                child: Image.asset(
                  coffee.imageUrl,
                  width: 120,
                  height: 120,
                  fit: BoxFit.contain,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      coffee.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      coffee.description,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white60,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${coffee.price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Logique d'incrémentation ici
                      },
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Color(0xFFFBA606),
                          borderRadius: BorderRadius.circular(20),
                        ),
           /*             child: Icon(
                          Icons.add,
                          size: 20,
                          color: Colors.white,
                        ), */
                      ),
                    ),
                  ],

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

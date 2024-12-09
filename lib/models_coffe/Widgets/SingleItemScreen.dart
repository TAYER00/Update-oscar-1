import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import '../../services/firestore.dart';
import '../Coffe.dart';
import '../panier_coffe/Panier.dart';
import 'package:geolocator/geolocator.dart'; // Pour Position, Geolocator, et LocationPermission



class SingleItemScreen extends StatefulWidget {


  final Coffee coffee;

  SingleItemScreen({required this.coffee});

  @override
  _SingleItemScreenState createState() => _SingleItemScreenState();
}

class _SingleItemScreenState extends State<SingleItemScreen> {
  final FirestoreService firestoreService = FirestoreService();                       // appel de firestore qu icontient les operation CERUD vers l firebase
  final TextEditingController productNameController = TextEditingController();         // les controller
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController totalPriceController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();






  int quantity = 0;
  bool showConfirmation = false;
  bool isFavorite = false;

  void incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void decrementQuantity() {
    setState(() {
      if (quantity > 0) {
        quantity--;
      }
    });
  }
 // final player = AudioPlayer();
































  void addToCart() async {
    double totalPrice = quantity * widget.coffee.price;

    if (quantity > 0) {
      try {
        Position position = await getCurrentPosition();
        String googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}';

        // Affiche le dialogue de confirmation
        bool? confirmed = await _showConfirmationDialog({
          'productName': widget.coffee.name,
          'quantity': quantity,
          'description': widget.coffee.description,
          'prix_total': totalPrice,
          'location': googleMapsUrl,
        });

        if (confirmed == true) {
          // Affiche le dialogue pour entrer le numéro de téléphone et récupère le numéro
          final phoneNumber = await _showPhoneNumberDialog();
          if (phoneNumber != null) {
            // Création du dictionnaire avec les informations nécessaires, incluant le numéro de téléphone
            Map<String, dynamic> orderInfo = {
              'productName': widget.coffee.name,
              'quantity': quantity,
              'description': widget.coffee.description,
              'prix_total': totalPrice,
              'location': googleMapsUrl,
              'phoneNumber': phoneNumber, // Ajout du numéro de téléphone
            };

            // Affectation des valeurs du Map aux contrôleurs
            productNameController.text = orderInfo['productName'];
            quantityController.text = orderInfo['quantity'].toString();
            totalPriceController.text = orderInfo['prix_total'].toString();
            locationController.text = orderInfo['location'];
            phoneNumberController.text = orderInfo['phoneNumber']; // Affecte le numéro de téléphone au contrôleur

            // Ajout de la commande au panier via FirestoreService
            firestoreService.addNote(
                productNameController.text,
                quantityController.text,
                totalPriceController.text,
                locationController.text,
                phoneNumberController.text // Passe le numéro de téléphone à FirestoreService
            );

            // Réinitialisation de la quantité à zéro
            setState(() {
              quantity = 0;
              showConfirmation = true;
            });

            // Démarre un timer pour réinitialiser showConfirmation après 4 secondes
            Timer(Duration(seconds: 4), () {
              setState(() {
                showConfirmation = false;
              });
            });
          } else {
            // Numéro de téléphone non valide ou annulation
            print('Numéro de téléphone non valide ou annulé');
          }
        } else {
          // Annule l'ajout de la commande si l'utilisateur a choisi d'annuler
          print('Commande annulée');
        }

      } catch (e) {
        print('Erreur de localisation: $e');
        if (e.toString().contains('Les services de localisation sont désactivés')) {
          _showLocationDisabledDialog();
        }
      }
    }
  }















// confirmation
  Future<bool?> _showConfirmationDialog(Map<String, dynamic> orderInfo) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white, // Couleur de fond du dialogue
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0), // Coins arrondis
          ),
          title: Row(
            children: [
              //Icon(Icons.info_outline, color: Colors.blue), // Icône avant le titre
              Expanded(
                child: Text(
                  'Confirmer la commande',
                  overflow: TextOverflow.ellipsis, // Pour gérer le dépassement de texte
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.black, // Couleur du titre
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Produit: ${orderInfo['productName']}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Couleur du texte
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Quantité: ${orderInfo['quantity']}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black, // Couleur du texte
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Prix total: \$${orderInfo['prix_total'].toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green, // Couleur du texte
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Annuler
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.black, // Couleur du texte du bouton
              ),
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(true); // Ferme le premier dialogue
                // Affiche le second dialogue pour entrer le numéro de téléphone
                await _showPhoneNumberDialog();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue, // Couleur du texte du bouton
              ),
              child: Text('Valider'),
            ),
          ],
        );
      },
    );
  }














  Future<String?> _showPhoneNumberDialog() async {
    final TextEditingController phoneController = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: Text('Entrez votre numéro de téléphone'),
          content: TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: '06.....',
              labelText: 'Numéro de téléphone',
              border: OutlineInputBorder(),
            ),
            maxLength: 10,
          ),
          actions: [
            TextButton(
              onPressed: () {
                final phoneNumber = phoneController.text;
                if (phoneNumber.isNotEmpty && phoneNumber.length >= 9) {
                  Navigator.of(context).pop(phoneNumber);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Le numéro de téléphone doit contenir au moins 9 caractères.'),
                    ),
                  );
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
              ),
              child: Text('Valider'),
            ),
          ],
        );
      },
    );
  }






















// Méthodes pour obtenir la localisation
  Future<Position> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Vérifie si les services de localisation sont activés
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Les services de localisation sont désactivés.');
    }

    // Vérifie les permissions de localisation
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Les permissions de localisation sont refusées.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Les permissions de localisation sont refusées de façon permanente.');
    }

    return await Geolocator.getCurrentPosition();
  }

  void _showLocationDisabledDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Activer la localisation'),
          content: const Text('Les services de localisation sont désactivés. Veuillez les activer dans les paramètres de votre appareil pour utiliser cette fonctionnalité.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Paramètres'),
              onPressed: () async {
                Navigator.of(context).pop();
                await Geolocator.openLocationSettings();
              },
            ),
          ],
        );
      },
    );
  }




























  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });

    // Démarre un timer pour réinitialiser isFavorite après 1 seconde
    Timer(Duration(seconds: 1), () {
      setState(() {
        isFavorite = !isFavorite;
      });
    });

    // Ajoutez ici la logique pour gérer les favoris
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF212325),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: 30, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 25),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
                SizedBox(height: 50),
                Center(
                  child: Image.asset(
                    widget.coffee.imageUrl,
                    width: MediaQuery.of(context).size.width / 1.2,
                  ),
                ),
                SizedBox(height: 50),
                Padding(
                  padding: EdgeInsets.only(left: 25, right: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "BEST COFFEE",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.4),
                          letterSpacing: 3,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        widget.coffee.name,
                        style: TextStyle(
                          fontSize: 30,
                          letterSpacing: 1,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 25),
                      Container(
                        width: MediaQuery.of(context).size.width,




















                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: decrementQuantity,
                                    child: Icon(
                                      Icons.remove,
                                      size: 25,
                                      color: Colors.yellow,
                                    ),
                                  ),
                                  Text(
                                    quantity.toString(),
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.yellow,

                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: incrementQuantity,
                                    child: Icon(
                                      Icons.add,
                                      size: 25,
                                      color: Colors.yellow,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              '\$${widget.coffee.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),





















                      ),
                      SizedBox(height: 20),
                      Text(
                        widget.coffee.description,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.4),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            "Volume:",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            "60 ml",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [










                            GestureDetector(
                              onTap: addToCart,
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 1000),
                                curve: Curves.easeInOut,
                                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                                decoration: BoxDecoration(
                                  color: showConfirmation ? Colors.green : Color.fromARGB(255, 50, 54, 56),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Text(
                                  showConfirmation ? "Added!" : "Add to Cart",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ),













                            GestureDetector(
                              onTap: toggleFavorite,
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 1000),
                                curve: Curves.easeInOut,
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: isFavorite ? Colors.red : Colors.orange,
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Icon(Icons.favorite_outline, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

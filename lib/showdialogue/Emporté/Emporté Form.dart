import 'package:app_ecomerce/Les_commandes/Cart_Items.dart';
import 'package:app_ecomerce/Les_commandes/Items.dart';
import 'package:app_ecomerce/showdialogue/Emport%C3%A9/location_form_model.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app_ecomerce/Les_commandes/Cart_Items.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart'; // Si vous utilisez Provider pour gérer l'état du panier

// Assurez-vous d'importer Supabase si vous l'utilisez.
final TextEditingController _nameController = TextEditingController();
final TextEditingController _phoneController = TextEditingController();
final TextEditingController locationController = TextEditingController();

class LocationFormModel extends ChangeNotifier {
  String _name = '';
  String _phone = '';
  String _localisation = '';
  bool _isLocationAvailable = false;

  String get name => _name;
  set name(String value) {
    _name = value;
    notifyListeners();
  }

  String get phone => _phone;
  set phone(String value) {
    _phone = value;
    notifyListeners();
  }

  String get localisation => _localisation;
  set localisation(String value) {
    _localisation = value;
    notifyListeners();
  }

  bool get isLocationAvailable => _isLocationAvailable;
  set isLocationAvailable(bool value) {
    _isLocationAvailable = value;
    notifyListeners();
  }
}

Future<void> formulaire(BuildContext context) async {
  print('=========================Formulaire========================');
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return ChangeNotifierProvider<LocationFormModel>(
        create: (_) => LocationFormModel(),
        child: Consumer<LocationFormModel>(
          builder: (context, model, child) {
            return AlertDialog(
              title: const Text('Entrez vos informations'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildNameField(_nameController), // Champ pour le nom
                  _buildPhoneField(_phoneController), // Champ pour le téléphone
                  _buildLocationField(
                      locationController), // Champ pour la localisation
                  // ... _buildNameField, _buildPhoneField, _buildLocationField ...
                ],
              ),
              actions: <Widget>[
                _buildCancelButton(context),
                _buildValidateButton(context, _nameController, _phoneController,
                    locationController),
                // ... _buildCancelButton, _buildValidateButton ...
              ],
            );
          },
        ),
      );
    },
  );
}

// Fonction principale pour afficher le formulaire de localisation
void showLocationFormDialog(BuildContext context) {
  print('=========================A========================');

  //final TextEditingController _nameController = TextEditingController();
  //final TextEditingController _phoneController = TextEditingController();
  ///////final TextEditingController locationController = TextEditingController();

  // Vérifier si la localisation est disponible avant d'afficher le formulaire
  _getLocation(context).then((position) {
    print('=========================bbbA========================');
    // Une fois la localisation récupérée avec succès, nous affichons le formulaire
    final String googleMapsUrl =
        'https://www.google.com/maps?q=${position.latitude},${position.longitude}';

    print('Lien Google Maps : $googleMapsUrl');

    locationController.text = googleMapsUrl;

    print('Localisation: ${position.latitude}, ${position.longitude}');

    formulaire(context);
  }).catchError((e) {
    // Si l'obtention de la localisation échoue, afficher un message d'erreur
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erreur : ${e.toString()}')),
    );
  });
}

// Champ de saisie pour le nom
Widget _buildNameField(TextEditingController controller) {
  return TextField(
    controller: controller,
    decoration: const InputDecoration(hintText: 'Nom'),
  );
}

// Champ de saisie pour le téléphone
Widget _buildPhoneField(TextEditingController controller) {
  return TextField(
    controller: controller,
    decoration: const InputDecoration(hintText: 'Numéro de téléphone'),
    keyboardType: TextInputType.phone,
  );
}

// Champ de saisie pour la localisation (message de succès)
Widget _buildLocationField(TextEditingController controller) {
  return TextField(
    controller: controller,
    decoration: const InputDecoration(hintText: 'Localisation'),
    enabled: false, // Empêcher la modification du champ de localisation
  );
}

// Bouton pour annuler l'action
Widget _buildCancelButton(BuildContext context) {
  return TextButton(
    onPressed: () {
      Navigator.of(context).pop(); // Fermer le dialog
    },
    child: const Text('Annuler'),
  );
}

// Bouton pour valider et enregistrer les informations
Widget _buildValidateButton(
    // Récupérer les éléments du panier à partir de CombinedCart
    BuildContext context,
    TextEditingController nameController,
    TextEditingController phoneController,
    TextEditingController locationController) {
  // Récupérer les éléments du panier à partir de CombinedCart
  final combinedCart = Provider.of<CombinedCart>(context, listen: false);
  return TextButton(
    onPressed: () async {
      // Récupérer les valeurs saisies par l'utilisateur
      String name = nameController.text;
      String phone = phoneController.text;
      String localisation = locationController.text;

      // Vérifier si les informations sont valides
      if (_validateInput(name, phone, localisation)) {
        print('Nom: $name');
        print('Téléphone: $phone');
        print('Localisation: $localisation');

        //1 Insérer l'utilisateur dans la base de données
        //await _insertUser(name, phone, localisation);
        final userId = await _insertUser(name, phone, localisation);
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

        print('=========================AAAAAAAAAA========================');
        // Fermer le dialog après la validation
        combinedCart.clearCart();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bienvenue, $name!')),
        );

        Navigator.of(context).pop();
      } else {
        // Afficher un message si des informations sont manquantes ou invalides
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Veuillez remplir tous les champs correctement')),
        );
      }
    },
    child: const Text('Valider'),
  );
}

// Validation des champs d'entrée pour s'assurer qu'ils sont non vides et valides
bool _validateInput(String name, String phone, String localisation) {
  if (name.isEmpty || phone.isEmpty || localisation.isEmpty) {
    return false;
  }
  return true;
}

// Méthode pour obtenir la localisation
Future<Position> _getLocation(BuildContext context) async {
  try {
    // Récupérer la position actuelle
    Position position = await getCurrentPosition();
    print('wssalti');

    print(
        'Localisation récupérée avec succès: ${position.latitude}, ${position.longitude}');

    return position;
  } catch (e) {
    print('Erreur lors de la récupération de la localisation: $e');
    print(
        'Erreur lors de la récupération de la localisation: $e'); ///////////////////////////////////////////////////////////////
    // Afficher un message d'erreur si la localisation échoue
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString())),
    );
    throw Exception('Activer la localisation ');
  }
}

// alert pour dire au user d'activé localisation via la page de parametres de mobile
Future<void> _showLocationDisabledDialog(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Activer la localisation'),
        content: const Text(
            'Les services de localisation sont désactivés. Veuillez les activer dans les paramètres de votre appareil pour utiliser cette fonctionnalité.'),
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

// Méthode pour obtenir la position actuelle
Future<Position> getCurrentPosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Vérifie si les services de localisation sont activés
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    await _showLocationDisabledDialog;
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
    return Future.error(
        'Les permissions de localisation sont refusées de façon permanente.');
  }

  return await Geolocator.getCurrentPosition();
}

// Fonction pour insérer l'utilisateur dans la base de données
Future<String?> _insertUser(
    String name, String phone, String localisation) async {
  try {
    final response = await Supabase.instance.client.from('users').insert([
      {
        'name': name,
        'phone': phone,
        'localisation': localisation,
      },
    ]).select();

    print('Réponse d\'insertion utilisateur: $response');

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
  } catch (e) {
    print('Erreur lors de l\'insertion utilisateur: $e');
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

import 'package:app_ecomerce/models/jus/Cart_jus.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';


class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

bool _isCardDeleted(int index) {
  return _deletedCardIndices.contains(index);
}

// Liste pour stocker les indices des cartes supprimées
List<int> _deletedCardIndices = [];

class _AdminPageState extends State<AdminPage> {
  // Déclaration de la liste en dehors du constructeur
  //List<int> _deletedCardIndices = [];
  Set<int> _hiddenIndices =
      {}; // Liste pour stocker les indices des éléments masqués

  // Fonction pour marquer un élément comme masqué
  void _hideItem(int index) {
    setState(() {
      _hiddenIndices
          .add(index); // Ajoute l'indice à la liste des éléments masqués
    });
  }

  Stream<List<Map<String, dynamic>>>? _userStream;

  @override
  void initState() {
    super.initState();
    _initializeStream();
  }

  void _initializeStream() {
    _userStream = Supabase.instance.client
        .from('users')
        .stream(primaryKey: ['user_id']).order('user_id', ascending: true);
  }

  Future<void> refreshData() async {
    setState(() {
      _initializeStream();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black, // Couleur de l'AppBar
        elevation: 0, // Supprimer l'ombre de l'AppBar
        title: null, // Supprimer le titre par défaut
        centerTitle: true, // S'assurer que l'image est centrée dans l'AppBar
        flexibleSpace: Center(
          child: Image.asset(
            'lib/images/oscar.png', // Remplacez par votre chemin d'image
            height: 60, // Ajustez la taille de l'image
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Color(0xFFFF5500)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: StreamBuilder<List<Map<String, dynamic>>>(
          // Chargement des utilisateurs
          stream: _userStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Erreur: ${snapshot.error}'));
            }

            final users = snapshot.data!;

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                final userId = user['user_id'];
                final localisation = user['localisation'];
                final phone = user['phone'];
                final name = user['name'] ?? 'Nom non disponible';
                // Si l'élément est marqué comme masqué, ne pas l'afficher
                if (_hiddenIndices.contains(index)) {
                  return SizedBox.shrink(); // Ne rien afficher pour cet élément
                }

                return Card(
                  margin: EdgeInsets.all(10),
                  color: _isCardDeleted(index)
                      ? Colors.red
                      : Colors.white, // Condition pour changer la couleur
                  child: ExpansionTile(
                    title: Row(
                      children: [
                        // Flexible(
                        //   child: Text(name, style: TextStyle(fontSize: 20)),
                        //   flex: 2, // Take up 2 parts of the available space
                        // ),
                        SizedBox(width: 40),
                        if (localisation != null)
                          Flexible(
                            child: IconButton(
                              icon: Icon(Icons.location_on),
                              onPressed: () async {
                                if (await canLaunchUrl(Uri.parse(
                                    'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(localisation)}'))) {
                                  await launchUrl(Uri.parse(
                                      'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(localisation)}'));
                                } else {
                                  print('Could not launch $localisation');
                                }
                              },
                            ),
                          ),
                        SizedBox(width: 10),

                        IconButton(
                          icon: Icon(Icons.call),
                          onPressed: () async {
                            _launchPhoneCall(phone);
                          },
                        ),
                        SizedBox(width: 10),

                        // Bouton de suppression
                        IconButton(
                          icon: Icon(Icons.sentiment_satisfied_rounded),
                          color: _isCardDeleted(index)
                              ? Colors.white
                              : Colors.black, // Changer la couleur de l'icône
                          onPressed: () {
                            setState(() {
                              // Marquer la carte comme supprimée (sans supprimer de la liste immédiatement)
                              _deletedCardIndices.add(index);
                            });
                            //_deleteUser(userId);
                          },
                        ),

                        // SizedBox(width: 10),
                        // // Bouton pour cacher l'élément sans le supprimer de la base de données
                        // IconButton(
                        //   icon: Icon(Icons.visibility_off),
                        //   onPressed: () {
                        //     _hideItem(index); // Appel pour cacher l'élément
                        //   },
                        // ),

                        SizedBox(width: 10),

                        // Bouton de suppression
                        IconButton(
                          icon: Icon(Icons.attach_money, size: 31),
                          onPressed: () {
                            // Ici, nous supprimons l'élément localement sans toucher à la base de données
                            //_showDeleteConfirmationDialog(context);
                            ;
                            deleteUserAndRelatedData(userId);

                            refreshData();
                            _hideItem(index);
                            print('bien supprimé');
                          },
                        ),
                        // Bouton de partage
/*                        IconButton(
                          icon: Icon(Icons.share),
                          onPressed: () {
                            // Partager les informations via les réseaux sociaux
                            String textToShare =
                                "Regardez cette information: \nNom: $name\nLocalisation: $localisation";
                            Share.share(
                                textToShare); // Utilisation de Share pour partager
                          },
                        ),*/
                      ],
                    ),
                    subtitle: Flexible(
                      child: Center(
                          child: Text(name, style: TextStyle(fontSize: 20))),
                      flex: 2, // Take up 2 parts of the available space
                    ),
                    children: [
                      FutureBuilder<List<Map<String, dynamic>>>(
                        // Chargement des commandes de l'utilisateur
                        future: fetchUserOrders(userId),
                        builder: (context, orderSnapshot) {
                          if (orderSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (orderSnapshot.hasError) {
                            return Center(
                                child: Text('Erreur: ${orderSnapshot.error}'));
                          }

                          final orders = orderSnapshot.data!;

                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: orders.length,
                            itemBuilder: (context, orderIndex) {
                              final order = orders[orderIndex];
                              final orderId = order['order_id'];
                              final createdAt = order['created_at'];
                              final date = DateTime.parse(createdAt).toLocal();
                              final location = order['localisation'];

                              String googleMapsUrl = location != null &&
                                      location.isNotEmpty
                                  ? 'https://www.google.com/maps?q=$location'
                                  : '';

                              return Card(
                                margin: EdgeInsets.all(5),
                                child: ExpansionTile(
                                  backgroundColor: Colors.orange,
                                  title: Text('Commande #$orderId'),
                                  subtitle: Text('Date: ${date.toString()}'),
                                  children: [
                                    FutureBuilder<List<Map<String, dynamic>>>(
                                      // Chargement des items de la commande
                                      future: fetchOrderItems(orderId),
                                      builder: (context, itemsSnapshot) {
                                        if (itemsSnapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }
                                        if (itemsSnapshot.hasError) {
                                          return Center(
                                              child: Text(
                                                  'Erreur: ${itemsSnapshot.error}'));
                                        }

                                        final items = itemsSnapshot.data!;

                                        return Column(
                                          children: [
                                            ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: items.length,
                                              itemBuilder:
                                                  (context, itemIndex) {
                                                final item = items[itemIndex];
                                                final itemName =
                                                    item['item_name'];
                                                final itemPrice =
                                                    item['item_price'];

                                                return ListTile(
                                                  title: Text(
                                                    itemName,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      // fontWeight:
                                                      //     FontWeight.bold,
                                                    ),
                                                  ),
                                                  subtitle: Text(
                                                    'Prix: DH ${itemPrice.toString()}',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 15, 14, 14),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                            // Si la localisation est disponible, afficher l'icône et le lien
                                            if (googleMapsUrl.isNotEmpty)
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    IconButton(
                                                      icon: Icon(Icons.map,
                                                          color: Colors.blue),
                                                      onPressed: () async {
                                                        if (await canLaunch(
                                                            googleMapsUrl)) {
                                                          await launch(
                                                              googleMapsUrl);
                                                        } else {
                                                          throw 'Could not launch $googleMapsUrl';
                                                        }
                                                      },
                                                    ),
                                                    Text(
                                                      'Voir sur la carte',
                                                      style: TextStyle(
                                                          color: Colors.blue),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

Future<void> deleteUserAndRelatedData(int userId) async {
  print('user id ===  $userId');
  try {
    // 1. Supprimer les éléments de commande associés à l'utilisateur
    await Supabase.instance.client
        .from('order_items')
        .delete()
        .eq('order_id', userId);

    // 2. Supprimer les commandes de l'utilisateur
    await Supabase.instance.client
        .from('orders')
        .delete()
        .eq('user_id', userId);

    // 3. Supprimer l'utilisateur
    final response = await Supabase.instance.client
        .from('users')
        .delete()
        .eq('user_id', userId);

    // if (response.error == null) {
    //   // Suppression réussie
    //   print('Utilisateur et données associées supprimés avec succès.');
    // } else {
    //   // Gestion des erreurs lors de la suppression de l'utilisateur
    //   print(
    //       'Erreur lors de la suppression de utilisateur: ${response.error!.message}');
    // }
  } catch (e) {
    // Gestion des erreurs générales
    print('Erreur lors de la suppression: $e');
  }
}

// Fonction pour récupérer les commandes d'un utilisateur
Future<List<Map<String, dynamic>>> fetchUserOrders(int userId) async {
  final response = await Supabase.instance.client
      .from('orders')
      .select(
          'order_id, created_at, localisation') // Ajouter la colonne localisation
      .eq('user_id', userId)
      .order('created_at', ascending: false)
      .select();

  return List<Map<String, dynamic>>.from(response);
}

// Fonction pour récupérer les éléments d'une commande
Future<List<Map<String, dynamic>>> fetchOrderItems(int orderId) async {
  final response = await Supabase.instance.client
      .from('order_items')
      .select('item_name, item_price')
      .eq('order_id', orderId)
      .select();

  return List<Map<String, dynamic>>.from(response);
}

Future<void> _launchPhoneCall(String phoneNumber) async {
  final url = 'tel:$phoneNumber'; // Format pour un appel téléphonique
  if (await canLaunch(url)) {
    await launch(url); // Lancer l'appel
  } else {
    throw 'Could not launch $url'; // Afficher une erreur si l'URL ne peut pas être lancée
  }
}

// Fonction void pour afficher le dialogue de confirmation
void _showDeleteConfirmationDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.money, // Icône "ops" ou alerte
              color: Colors.orange,
            ),
            SizedBox(width: 10),
            Text('Oui'),
          ],
        ),
        content: Text('Cette commande est bien payé  ?'),
        actions: <Widget>[
          TextButton(
            child: Text('Non'),
            onPressed: () {
              Navigator.of(context).pop(); // Fermer le dialogue
            },
          ),
          TextButton(
            child: Text('Supprimer'),
            onPressed: () {
              // Appeler la fonction qui supprime la commande ici
              deleteUserAndRelatedData;
              Navigator.of(context).pop(); // Fermer le dialogue après l'action
            },
          ),
        ],
      );
    },
  );
}

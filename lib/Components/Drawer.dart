import 'package:app_ecomerce/pages/IntroPage.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  // Fonction pour lancer l'URL
  Future<void> _launchURL(String url) async {
    // Vérifie si l'URL peut être lancée
    if (await canLaunch(url)) {
      await launch(url); // Ouvre l'URL dans le navigateur
    } else {
      throw 'Could not launch $url'; // Affiche une erreur si l'URL ne peut pas être lancée
    }
  }

  Future<void> _launchPhoneCall(String phoneNumber) async {
    final url = 'tel:$phoneNumber'; // Format pour un appel téléphonique
    if (await canLaunch(url)) {
      await launch(url); // Lancer l'appel
    } else {
      throw 'Could not launch $url'; // Afficher une erreur si l'URL ne peut pas être lancée
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black, // Fond du Drawer en noir
      child: Column(
        children: [
          // Logo dans le Drawer
          DrawerHeader(
            child: GestureDetector(
              // Détecte un tap sur l'image
              onTap: () {
                // Naviguer vers une nouvelle page (par exemple, `NewPage`)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          IntroPage()), // Remplacez `NewPage` par la page cible
                );
              },
              child: Image.asset(
                'lib/images/oscar.png', // Le chemin de votre image
                color: Colors
                    .orange, // Appliquer une couleur de filtre (orange ici) sur l'image
              ),
            ),
          ),

          // Section avec les options, qui occupe le reste de l'espace
          Expanded(
            child: ListView(
              children: [
                // Option 1
                ListTile(
                  leading: Icon(
                    Icons.web,
                    color: Colors.orange,
                    size: 24.0,
                  ),
                  title: GestureDetector(
                    onTap: () {
                      // Lancer l'URL ou effectuer une action
                      _launchURL('https://www.google.com');
                    },
                    child: Text(
                      'google',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.orange, // Couleur du texte
                        decoration: TextDecoration
                            .underline, // Texte souligné pour simuler un lien
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  onTap: () {
                    // Action quand l'option est tapée (en plus de l'action du lien)
                  },
                ),
                // Option 2
                ListTile(
                  leading: Icon(
                    Icons.call,
                    color: Colors.orange,
                    size: 24.0,
                  ),
                  title: GestureDetector(
                    onTap: () {
                      // Lancer l'URL ou effectuer une action
                      _launchPhoneCall('0542132547');
                    },
                    child: Text(
                      'appel',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.orange, // Couleur du texte
                        decoration: TextDecoration
                            .underline, // Texte souligné pour simuler un lien
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  onTap: () {
                    // Action pour l'option 2
                  },
                ),
              ],
            ),
          ),

          // Logout en bas
          ListTile(
            leading: Icon(
              Icons.logout_outlined,
              color: Colors.orange,
              size: 24.0,
            ),
            title: const Text(
              'Logout',
              style: TextStyle(
                fontSize: 18,
                color: Colors.orange, // Couleur du texte
              ),
              textAlign: TextAlign.center,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => IntroPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

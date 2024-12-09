import 'package:app_ecomerce/pages/Admin_page.dart';
import 'package:app_ecomerce/pages/Manage_Pages.dart';
import 'package:app_ecomerce/pages/home_page.dart';

import 'package:app_ecomerce/showdialogue/Admin/code_notifier.dart';
import 'package:app_ecomerce/showdialogue/Sur_place_form.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../showdialogue/Admin/Admin_password.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _shadowAnimation; // Animation pour l'ombre 3D

  @override
  void initState() {
    super.initState();
    // Initialiser l'animation controller avec une durée de 2 secondes
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Définir l'animation de fondu pour l'image
    _fadeInAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));

    // Définir l'animation de mise à l'échelle pour le titre
    _scaleAnimation =
        Tween<double>(begin: 0.5, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Définir l'animation de translation (mouvement du bas vers le haut pour le bouton)
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Animation pour l'ombre 3D (modification de l'intensité de l'ombre)
    _shadowAnimation =
        Tween<double>(begin: 5.0, end: 20.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Lancer l'animation dès le début
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar (commentée, à ajouter si besoin)
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animation pour l'image avec ombre 3D
              FadeTransition(
                opacity: _fadeInAnimation,
                child: AnimatedBuilder(
                  animation: _shadowAnimation,
                  builder: (context, child) {
                    return Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 250, 71, 11)
                                  .withOpacity(0.1), // Couleur de l'ombre
                              blurRadius:
                                  _shadowAnimation.value, // Taille de l'ombre
                              offset: Offset(1, 5), // Position de l'ombre
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'lib/images/bg_pizza.png', // Chemin de l'image
                          height: 200,
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(
                height: 30, // Espacement entre l'image et le texte
              ),

              // Animation pour le titre (Scale)
              ScaleTransition(
                scale: _scaleAnimation, // Animation de mise à l'échelle
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: Color.fromARGB(
                          255, 248, 248, 247), // Couleur du texte
                    ),
                    children: [
                      TextSpan(
                        text: 'We ', // Texte avant l'icône
                      ),
                      WidgetSpan(
                        child: Icon(
                          Icons.favorite, // Icône à insérer
                          color: Colors.red, // Couleur de l'icône
                          size: 28, // Taille de l'icône
                        ),
                      ),
                      TextSpan(
                        text: ' Pizza!', // Texte après l'icône
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 15,
              ),

              // Sous-titre (pas d'animation, juste texte simple)
              const Text(
                'Savourez chaque bouchée et découvrez nos recettes exclusives.',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey, // Couleur du sous-titre en gris
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(
                height: 40,
              ),

              // Animation pour le bouton (Slide Transition)
              SlideTransition(
                position: _slideAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Manage_Page()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(30), // Coins arrondis
                        ),
                      ),
                      child: const Text(
                        'Démarrer l\'Aventure Pizza !',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(
                              255, 243, 72, 4), // Couleur du texte
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),

                    // Ajouter GestureDetector en dessous du bouton
                    GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) =>
                                CodeDialog()); // Retourner votre CodeDialog ici

                        // Si vous avez l'intention d'ajouter une logique de navigation
                        // basée sur la validation du code, vous pouvez décommenter ce bloc :
                        // if (context.read<CodeNotifier>().isCodeValid == true) {
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => AdminPage(), // Remplacer par la page souhaitée
                        //     ),
                        //   );
                        // }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(
                            top: 20), // Marge entre le bouton et le texte
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        // decoration: BoxDecoration(
                        //   color: Color(0xFFFF5500), // Couleur du fond
                        //   borderRadius: BorderRadius.circular(20),
                        //   boxShadow: [
                        //     BoxShadow(
                        //       color: const Color.fromARGB(255, 30, 30, 30).withOpacity(0.3),
                        //       spreadRadius: 2,
                        //       blurRadius: 4,
                        //       offset: Offset(0, 2), // Décalage de l'ombre
                        //     ),
                        //   ],
                        // ),
                        child: const Text(
                          'Admin',
                          style: TextStyle(
                            fontSize: 10, // Taille de texte plus petite
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // Couleur du texte
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

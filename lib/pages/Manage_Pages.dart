 
import 'package:app_ecomerce/Components/Drawer.dart';
import 'package:app_ecomerce/pages/Cmd_pages.dart';
import 'package:app_ecomerce/pages/cart_total.dart';
import 'package:app_ecomerce/pages/cmd_jus_page.dart';
import 'package:app_ecomerce/pages/home_page.dart';
import 'package:app_ecomerce/pages/jus_page.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class Manage_Page extends StatefulWidget {
  Manage_Page({super.key});

  @override
  _Manage_PageState createState() => _Manage_PageState();
}

class _Manage_PageState extends State<Manage_Page> {
  // Variable pour suivre l'index sélectionné
  int _selectedIndex = 0;

  // Liste des pages
  final List _pages = [
    // Page_1 (par défaut)
    //Manage_Page(),
    // Page_2
    HomePage(),

    // Page_3
    //CartPage(),

    Jus_Page(),

    // Cart_jus_page(),

    Cart_Page_Total()
  ];

  // Fonction appelée lors de la sélection d'un item dans la BottomNavigationBar
  void nextPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //app bar

        appBar: AppBar(
          backgroundColor: Colors.black, // Couleur de l'AppBar
          elevation: 0, // Supprimer l'ombre de l'AppBar
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.orange, // Couleur de l'icône du menu
              ),
              onPressed: () {
                Scaffold.of(context)
                    .openDrawer(); // Ouvrir le Drawer lorsque l'icône est pressée
              },
            ),
          ),
          title: null, // Supprimer le titre par défaut
          centerTitle: true, // S'assurer que l'image est centrée dans l'AppBar
          flexibleSpace: Center(
            child: Image.asset(
              'lib/images/oscar.png', // Remplacez par votre chemin d'image
              height: 60, // Ajustez la taille de l'image
            ),
          ),
        ),

        // Drawer (Menu latéral)
        drawer: CustomDrawer(),
        backgroundColor: Color(0xFFFF5500),

        // scaffold
        body: _pages[_selectedIndex],

        // google nav
        bottomNavigationBar: CurvedNavigationBar(
            backgroundColor: Colors.black,
            color: Colors.deepOrange,
            animationDuration: Duration(milliseconds: 600),
            onTap: (index) {
              nextPage(index);
            },
            items: [
              Icon(
                Icons.fastfood,
                color: Colors.black,
                size: 30,
              ),
              Icon(
                Icons.local_drink,
                color: Colors.black,
                size: 30,
              ),
              Icon(
                Icons.file_copy,
                color: Colors.black,
                size: 30,
              ),
            ]));
  }
}

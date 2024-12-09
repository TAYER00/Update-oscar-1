import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


import '../main.dart';
import '../pages/HomePage.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: EdgeInsets.only(top: 100, bottom: 40),
        decoration: BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
            image: AssetImage("images/bg.png"),
            fit: BoxFit.cover,
            opacity: 0.6,

          ), // DecorationImage
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Coffee Shop",
              style: GoogleFonts.pacifico(
                fontSize: 50,
                color: Colors.white,
              ), // GoogleFonts.pacifico
            ), // Text
            Column(
              children: [
                Text(
                  "Feeling Low? Take a Sip of Coffee",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1,
                  ), // TextStyle
                ), // Text
                SizedBox(height: 80),
                Material(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(

                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(),),);
                    }, // onTap
                    child: Container(
                      child: Ink(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                          decoration: BoxDecoration(
                            color: Color(0xFFE57734),
                            borderRadius: BorderRadius.circular(10),
                          ), // BoxDecoration
                          child: Text("Let's drink coffee",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                          ),
                        ),
                      ),
                    ), // Container
                  ),
                ), // InkWell
              ], // children
            ), // Column
          ], // children
        ), // Column
        // BoxDecoration
      ), // Container
    ); // Material
  }
}

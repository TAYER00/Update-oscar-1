import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'code_notifier.dart'; // Import the notifier
import 'package:app_ecomerce/pages/Admin_page.dart';

class CodeDialog extends StatefulWidget {
  @override
  _CodeDialogState createState() => _CodeDialogState();
}

class _CodeDialogState extends State<CodeDialog> {
  final TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<CodeNotifier>(
      builder: (context, codeNotifier, child) {
        return AlertDialog(
          title: const Text('Oui Chef'),
          content: TextField(
            controller: _codeController,
            decoration: InputDecoration(
              hintText: 'Entrez un code de 4 chiffres',
              errorText: codeNotifier.isValid ? null : 'Le code doit être composé de 4 chiffres',
            ),
            keyboardType: TextInputType.number,
            maxLength: 4, // Limite la saisie à 4 chiffres
            onChanged: (value) {
              codeNotifier.setCode(value);
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer le dialogue
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                codeNotifier.submitCode();
                if (codeNotifier.isCodeValid) {
                  _handleCodeSubmission(context);
                } else {
                  // Afficher un message d'erreur si le code est incorrect
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Le code est incorrect ou invalide')),
                  );
                }
              },
              child: const Text('Valider'),
            ),
          ],
        );
      },
    );
  }

  void _handleCodeSubmission(BuildContext context) {
    final code = context.read<CodeNotifier>().code;
    print('Code validé: $code');


    Navigator.of(context).pop();
    
     // Fermer le dialogue
                              Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdminPage(), // Remplacer par la page souhaitée
                            ),
                          );
  }
}

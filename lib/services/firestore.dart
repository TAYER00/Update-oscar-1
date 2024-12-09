import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference coffe_shop =
  FirebaseFirestore.instance.collection('coffe_shop');





  // CREATE: ajouter une nouvelle note
  // Ajouter une nouvelle note avec plusieurs champs
  Future<void> addNote(String productName, String quantity, String totalPrice, String location, String phoneNumber) async {
    await coffe_shop.add({
      'productName': productName,
      'quantity': quantity,

      'totalPrice': totalPrice,
      'timestamp': Timestamp.now(),
      'location': location,
      'phoneNumber':phoneNumber
    });
  }





  // READ: obtenir toutes les coffe_shop
  Future<List<DocumentSnapshot>> getNotes() async {
    QuerySnapshot querySnapshot = await coffe_shop.get();
    return querySnapshot.docs;
  }


  Stream<QuerySnapshot> getNotesStream() {
    return coffe_shop.snapshots();
  }




  // UPDATE: mettre à jour une note donnée son ID
// UPDATE: mettre à jour une note donnée son ID
  Future<void> updateNote(String docId, String? updatedProductName, String? updatedQuantity, String? updatedTotalPrice) async {
    // Mettre à jour seulement les champs non nuls
    Map<String, dynamic> updateData = {};
    if (updatedProductName != null) {
      updateData['productName'] = updatedProductName;
    }
    if (updatedQuantity != null) {
      updateData['quantity'] = updatedQuantity;
    }
    if (updatedTotalPrice != null) {
      updateData['totalPrice'] = updatedTotalPrice;
    }

    updateData['timestamp'] = Timestamp.now();

    await coffe_shop.doc(docId).update(updateData);
  }


  // DELETE: supprimer une note donnée son ID
// DELETE: supprimer une note donnée son ID
  Future<void> deleteNote(String docId) async {
    await coffe_shop.doc(docId).delete();
  }









}

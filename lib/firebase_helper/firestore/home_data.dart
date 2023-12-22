import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeDataFirestore {
  Future addUserDetail(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .set(userInfoMap);
  }

  Future<Stream<QuerySnapshot>> getProduct(String category) async {
    return FirebaseFirestore.instance
        .collection('innovations')
        .where('category', isEqualTo: category)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getAllProducts() async {
    return FirebaseFirestore.instance.collection('innovations').snapshots();
  }

  Future<Stream<QuerySnapshot>> getCartItems(User? user) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: user!.email)
        .get();
    if (snapshot.docs.isNotEmpty) {
      String ref = snapshot.docs.first.reference.id;
      return await FirebaseFirestore.instance
          .collection('users')
          .doc(ref)
          .collection('cart')
          .snapshots();
    } else {
      return const Stream.empty();
    }
  }
}

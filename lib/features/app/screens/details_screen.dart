import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:market_app/constants/styles/text_widget.dart';
import 'package:market_app/features/app/widgets/payment.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({
    super.key,
    required this.image,
    required this.name,
    required this.description,
    required this.category,
    required this.quantity,
    required this.price,
  });

  final String image;
  final String name;
  final String description;
  final String category;
  final double quantity;
  final double price;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  int count = 1;
  String? email = FirebaseAuth.instance.currentUser?.email;
  Future<void> addToCart() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    if (snapshot.docs.isNotEmpty) {
      String ref = snapshot.docs.first.reference.id;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(ref)
          .collection('cart')
          .add({
        "image": widget.image,
        "name": widget.name,
        "quantity": count,
        "total": (widget.price * count)
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Product added to cart"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(
                left: 20.0,
                top: 50.0,
                right: 20.0,
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  widget.image,
                  width: 300,
                  height: 300,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Text(widget.name, style: AppWidget.headLineTextFieldStyle()),
                const Spacer(),
                const Icon(
                  Icons.currency_rupee,
                ),
                Text(
                  widget.price.toString(),
                  style: AppWidget.headLineTextFieldStyle(),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              widget.description,
              style: AppWidget.lightHeadingTextFieldStyle(),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  "Product made of : ",
                  style: AppWidget.semiBoldTextFieldStyle(),
                ),
                Text(
                  widget.category,
                  style: AppWidget.lightHeadingTextFieldStyle(),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  widget.quantity.toString(),
                  style: AppWidget.semiBoldTextFieldStyle(),
                ),
                Text(
                  ' items left in stock',
                  style: AppWidget.lightHeadingTextFieldStyle(),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Spacer(),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return PaymentScreen(
                          amount: widget.price, title: widget.name);
                    }));
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black,
                    fixedSize: const Size(200, 50),
                  ),
                  child: const Text(
                    "Buy Now",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    addToCart();
                  },
                  child: Row(
                    children: [
                      Text(
                        "Add to cart",
                        style: AppWidget.boldTextFieldStyle(),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Icon(
                        Icons.shopping_cart,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

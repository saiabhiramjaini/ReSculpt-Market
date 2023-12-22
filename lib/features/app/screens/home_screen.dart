import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:market_app/constants/styles/text_widget.dart';
import 'package:market_app/features/app/screens/details_screen.dart';

import 'package:market_app/features/app/widgets/bottom_nav.dart';
import 'package:market_app/features/app/widgets/loading.dart';
import 'package:market_app/firebase_helper/firestore/home_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool plastic = false;
  bool glass = false;
  bool cloth = false;
  bool wood = false;

  Stream? itemStream;

  String uname = '';

  onTheLoad() async {
    itemStream = await HomeDataFirestore().getAllProducts();
    retrieveUname();
  }

  Future<void> retrieveUname() async {
    // Get the current user's email from FirebaseAuth
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      // Handle the case when the user is not authenticated
      return;
    }

    try {
      QuerySnapshot userDocs = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: currentUser.email)
          .get();

      // Check if any documents match the query
      if (userDocs.docs.isNotEmpty) {
        // Retrieve the 'uname' field from the first document
        String retrievedUname = userDocs.docs[0]['uname'];

        // Update the state to trigger a rebuild with the retrieved 'uname'
        setState(() {
          uname = retrievedUname;
        });
      } else {
        //print("No user document found with email ${currentUser.email}");
      }
    } catch (e) {
      //print("Error retrieving data: $e");
    }
  }

  @override
  void initState() {
    onTheLoad();
    super.initState();
  }

  Widget allItemsVertically() {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 1.6,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder(
        stream: itemStream,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loading();
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading data'));
          } else if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
            return const Center(child: Text('No items available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                DocumentSnapshot ds = snapshot.data.docs[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return DetailsScreen(
                            image: ds['image'],
                            name: ds['name'],
                            description: ds['description'],
                            category: ds['category'],
                            price: ds['price'],
                            quantity: ds['quantity'],
                          );
                        },
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            margin: const EdgeInsets.only(right: 5),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                      ds['image'],
                                      height: 150,
                                      width: 150,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 25,
                                      ),
                                      Text(
                                        ds['name'],
                                        style:
                                            AppWidget.semiBoldTextFieldStyle(),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      SizedBox(
                                        width: 150,
                                        child: Text(
                                          ds['description'],
                                          style:
                                              AppWidget.lightTextFieldStyle(),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Price : ",
                                            style: AppWidget
                                                .semiBoldTextFieldStyle(),
                                          ),
                                          Text(
                                            ds['price'].toString(),
                                            style: AppWidget
                                                .lightHeadingTextFieldStyle(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 50.0, left: 20.0, right: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Hello $uname,",
                  style: AppWidget.boldTextFieldStyle(),
                ),
                GestureDetector(
                  onTap: () {
                    // Reload the page here
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const BottomNav(),
                      ),
                    );
                  },
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(
                      Icons.replay_outlined,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              "Innovative Products",
              style: AppWidget.headLineTextFieldStyle(),
            ),
            Text(
              "Expereince the new gen best out of waste products",
              style: AppWidget.lightTextFieldStyle(),
            ),
            const SizedBox(
              height: 20,
            ),
            showCategory(),
            const SizedBox(
              height: 20,
            ),
            allItemsVertically(),
          ],
        ),
      ),
    );
  }

  // widget to show category of products
  Widget showCategory() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () async {
            plastic = true;
            glass = false;
            cloth = false;
            wood = false;
            itemStream = await HomeDataFirestore().getProduct("Plastic");
            setState(() {});
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                color: plastic ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/images/plastic.png',
                  height: 40,
                  width: 40,
                  color: plastic ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            plastic = false;
            glass = true;
            cloth = false;
            wood = false;
            itemStream = await HomeDataFirestore().getProduct("Glass");
            setState(() {});
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                color: glass ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/images/glass.png',
                  height: 40,
                  width: 40,
                  color: glass ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            plastic = false;
            glass = false;
            cloth = true;
            wood = false;
            itemStream = await HomeDataFirestore().getProduct("Fabric");
            setState(() {});
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                color: cloth ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/images/clothes.png',
                  height: 40,
                  width: 40,
                  color: cloth ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            plastic = false;
            glass = false;
            cloth = false;
            wood = true;
            itemStream = await HomeDataFirestore().getProduct("Wood");
            setState(() {});
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                color: wood ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/images/wood.png',
                  height: 40,
                  width: 40,
                  color: wood ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

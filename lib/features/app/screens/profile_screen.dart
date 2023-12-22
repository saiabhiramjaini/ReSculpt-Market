// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:market_app/constants/styles/text_widget.dart';
import 'package:market_app/features/auth/screens/signup_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String uname = '';
  String? email = FirebaseAuth.instance.currentUser!.email;

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

  Future<void> signOutUser() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const SignupScreen(),
        ),
      );
      //print("Sign out successful!");
    } catch (e) {
      //print("An unexpected error occurred during sign-out. Error: $e");
    }
  }

  // Future<void> deleteCart() async{

  // }
  Future<void> deleteAccount() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? currentUser = auth.currentUser;

    if (currentUser != null) {
      // Step 1: Delete the 'cart' subcollection
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('cart')
          .get()
          .then((QuerySnapshot querySnapshot) {
        for (var doc in querySnapshot.docs) {
          doc.reference.delete();
        }
      });

      // Step 2: Delete the user document from 'users' collection
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .delete();

      // Step 3: Delete user from Firebase Authentication
      await currentUser.delete();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const SignupScreen(),
        ),
      );
    } else {
      // Handle the case where the current user is null (not signed in)
      //print('User is not signed in.');
    }
  }

  @override
  void initState() {
    super.initState();
    retrieveUname();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Stack(
          children: [
            Container(
              padding:
                  const EdgeInsets.only(top: 45.0, left: 20.0, right: 20.0),
              height: MediaQuery.of(context).size.height / 4.3,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.vertical(
                      bottom: Radius.elliptical(
                          MediaQuery.of(context).size.width, 105.0))),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 6.5),
                child: Material(
                  elevation: 10.0,
                  borderRadius: BorderRadius.circular(60),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: const SizedBox(
                        height: 100, width: 100, child: Icon(Icons.person)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 70.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    uname,
                    style: AppWidget.boldTextFieldStyle(),
                  )
                ],
              ),
            )
          ],
        ),
        const SizedBox(
          height: 20.0,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Material(
            borderRadius: BorderRadius.circular(10),
            elevation: 2.0,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Row(children: [
                const Icon(Icons.person, color: Colors.black),
                const SizedBox(
                  width: 20.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Name",
                      style: AppWidget.semiBoldTextFieldStyle(),
                    ),
                    Text(
                      uname,
                      style: AppWidget.semiBoldTextFieldStyle(),
                    )
                  ],
                )
              ]),
            ),
          ),
        ),
        const SizedBox(
          height: 20.0,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Material(
            borderRadius: BorderRadius.circular(10),
            elevation: 2.0,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Row(children: [
                const Icon(Icons.email, color: Colors.black),
                const SizedBox(
                  width: 20.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Email",
                      style: AppWidget.semiBoldTextFieldStyle(),
                    ),
                    Text(
                      email!,
                      style: AppWidget.semiBoldTextFieldStyle(),
                    )
                  ],
                )
              ]),
            ),
          ),
        ),
        const SizedBox(
          height: 20.0,
        ),
        // GestureDetector(
        //   onTap: () {
        //     deleteAccount();
        //   },
        //   child: Container(
        //     margin: const EdgeInsets.symmetric(horizontal: 20.0),
        //     child: Material(
        //       borderRadius: BorderRadius.circular(10),
        //       elevation: 2.0,
        //       child: Container(
        //         padding: const EdgeInsets.symmetric(
        //             vertical: 15.0, horizontal: 10.0),
        //         decoration: BoxDecoration(
        //             color: Colors.white,
        //             borderRadius: BorderRadius.circular(10)),
        //         child: Row(
        //           children: [
        //             const Icon(Icons.delete, color: Colors.black),
        //             const SizedBox(
        //               width: 20.0,
        //             ),
        //             Column(
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               children: [
        //                 Text(
        //                   "Delete Account",
        //                   style: AppWidget.semiBoldTextFieldStyle(),
        //                 ),
        //               ],
        //             )
        //           ],
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        // const SizedBox(
        //   height: 20.0,
        // ),
        GestureDetector(
          onTap: () {
            signOutUser();
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Material(
              borderRadius: BorderRadius.circular(10),
              elevation: 2.0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 10.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    const Icon(Icons.logout, color: Colors.black),
                    const SizedBox(
                      width: 20.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Logout",
                          style: AppWidget.semiBoldTextFieldStyle(),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      ]),
    );
  }
}

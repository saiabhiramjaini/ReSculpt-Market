import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:market_app/constants/styles/text_widget.dart';
import 'package:market_app/features/auth/screens/signin_screen.dart';
import 'package:market_app/features/auth/screens/verify_email_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cpasswordController = TextEditingController();

  void showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text(
                'OK',
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _cpasswordController.dispose();
    super.dispose();
  }

  void registerUser() async {
    final uname = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final cpassword = _cpasswordController.text.trim();

    Future<void> addUserDetails(String username, String email) async {
      try {
        User? user = FirebaseAuth.instance.currentUser;
        // final List<String> chattedWith = [];
        // final List<String> cartProdIds = [];

        if (user != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            "uname": username,
            "email": email,
            "uid": user.uid,
            // "cartProdIds": cartProdIds,
            // "chattedWith": chattedWith,
          });
        } else {
          // Handle the case where user is null (not signed in)
          //print("User is not signed in");
        }
      } catch (e) {
        //print("Error adding user details: $e");
        // Handle the error as needed
      }
    }

    if (uname.isNotEmpty &&
        email.isNotEmpty &&
        password == cpassword &&
        password.length >= 8) {
      setState(() {});
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        addUserDetails(
          uname,
          email,
        );
        //Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const VerifyEmail(),
          ),
        );

        _usernameController.clear();
        _emailController.clear();
        _passwordController.clear();
        _cpasswordController.clear();
      } on FirebaseAuthException catch (e) {
        showAlertDialog(context, "Invalid Input", e.code);
      } catch (e) {
        //print("something bad happened");
        //print(e.runtimeType); //this will give the type of exception that occured
        //print(e);
      } finally {
        setState(() {});
      }
    } else if (uname.isEmpty) {
      showAlertDialog(context, "Invalid Input", "please enter username");
    } else if (email.isEmpty) {
      showAlertDialog(context, "Invalid Input", "please enter your email");
    } else if (!email.contains('@')) {
      showAlertDialog(context, "Invalid Input", "please enter correct email");
    } else if (!email.contains('@')) {
      showAlertDialog(context, "Invalid Input", "please enter correct email");
    } else if (password.isEmpty) {
      showAlertDialog(context, "Invalid Input", "please enter password");
    } else if (password.length < 8) {
      showAlertDialog(context, "Invalid Input",
          "password length must be minimum of 8 characters");
    } else if (password != cpassword) {
      showAlertDialog(context, "Invalid Input",
          "password and confirm password are not same");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2.5,
                decoration: const BoxDecoration(color: Color(0xFF000000)),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 3),
                height: MediaQuery.of(context).size.height / 3,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30)),
              ),
              Container(
                margin: const EdgeInsets.only(top: 60, left: 40, right: 40),
                child: Column(children: [
                  Center(
                    child: Lottie.asset(
                      'assets/lottie/signup.json',
                      height: 150,
                      width: 150,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Material(
                    elevation: 5.0,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 1.5,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            Text(
                              "Signup",
                              style: AppWidget.semiBoldTextFieldStyle(),
                            ),
                            TextField(
                              controller: _usernameController,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                hintText: 'Username',
                                hintStyle: AppWidget.semiBoldTextFieldStyle(),
                                prefixIcon: const Icon(Icons.person_2_outlined),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextField(
                              controller: _emailController,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                hintText: 'Email',
                                hintStyle: AppWidget.semiBoldTextFieldStyle(),
                                prefixIcon: const Icon(Icons.email_outlined),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                hintText: 'Password',
                                hintStyle: AppWidget.semiBoldTextFieldStyle(),
                                prefixIcon: const Icon(Icons.key),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextField(
                              controller: _cpasswordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                hintText: 'Confirm Password',
                                hintStyle: AppWidget.semiBoldTextFieldStyle(),
                                prefixIcon: const Icon(Icons.key),
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                registerUser();
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.black,
                                fixedSize: const Size(150, 50),
                              ),
                              child: const Text(
                                "Signup",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Text(
                              "Already have an account ?",
                              style: AppWidget.lightTextFieldStyle(),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return const SigninScreen();
                                    },
                                  ),
                                );
                              },
                              child: Text("Login",
                                  style: AppWidget.semiBoldTextFieldStyle()),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}

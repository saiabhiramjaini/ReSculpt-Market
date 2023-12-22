import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:market_app/constants/styles/text_widget.dart';
import 'package:market_app/features/app/widgets/bottom_nav.dart';
import 'package:market_app/features/auth/screens/forgot_password_screen.dart';
import 'package:market_app/features/auth/screens/signup_screen.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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

  void signinUser() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (email.isNotEmpty && password.isNotEmpty) {
      setState(() {});

      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        //Navigator.of(context).pop();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const BottomNav(),
          ),
        );

        _emailController.clear();
        _passwordController.clear();
      } on FirebaseAuthException catch (e) {
        showAlertDialog(context, "Invalid Input", e.code);
      } catch (e) {
        // print("something bad happened");
        // print(e
        //     .runtimeType); //this will give the type of exception that occured
        // print(e);
      } finally {
        setState(() {});
      }
    } else if (email.isEmpty) {
      showAlertDialog(context, "Invalid Input", "please enter email");
    } else if (password.isEmpty) {
      showAlertDialog(context, "Invalid Input", "please enter password");
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
                height: MediaQuery.of(context).size.height / 2,
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
                      'assets/lottie/signin.json',
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
                      height: MediaQuery.of(context).size.height / 2,
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
                              "Login",
                              style: AppWidget.semiBoldTextFieldStyle(),
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
                            Container(
                                alignment: Alignment.topRight,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return const ForgotPasswordScreen();
                                        },
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Forgot Password",
                                    style:
                                        AppWidget.lightHeadingTextFieldStyle(),
                                  ),
                                )),
                            const SizedBox(
                              height: 30,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                signinUser();
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.black,
                                fixedSize: const Size(150, 50),
                              ),
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Don't have an account ?",
                              style: AppWidget.lightTextFieldStyle(),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return const SignupScreen();
                                    },
                                  ),
                                );
                              },
                              child: Text("Create Account",
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

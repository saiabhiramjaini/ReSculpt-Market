import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:market_app/features/app/widgets/bottom_nav.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  bool isVerified = false;
  Timer? timer;

  Future<void> sendVerificationEmail() async {
    final user = FirebaseAuth.instance.currentUser!;
    await user.sendEmailVerification();
  }

  Future<void> checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isVerified) {
      timer?.cancel();
      // Navigate to the '/account' route after email verification
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const BottomNav(),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    isVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isVerified) {
      sendVerificationEmail();

      if (timer == null || !timer!.isActive) {
        timer = Timer.periodic(const Duration(seconds: 3), (_) {
          checkEmailVerified();
        });
      }
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isVerified
            ? const Text(
                "Email verified",
                style: TextStyle(
                  fontSize: 40,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w600,
                ),
              )
            : Container(
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Email verification",
                      style: TextStyle(
                        fontSize: 30,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Lottie.asset(
                      'assets/lottie/verifyemail.json',
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Kindly check your email inbox for a verification message we've sent. Please click on the provided link to confirm your account. If you don't see the email in your inbox, be sure to check your spam folder.",
                      style: TextStyle(fontSize: 15),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: sendVerificationEmail,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                        fixedSize: const Size(150, 50),
                      ),
                      child: const Row(
                        children: [
                          Text(
                            "Resend Link",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

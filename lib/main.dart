import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:market_app/features/app/widgets/bottom_nav.dart';
import 'package:market_app/features/app/widgets/loading.dart';
import 'package:market_app/features/auth/screens/signup_screen.dart';
import 'package:market_app/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<void> initializeFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initializeFirebase(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Loading indicator or splash screen while checking auth state.
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  home: const Loading(),
                  theme: ThemeData(
                    colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
                    useMaterial3: true,
                  ),
                );
              }
              if (snapshot.hasData) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  home: const BottomNav(),
                  theme: ThemeData(
                    colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
                    useMaterial3: true,
                  ),
                );
              } else {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  home: const SignupScreen(),
                  theme: ThemeData(
                    colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
                    useMaterial3: true,
                  ),
                );
              }
            },
          );
        }
        // Loading indicator or splash screen while initializing Firebase.
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const Loading(),
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
            useMaterial3: true,
          ),
        );
      },
    );
  }
}

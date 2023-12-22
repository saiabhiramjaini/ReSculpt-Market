import 'package:flutter/material.dart';

class AppWidget {
  static TextStyle boldTextFieldStyle() {
    return const TextStyle(
      color: Colors.black,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      fontFamily: 'Poppins',
    );
  }

  static TextStyle semiBoldTextFieldStyle() {
    return const TextStyle(
      color: Colors.black,
      fontSize: 18.0,
      fontWeight: FontWeight.w500,
      fontFamily: 'Poppins',
    );
  }

  static TextStyle headLineTextFieldStyle() {
    return const TextStyle(
      color: Colors.black,
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
      fontFamily: 'Poppins',
    );
  }

  static TextStyle subHeadLineTextFieldStyle() {
    return const TextStyle(
      color: Colors.black,
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
      fontFamily: 'Poppins',
    );
  }

  static TextStyle lightHeadingTextFieldStyle() {
    return const TextStyle(
      color: Colors.black38,
      fontSize: 18.0,
      fontWeight: FontWeight.w500,
      fontFamily: 'Poppins',
    );
  }

  static TextStyle lightTextFieldStyle() {
    return const TextStyle(
      color: Colors.black38,
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      fontFamily: 'Poppins',
    );
  }
}

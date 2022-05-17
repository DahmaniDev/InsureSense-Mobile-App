import 'package:flutter/material.dart';
import 'package:insuresense/screens/login.dart';

AppBar myAppBar(BuildContext context) {
  return AppBar(
    title: const Text(
      'InsureSense',
    ),
    backgroundColor: Color(0xFF61c29b),
    elevation: 8.0,
    actions: [
      //Button de Logout
      InkWell(
        onTap: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const Signin()));
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const Icon(Icons.exit_to_app_rounded),
        ),
      )
    ],
  );
}

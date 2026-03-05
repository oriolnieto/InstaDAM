import 'package:flutter/material.dart';
import 'dart:async';
import 'login.dart';

class LoadScreen extends StatefulWidget {
  const LoadScreen({Key? key}) : super(key: key);

  @override
  State<LoadScreen> createState() => _LoadScreenState();
}

class _LoadScreenState extends State<LoadScreen> {

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () { // No se com fer que carregui de forma correcta, aixi que fem que esperi 3 segons (simulació)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const login()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Semantics(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logoApp.png',
                height: 300,
                width: 300,
                semanticLabel: 'Logo de InstaDAM',
              ),

              const SizedBox(height: 30),

              const Text(
                'Se esta cargando InstaDAM..',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
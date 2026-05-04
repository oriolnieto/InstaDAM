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

    Future.delayed(const Duration(seconds: 3), () {
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
          // 🔥 CLAU per TalkBack
          label: 'InstaDAM. L\'aplicació s\'està carregant',
          liveRegion: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // 🖼 Logo
              ExcludeSemantics(
                child: Image.asset(
                  'assets/logoApp.png',
                  height: 300,
                  width: 300,
                ),
              ),

              const SizedBox(height: 30),

              // 📝 Text visual (no cal duplicar lectura)
              ExcludeSemantics(
                child: Text(
                  'S\'està carregant InstaDAM...',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
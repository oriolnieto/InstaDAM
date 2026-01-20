import 'package:flutter/material.dart';
import 'feed.dart';


void main() {
  runApp(const createPost());
}

class createPost extends StatelessWidget {
  const createPost({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: home(),
    );
  }
}

class home extends StatelessWidget {
  const home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text(
          'createPost',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
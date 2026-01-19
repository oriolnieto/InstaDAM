import 'package:flutter/material.dart';

void main() {
  runApp(const Feed());
}

class Feed extends StatelessWidget {
  const Feed({super.key});

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
    return const Scaffold(
      body: Center(
        child: Text(
          'Feed',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
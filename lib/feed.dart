import 'package:flutter/material.dart';
import 'profile.dart';
import 'feed.dart';
import 'createPost.dart';
import 'package:sqflite/sqflite.dart';
import 'db.dart';


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

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();

  }

  class _homeState extends State<home> {
    List<Map<String, dynamic>> posts = [];

    @override
    void initState() {
      super.initState();
      _loadFeed();
    }

    Future<void> _loadFeed() async {
      final data = await db.getPosts();
      setState(() {
        posts = data;
    });
  }

  @override
  Widget build (BuildContext context) {
      return Container();
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text(
          'Home',
          style: TextStyle(fontSize: 24),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => createPost()),
          );
        },
        child: const Icon(Icons.add),
      ),

      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => Feed()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => profile()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

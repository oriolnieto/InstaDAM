import 'package:flutter/material.dart';
import 'profile.dart';
import 'createPost.dart';
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
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: posts.isEmpty
          ? const Center(
        child: Text(
          'No hi ha posts recents',
          style: TextStyle(fontSize: 24),
        ),
      )
          : ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];

          return Card(
            margin:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Usuari + data
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        post['user'] ?? 'Usuari',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        post['fecha'] ?? '',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.favorite),
                        onPressed: () async {
                          await db.like(post['id']);

                          final updatedPost = (await db.getPosts())
                              .firstWhere((p) => p['id'] == post['id']);

                          setState(() {
                            post['likes'] = updatedPost['likes'];
                          });
                        },
                      ),
                      Text('${post['likes']}'),
                    ],
                  ),
                ),

                // Imatge
                if (post['rutaImagen'] != null &&
                    post['rutaImagen'].toString().isNotEmpty)
                  Image.asset(
                    post['rutaImagen'],
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        'Imatge no trobada',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),

                // Descripció
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    post['desc'] ?? '',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          );
        },
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
              onPressed: _loadFeed,
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
}

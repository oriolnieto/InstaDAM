import 'package:flutter/material.dart';
import 'profile.dart';
import 'createPost.dart';
import 'db.dart';
import 'comentaris.dart';

class Feed extends StatelessWidget {
  const Feed({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomePage();
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
    final theme = Theme.of(context);

    return Scaffold(
      body: posts.isEmpty
          ? Center(
        child: Text(
          'Sin posts recientes.',
          style: theme.textTheme.headlineSmall,
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
                // Usuario + fecha + acciones
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Text(
                        post['user'] ?? 'Usuari',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        post['fecha'] ?? '',
                        style: theme.textTheme.bodySmall,
                      ),
                      const Spacer(),

                      // LIKES
                      IconButton(
                        icon: const Icon(Icons.favorite),
                        onPressed: () async {
                          await db.like(post['id']);
                          final data = await db.getPosts();
                          setState(() {
                            posts = data;
                          });
                        },
                      ),
                      Text('${post['likes'] ?? 0}'),

                      const SizedBox(width: 10),

                      // COMENTARIOS
                      IconButton(
                        icon: const Icon(Icons.comment),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  CommentsPage(idPost: post['id']),
                            ),
                          );
                          await _loadFeed();
                        },
                      ),
                      Text('${post['comentarios'] ?? 0}'),
                    ],
                  ),
                ),

                // Imagen
                if (post['rutaImagen'] != null &&
                    post['rutaImagen'].toString().isNotEmpty)
                  Image.asset(
                    post['rutaImagen'],
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('Imatge no trobada'),
                    ),
                  ),

                // Descripción
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    post['desc'] ?? '',
                    style: theme.textTheme.bodyMedium,
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
                  MaterialPageRoute(builder: (_) => const profile()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

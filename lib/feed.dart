import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
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
          'Sense posts recents.',
          style: theme.textTheme.headlineSmall,
        ),
      )
          : ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];

          final String author = post['user'] ?? 'Usuari';
          final String date = post['fecha'] ?? '';
          final String desc = post['desc'] ?? '';
          final int likes = post['likes'] ?? 0;
          final int comments = post['comentarios'] ?? 0;
          final bool isLiked = post['isLiked'] == true;

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  label: 'Post de $author, data: $date. Text: $desc',
                  excludeSemantics: true,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(author, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(width: 10),
                            Text(date, style: theme.textTheme.bodySmall),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(desc, style: theme.textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ),

                if (post['rutaImagen'] != null && post['rutaImagen'].toString().isNotEmpty)
                  Image.asset(
                    post['rutaImagen'],
                    fit: BoxFit.cover,
                    semanticLabel: 'Imatge adjunta',
                  ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Semantics(
                        button: true,
                        toggled: isLiked,
                        label: "M'agrada. ${isLiked ? 'Activat' : 'Desactivat'}. $likes likes.",
                        onTapHint: isLiked ? "Treure m'agrada" : "Donar m'agrada",
                        child: IconButton(
                          icon: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            color: isLiked ? Colors.red : null,
                          ),
                          onPressed: () async {
                            await db.like(post['id']);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(isLiked ? "Has tret el m'agrada" : "Has donat m'agrada"),
                                ),
                              );
                            }
                            await _loadFeed();
                          },
                        ),
                      ),
                      ExcludeSemantics(child: Text('$likes')),

                      const SizedBox(width: 20),

                      Semantics(
                        button: true,
                        label: "Anar a comentaris. Hi ha $comments.",
                        onTapHint: "Obrir secció de comentaris",
                        child: IconButton(
                          icon: const Icon(Icons.comment),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => CommentsPage(idPost: post['id'])),
                            );
                            await _loadFeed();
                          },
                        ),
                      ),
                      ExcludeSemantics(child: Text('$comments')),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: Semantics(
        label: 'Crear nova publicació',
        button: true,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => CreatePostPage()));
          },
          child: const Icon(Icons.add),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Semantics(
              label: 'Inici',
              button: true,
              child: IconButton(icon: const Icon(Icons.home), onPressed: _loadFeed),
            ),
            Semantics(
              label: 'Perfil',
              button: true,
              child: IconButton(
                icon: const Icon(Icons.person),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const Profile())),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
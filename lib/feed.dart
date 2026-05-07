import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'profile.dart';
import 'createPost.dart';
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

  Future<String> _getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('currentUser') ?? 'Usuari';
  }

  // ❤️ LIKE / UNLIKE
  Future<void> toggleLike(String postId) async {
    final user = await _getCurrentUser();
    final postRef = FirebaseFirestore.instance.collection('posts').doc(postId);
    final likeRef = postRef.collection('likes').doc(user);

    final doc = await likeRef.get();

    if (doc.exists) {
      await likeRef.delete();
      await postRef.update({
        'likesCount': FieldValue.increment(-1),
      });
    } else {
      await likeRef.set({'user': user});
      await postRef.update({
        'likesCount': FieldValue.increment(1),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('fecha', descending: true)
            .snapshots(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final posts = snapshot.data!.docs;

          if (posts.isEmpty) {
            return Center(
              child: Text(
                'Sense posts recents.',
                style: theme.textTheme.headlineSmall,
              ),
            );
          }

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              final data = post.data() as Map<String, dynamic>;

              final String author = data['user'] ?? 'Usuari';
              final String date = data['fecha'] is Timestamp
                  ? (data['fecha'] as Timestamp).toDate().toString().split(' ')[0]
                  : data['fecha'].toString();
              final String desc = data['desc'] ?? '';
              final int likes = data['likes'] ?? 0;

              return FutureBuilder<String>(
                future: _getCurrentUser(),
                builder: (context, userSnapshot) {

                  if (!userSnapshot.hasData) {
                    return const SizedBox();
                  }

                  final currentUser = userSnapshot.data!;

                  return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('posts')
                        .doc(post.id)
                        .collection('likes')
                        .doc(currentUser)
                        .get(),
                    builder: (context, likeSnapshot) {

                      final bool isLiked =
                          likeSnapshot.data?.exists ?? false;

                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            // 🔹 CONTINGUT POST (ACCESSIBLE)
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
                                        Text(author,
                                            style: theme.textTheme.bodyLarge?.copyWith(
                                                fontWeight: FontWeight.bold)),
                                        const SizedBox(width: 10),
                                        Text(date,
                                            style: theme.textTheme.bodySmall),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(desc,
                                        style: theme.textTheme.bodyMedium),
                                  ],
                                ),
                              ),
                            ),

                            // 🖼 IMATGE
                            if (data['rutaImagen'] != null &&
                                data['rutaImagen'].toString().isNotEmpty)
                              Image.asset(
                                data['rutaImagen'],
                                fit: BoxFit.cover,
                                semanticLabel: 'Imatge adjunta',
                              ),

                            // 🔹 ACCIONS
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [

                                  // ❤️ LIKE
                                  Semantics(
                                    button: true,
                                    toggled: isLiked,
                                    label: "M'agrada. ${isLiked ? 'Activat' : 'Desactivat'}. $likes likes.",
                                    onTapHint: isLiked
                                        ? "Treure m'agrada"
                                        : "Donar m'agrada",
                                    child: IconButton(
                                      icon: Icon(
                                        isLiked
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: isLiked ? Colors.red : null,
                                      ),
                                      onPressed: () async {
                                        await toggleLike(post.id);

                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  isLiked
                                                      ? "Has tret el m'agrada"
                                                      : "Has donat m'agrada"),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),

                                  ExcludeSemantics(child: Text('$likes')),

                                  const SizedBox(width: 20),

                                  // 💬 COMENTARIS
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('posts')
                                        .doc(post.id)
                                        .collection('comentarios')
                                        .snapshots(),
                                    builder: (context, commentSnapshot) {

                                      final int comments =
                                          commentSnapshot.data?.docs.length ?? 0;

                                      return Row(
                                        children: [
                                          Semantics(
                                            button: true,
                                            label:
                                            "Anar a comentaris. Hi ha $comments.",
                                            onTapHint:
                                            "Obrir secció de comentaris",
                                            child: IconButton(
                                              icon: const Icon(Icons.comment),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) => CommentsPage(
                                                        idPost: post.id),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          ExcludeSemantics(child: Text('$comments')),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),

      // ➕ CREAR POST
      floatingActionButton: Semantics(
        label: 'Crear nova publicació',
        button: true,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CreatePostPage()),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),

      // 🔻 NAV BAR
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Semantics(
              label: 'Inici',
              button: true,
              child: IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {},
              ),
            ),
            Semantics(
              label: 'Perfil',
              button: true,
              child: IconButton(
                icon: const Icon(Icons.person),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const Profile()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
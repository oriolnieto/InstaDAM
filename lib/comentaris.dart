import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'db.dart';

class CommentsPage extends StatefulWidget {
  final String idPost;

  const CommentsPage({super.key, required this.idPost});

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  List<Map<String, dynamic>> comentarios = [];
  final TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadComentarios();
  }

  // 🔥 Carregar comentaris (SQLite + Firebase)
  Future<void> _loadComentarios() async {
    // 🔹 SQLite
    final data = await db.getComentarios(widget.idPost);

    // 🔥 Firebase (IMPORTANT: id com String)
    final snapshot = await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.idPost.toString()) // ✅ FIX
        .collection('comentarios')
        .orderBy('timestamp', descending: true)
        .get();

    final firebaseComentarios = snapshot.docs.map((doc) {
      return doc.data();
    }).toList();

    setState(() {
      comentarios =
      firebaseComentarios.isNotEmpty ? firebaseComentarios : data;
    });
  }

  Future<String> _getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('currentUser') ?? 'Usuari';
  }

  // 🔥 Afegir comentari (SQLite + Firebase)
  Future<void> addComentario() async {
    final texto = commentController.text.trim();
    if (texto.isEmpty) return;

    final user = await _getCurrentUser();
    final fecha = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // 🔹 SQLite
    await db.addComentario(widget.idPost, user, texto, fecha);

    // 🔥 Firebase (IMPORTANT: id com String)
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.idPost.toString()) // ✅ FIX
        .collection('comentarios')
        .add({
      'user': user,
      'contenido': texto,
      'fecha': fecha,
      'timestamp': FieldValue.serverTimestamp(),
    });

    commentController.clear();
    await _loadComentarios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Comentaris"),
      ),
      body: Column(
        children: [
          Expanded(
            child: comentarios.isEmpty
                ? const Center(child: Text("Encara no hi ha comentaris"))
                : ListView.builder(
              itemCount: comentarios.length,
              itemBuilder: (context, index) {
                final c = comentarios[index];

                return MergeSemantics(
                  child: ListTile(
                    leading: const ExcludeSemantics(
                      child: CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                    ),
                    title: Text(
                      c['user'] ?? 'Usuari',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(c['contenido'] ?? ''),
                    trailing: Text(
                      c['fecha'] ?? '',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: commentController,
                    decoration: const InputDecoration(
                      labelText: "Escriu un comentari! :D",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Semantics(
                  label: "Enviar comentari",
                  button: true,
                  child: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: addComentario,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
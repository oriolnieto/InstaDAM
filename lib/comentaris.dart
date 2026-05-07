import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentsPage extends StatefulWidget {
  final String idPost;

  const CommentsPage({super.key, required this.idPost});

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final TextEditingController commentController = TextEditingController();

  Future<String> _getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('currentUser') ?? 'Usuari';
  }

  // 🔥 AFÈGIR COMENTARI I ACTUALITZAR COMPTADOR
  Future<void> addComentario() async {
    final texto = commentController.text.trim();
    if (texto.isEmpty) return;

    final user = await _getCurrentUser();
    final fecha = DateFormat('dd-MM-yyyy').format(DateTime.now());

    final postRef = FirebaseFirestore.instance.collection('posts').doc(widget.idPost);

    try {
      // 1. Guardem el comentari a la subcol·lecció
      await postRef.collection('comentarios').add({
        'user': user,
        'contenido': texto,
        'fecha': fecha,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // 2. Actualitzem el comptador "comentariosCount" del post pare
      await postRef.update({
        'comentariosCount': FieldValue.increment(1),
      });

      commentController.clear();
    } catch (e) {
      print("Error afegint comentari: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Comentaris"),
      ),
      body: Column(
        children: [
          // LLISTA DE COMENTARIS EN TEMPS REAL
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .doc(widget.idPost)
                  .collection('comentarios')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text("Error al carregar comentaris"));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("Encara no hi ha comentaris"));
                }

                final docs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final c = docs[index].data() as Map<String, dynamic>;
                    return ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.person)),
                      title: Text(
                        c['user'] ?? 'Usuari',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(c['contenido'] ?? ''),
                      trailing: Text(
                        c['fecha'] ?? '',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // INPUT PER ESCRIURE
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: commentController,
                    decoration: const InputDecoration(
                      hintText: "Escriu un comentari...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: addComentario,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
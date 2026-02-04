import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'db.dart';

class CommentsPage extends StatefulWidget {
  final int idPost;

  const CommentsPage ({super.key, required this.idPost});

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State <CommentsPage> {
  List<Map<String, dynamic>> comentarios = [];
  final TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadComentarios();
  }
  Future<void> _loadComentarios() async {
    final data = await db.getComentarios(widget.idPost);
    setState(() {
      comentarios = data;
    });
  }

  Future<void> _getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('currentUser') ?? 'Usuari';
  }

  Future<void> addComentario() async {
    final texto = commentController.text.trim();
    if (texto.isEmpty) return;

    final user = await _getCurrentUser();
    final fecha = DateFormat('yyyy-MM-dd').format(DateTime.now());

    await db.addComentario(widget.idPost, user, texto, fecha);

    commentController.clear();
    await _loadComentarios(); // refresh
  }

  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Comentaris"),
      ),
      body: Column(
        children: [
          Expanded(child: comentarios.isEmpty ? const Center(child: Text("Encara no hi ha comentaris")) : ListView.builder(
            itemCount: comentarios.length,
            itemBuilder: (context, index) {
              final c = comentarios[index];

              return ListTile(
                title: Text(
                  c['user'] ?? 'Usuari',
                  style:  const TextStyle(fontWeight: FontWeight.bold),
                ),

                subtitle: Text(c['contenido'] ?? ''),
                trailing: Text(
                  c['fecha'] ?? '',
                  style: const TextStyle(fontSize: 12),
                ),
              );
            },
          ),
          ),

          // input per comentar
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(child: TextField(
                  controller: commentController,
                  decoration: const InputDecoration(
                    hintText: "Escriu un comentari! :D",
                    border: OutlineInputBorder();
                  ),
                ),
                ),

                const SizedBox(width: 8),
                IconButton(icon: const Icon(Icons.send), onPressed: addComentario,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
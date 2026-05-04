import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // 🔥 Firebase
import 'db.dart';
import 'feed.dart';

final TextEditingController descController = TextEditingController();

// Lista de imágenes posibles
final List<String?> imatges = [
  null,
  'assets/DES.jpg',
  'assets/gordo.jpg',
  'assets/gos.jpg',
  'assets/dam2.jpg',
  'assets/commit100.jpeg'
];

class createPost extends StatelessWidget {
  const createPost({super.key});

  @override
  Widget build(BuildContext context) {
    return const CreatePostPage();
  }
}

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  String? imatgeSeleccionada = imatges.first;

  bool _isLoading = false;
  String? _errorDescripcio;

  Future<String> _getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('currentUser') ?? 'Usuari';
  }

  Future<void> _publicarPost() async {
    if (descController.text.trim().isEmpty) {
      setState(() {
        _errorDescripcio = 'La descripción es obligatoria.';
      });
      return;
    }

    setState(() {
      _errorDescripcio = null;
      _isLoading = true;
    });

    final user = await _getCurrentUser();
    final fecha = DateFormat('dd-MM-yyyy').format(DateTime.now());

    // 🔹 SQLite (el teu sistema actual)
    await db.createPost(
      imatgeSeleccionada ?? '',
      user,
      descController.text,
      fecha,
    );

    // 🔥 Firebase
    final docRef = await FirebaseFirestore.instance
        .collection('posts')
        .add({
      'user': user,
      'desc': descController.text,
      'fecha': fecha,
      'imagen': imatgeSeleccionada ?? '',
      'likes': 0,
      'comentarios': 0,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // (Opcional PRO) guardar el id dins del doc
    await docRef.update({
      'id': docRef.id,
    });

    descController.clear();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Semantics(
          liveRegion: true,
          child: Text('Post publicado correctamente'),
        ),
        duration: const Duration(seconds: 2),
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => Feed()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Post'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Atrás',
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => Feed()),
            );
          },
        ),
        actions: [
          Semantics(
            label: 'Publicar post',
            child: IconButton(
              constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
              icon: _isLoading
                  ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : const Icon(Icons.check),
              onPressed: _isLoading ? null : _publicarPost,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imatge
            Semantics(
              image: true,
              label: imatgeSeleccionada == null
                  ? 'Ninguna imagen seleccionada'
                  : 'Vista previa de la imagen seleccionada',
              child: imatgeSeleccionada != null
                  ? Image.asset(
                imatgeSeleccionada!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              )
                  : Container(
                height: 200,
                width: double.infinity,
                color: Colors.grey[300],
                child: const Center(
                  child: Text(
                    'Sin imagen',
                    style: TextStyle(
                        fontSize: 16, color: Colors.black54),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Selector
            Semantics(
              label:
              'Selector de imagen. Estado: ${imatgeSeleccionada == null ? "Ninguna imagen seleccionada" : "Imagen seleccionada"}',
              child: DropdownButton<String?>(
                value: imatgeSeleccionada,
                isExpanded: true,
                items: imatges.map((img) {
                  return DropdownMenuItem<String?>(
                    value: img,
                    child: Text(
                      img == null ? 'Sin imagen' : img.split('/').last,
                      style: theme.textTheme.bodyMedium,
                    ),
                  );
                }).toList(),
                onChanged: _isLoading
                    ? null
                    : (valor) {
                  setState(() {
                    imatgeSeleccionada = valor;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),

            Text(
              'Descripción del post',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            TextField(
              controller: descController,
              enabled: !_isLoading,
              decoration: InputDecoration(
                labelText: 'Descripción',
                errorText: _errorDescripcio,
                border: const OutlineInputBorder(),
              ),
              maxLines: 5,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: Semantics(
        label: 'Publicar post',
        child: FloatingActionButton(
          onPressed: _isLoading ? null : _publicarPost,
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Icon(Icons.check),
        ),
      ),
    );
  }
}
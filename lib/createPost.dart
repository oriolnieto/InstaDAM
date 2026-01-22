import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'db.dart';
import 'feed.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const createPost());
}

class createPost extends StatelessWidget {
  const createPost({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CreatePostPage(),
    );
  }
}

final TextEditingController descController = TextEditingController();
final TextEditingController rutaImagenController = TextEditingController();



class CreatePostPage extends StatelessWidget {
  const CreatePostPage({super.key});

  Future<String> _getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('currentUser') ?? 'Usuari';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Post'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => Feed()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () async {
              final user = await _getCurrentUser();
              print('Usuario logueado: $user');
              final fecha = DateFormat('yyyy-MM-dd').format(DateTime.now());


              // insereix a la base de dades
              await db.createPost(
                  rutaImagenController.text, user, descController.text, fecha);
              rutaImagenController.clear();
              descController.clear();

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => Feed()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: rutaImagenController,
              decoration: const InputDecoration(labelText: 'Ruta Imagen'), // de moment deixem aixi falta considerar la decisió de utilizar la dependencia d'image picker
            ),

            const SizedBox(height: 10),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'Descripción'),
              maxLines: 5,
            ),
          ],
        ),
      ),
    );
  }
}
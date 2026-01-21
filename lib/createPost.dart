import 'package:flutter/material.dart';
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
      home: Home(),
    );
  }
}

final TextEditingController descController = TextEditingController();
final TextEditingController rutaImagenController = TextEditingController();

const String currentUser = 'UsuariTest';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            icon: const Icon(Icons.add),
            onPressed: () async {
              final fecha = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
              await db.createPost(rutaImagenController.text, currentUser, descController.text, fecha);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => Feed()),
              );
            },
          ),
        ],
        title: const Text('Crear Post'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 10),
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
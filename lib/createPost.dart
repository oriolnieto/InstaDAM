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

final List<String> imatges = [
  'assets/DES.jpg',
  'assets/gordo.jpg',
  'assets/gos.jpg',
];

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  String imatgeSeleccionada = imatges.first;

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
              final fecha =
              DateFormat('dd-MM-yyyy').format(DateTime.now());

              await db.createPost(
                imatgeSeleccionada,
                user,
                descController.text,
                fecha,
              );

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
            Image.asset(
              imatgeSeleccionada,
              height: 200,
              fit: BoxFit.cover,
            ),

            const SizedBox(height: 10),

            DropdownButton<String>(
              value: imatgeSeleccionada,
              isExpanded: true,
              items: imatges.map((img) {
                return DropdownMenuItem(
                  value: img,
                  child: Text(img.split('/').last),
                );
              }).toList(),
              onChanged: (valor) {
                if (valor != null) {
                  setState(() {
                    imatgeSeleccionada = valor;
                  });
                }
              },
            ),

            const SizedBox(height: 10),

            TextField(
              controller: descController,
              decoration:
              const InputDecoration(labelText: 'Descripción'),
              maxLines: 5,
            ),
          ],
        ),
      ),
    );
  }
}

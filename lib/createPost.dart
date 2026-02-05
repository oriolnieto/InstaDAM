import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'db.dart';
import 'feed.dart';
import 'package:intl/intl.dart';

final TextEditingController descController = TextEditingController();

// Lista de imágenes posibles, ahora con opción null para "sin imagen"
final List<String?> imatges = [
  null, // Opción sin imagen
  'assets/DES.jpg',
  'assets/gordo.jpg',
  'assets/gos.jpg',
  'assets/dam2.jpg'
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

  Future<String> _getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('currentUser') ?? 'Usuari';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Post'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const Feed()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () async {
              final user = await _getCurrentUser();
              final fecha = DateFormat('dd-MM-yyyy').format(DateTime.now());

              await db.createPost(
                imatgeSeleccionada ?? '', // si no hay imagen, enviar ''
                user,
                descController.text,
                fecha,
              );

              descController.clear();

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const Feed()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Mostrar imagen si hay seleccionada, sino un contenedor gris
            if (imatgeSeleccionada != null)
              Image.asset(
                imatgeSeleccionada!,
                height: 200,
                fit: BoxFit.cover,
              )
            else
              Container(
                height: 200,
                color: Colors.grey[300],
                child: const Center(
                  child: Text(
                    'Sin imagen',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ),
              ),
            const SizedBox(height: 10),
            // Dropdown para seleccionar imagen o "sin imagen"
            DropdownButton<String?>(
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
              onChanged: (valor) {
                setState(() {
                  imatgeSeleccionada = valor;
                });
              },
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'Descripción'),
              maxLines: 5,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final user = await _getCurrentUser();
          final fecha = DateFormat('dd-MM-yyyy').format(DateTime.now());

          await db.createPost(
            imatgeSeleccionada ?? '',
            user,
            descController.text,
            fecha,
          );

          descController.clear();

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const Feed()),
          );
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}

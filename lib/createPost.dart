import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'db.dart';
import 'feed.dart';
import 'package:intl/intl.dart';

final TextEditingController descController = TextEditingController();

// Lista de imágenes posibles
final List<String?> imatges = [
  null, // Opción sin imagen
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

  // Variables d'estat per a l'accessibilitat
  bool _isLoading = false;
  String? _errorDescripcio;

  Future<String> _getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('currentUser') ?? 'Usuari';
  }

  // Funció unificada per publicar des del FAB i l'AppBar
  Future<void> _publicarPost() async {
    // 2. Validació: Error si descripció buida
    if (descController.text.trim().isEmpty) {
      setState(() {
        _errorDescripcio = 'La descripción es obligatoria.';
      });
      return;
    }

    // 3. Botó publicar: No permetre doble enviament i estat de càrrega
    setState(() {
      _errorDescripcio = null;
      _isLoading = true;
    });

    final user = await _getCurrentUser();
    final fecha = DateFormat('dd-MM-yyyy').format(DateTime.now());

    await db.createPost(
      imatgeSeleccionada ?? '',
      user,
      descController.text,
      fecha,
    );

    descController.clear();

    if (!mounted) return;

    // 4. Confirmació de publicació amb liveRegion: true
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Semantics(
          liveRegion: true,
          child: Text('Post publicado correctamente'),
        ),
        duration: const Duration(seconds: 2),
      ),
    );

    // Anem al Feed sense 'const' per evitar l'error
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
          tooltip: 'Atrás', // Accessibilitat bàsica pel botó enrere
          onPressed: () {
            // Anem al Feed sense 'const' per evitar l'error
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => Feed()),
            );
          },
        ),
        actions: [
          // 3. Botó 'Publicar' (AppBar)
          Semantics(
            label: 'Publicar post',
            child: IconButton(
              // Mida mínima 48dp garantida amb constraints
              constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
              icon: _isLoading
                  ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2)
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
          crossAxisAlignment: CrossAxisAlignment.start, // Alinear textos a l'esquerra
          children: [

            // Imatge (No pot desaparèixer visualment per TalkBack)
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
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // 1. Selector d'imatge accessible
            Semantics(
              label: 'Selector de imagen. Estado: ${imatgeSeleccionada == null ? "Ninguna imagen seleccionada" : "Imagen seleccionada"}',
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
                onChanged: _isLoading ? null : (valor) {
                  setState(() {
                    imatgeSeleccionada = valor;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),

            // 2. Etiqueta visible fora del camp TextField
            Text(
              'Descripción del post',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // 2. TextField amb validació d'error
            TextField(
              controller: descController,
              enabled: !_isLoading, // Bloquejar mentre carrega
              decoration: InputDecoration(
                labelText: 'Descripción',
                errorText: _errorDescripcio, // Talkback llegeix això automàticament
                border: const OutlineInputBorder(),
              ),
              maxLines: 5,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
      // 3. Botó 'Publicar' (FloatingActionButton)
      floatingActionButton: Semantics(
        label: 'Publicar post',
        child: FloatingActionButton(
          onPressed: _isLoading ? null : _publicarPost,
          // Un FAB ja compleix la mida mínima de 48dp (per defecte són 56dp)
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Icon(Icons.check),
        ),
      ),
    );
  }
}
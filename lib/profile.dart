import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String user = 'petitstrogonov';
  int comptadorPost = 0;
  bool temaOscuro = false;
  String idioma = 'Català';

  int followers = 150;
  int following = 200;

  final TextEditingController _nameController = TextEditingController();
  List<Map<String, dynamic>> userPosts = [];

  @override
  void initState() {
    super.initState();
    _loadUser();
    _loadPreferences();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    user = prefs.getString('currentUser') ?? 'petitstrogonov';
    await _loadUserPostsFirebase();
    setState(() {});
  }

  Future<void> _loadUserPostsFirebase() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where('user', isEqualTo: user)
          .get();

      setState(() {
        userPosts = snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
        comptadorPost = userPosts.length;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> _showEditNameDialog() async {
    _nameController.text = user;
    String oldName = user;

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t('editar')),
        content: TextField(controller: _nameController),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(t('cancel'))),
          ElevatedButton(
            onPressed: () async {
              final newName = _nameController.text.trim();
              if (newName.isNotEmpty && newName != oldName) {
                WriteBatch batch = FirebaseFirestore.instance.batch();
                final snapshot = await FirebaseFirestore.instance.collection('posts').where('user', isEqualTo: oldName).get();
                for (var doc in snapshot.docs) { batch.update(doc.reference, {'user': newName}); }
                await batch.commit();

                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('currentUser', newName);
                setState(() => user = newName);
                _loadUserPostsFirebase();
                Navigator.pop(context);
              }
            },
            child: Text(t('accept')),
          ),
        ],
      ),
    );
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      temaOscuro = prefs.getBool('isDarkTheme') ?? false;
      idioma = prefs.getString('language') ?? 'Català';
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkTheme', temaOscuro);
    await prefs.setString('language', idioma);
  }

  String t(String key) {
    final traduccions = {
      "ca": {
        "perfil": "Perfil", "posts": "Publicacions", "seguidors": "Seguidors", "seguint": "Seguint",
        "editar": "Editar perfil", "tema": "Tema fosc", "idioma": "Idioma", "logout": "Tancar sessió",
        "cancel": "Cancel·lar", "accept": "Acceptar",
      },
      "es": {
        "perfil": "Perfil", "posts": "Posts", "seguidors": "Seguidores", "seguint": "Siguiendo",
        "editar": "Editar perfil", "tema": "Tema Oscuro", "idioma": "Idioma", "logout": "Cerrar Sesión",
        "cancel": "Cancelar", "accept": "Aceptar",
      }
    };
    String langKey = (idioma == 'Català') ? 'ca' : 'es';
    return traduccions[langKey]?[key] ?? key;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(t('perfil')), centerTitle: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 55,
                backgroundImage: AssetImage('assets/imatge.png'), // El teu pingüí
              ),
              const SizedBox(height: 10),

              Text(user, style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),

              TextButton.icon(
                onPressed: _showEditNameDialog,
                icon: const Icon(Icons.edit, size: 18),
                label: Text(t('editar'), style: const TextStyle(fontSize: 16)),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Divider(thickness: 1),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [const Icon(Icons.language), const SizedBox(width: 10), Text(t('idioma'), style: const TextStyle(fontSize: 16))]),
                        DropdownButton<String>(
                          value: idioma,
                          underline: const SizedBox(),
                          items: <String>['Català', 'Español'].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                          onChanged: (n) { if (n != null) { setState(() => idioma = n); _savePreferences(); } },
                        ),
                      ],
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      secondary: const Icon(Icons.brightness_6),
                      title: Text(t('tema'), style: const TextStyle(fontSize: 16)),
                      value: temaOscuro,
                      onChanged: (v) { setState(() => temaOscuro = v); _savePreferences(); MyApp.maybeOf(context)?.changeTheme(v); },
                    ),
                  ],
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Divider(thickness: 1),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatColumn(comptadorPost.toString(), t('posts')),
                    _buildStatColumn(followers.toString(), t('seguidors')),
                    _buildStatColumn(following.toString(), t('seguint')),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 2, mainAxisSpacing: 2),
                  itemCount: userPosts.length,
                  itemBuilder: (context, index) {
                    final post = userPosts[index];
                    return Container(
                      color: Colors.grey.shade300,
                      child: post['rutaImagen'] != null
                          ? Image.asset(post['rutaImagen'], fit: BoxFit.cover)
                          : const Icon(Icons.image),
                    );
                  },
                ),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink.shade50,
                  foregroundColor: Colors.red,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(t('logout'), style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn(String count, String label) {
    return Column(
      children: [
        Text(count, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
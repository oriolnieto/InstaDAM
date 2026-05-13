import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login.dart';
import 'feed.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

// 🔥 FIREBASE
import 'package:cloud_firestore/cloud_firestore.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String user = 'Usuari';
  int comptadorPost = 0;
  bool temaOscuro = false;
  bool notificacions = true;
  String idioma = 'Español';

  int followers = 150;
  int following = 200;
  String bio = "Aquesta és la meva bio accessible.";

  // 🔥 POSTS FIREBASE
  List<Map<String, dynamic>> userPosts = [];

  @override
  void initState() {
    super.initState();
    _loadUser();
    _loadPreferences();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    user = prefs.getString('currentUser') ?? 'Usuari';


    await _loadUserPostsFirebase(); // 🔥 Firebase

    setState(() {});
  }



  // 🔥 FIREBASE POSTS
  Future<void> _loadUserPostsFirebase() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where('user', isEqualTo: user)
          .get();

      userPosts = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data(),
        };
      }).toList();

      comptadorPost = userPosts.length;
    } catch (e) {
      print("Error carregant posts Firebase: $e");
    }
  }

  Future<void> _loadPreferences() async {
    final preferences = await SharedPreferences.getInstance();
    setState(() {
      temaOscuro = preferences.getBool('isDarkTheme') ?? false;
      notificacions = preferences.getBool('notifications') ?? true;
      idioma = preferences.getString('language') ?? 'Español';
    });
  }

  Future<void> _savePreferences() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool('isDarkTheme', temaOscuro);
    await preferences.setBool('notifications', notificacions);
    await preferences.setString('language', idioma);
  }

  String t(String key) {
    final traduccions = {
      "ca": {
        "perfil": "Perfil",
        "posts": "Publicacions",
        "seguidors": "Seguidors",
        "seguint": "Seguint",
        "editar": "Editar perfil",
        "tema": "Tema fosc",
        "noti": "Notificacions",
        "logout": "Tancar sessió",
        "foto": "Foto de perfil de ",
        "post_desc": "Publicació número ",
        "confirm_logout": "Estàs segur que vols tancar la sessió?",
        "cancel": "Cancel·lar",
        "accept": "Acceptar",
        "lang_changed": "Idioma canviat a Català",
        "theme_on": "Tema fosc activat",
        "theme_off": "Tema clar activat",
      },
      "es": {
        "perfil": "Perfil",
        "posts": "Posts",
        "seguidors": "Seguidores",
        "seguint": "Siguiendo",
        "editar": "Editar perfil",
        "tema": "Tema Oscuro",
        "noti": "Notificaciones",
        "logout": "Cerrar Sesión",
        "foto": "Foto de perfil de ",
        "post_desc": "Publicación número ",
        "confirm_logout": "¿Estás seguro de que quieres cerrar sesión?",
        "cancel": "Cancelar",
        "accept": "Aceptar",
        "lang_changed": "Idioma cambiado a Español",
        "theme_on": "Tema oscuro activado",
        "theme_off": "Tema claro activado",
      }
    };
    String langKey = (idioma == 'Catala') ? 'ca' : 'es';
    return traduccions[langKey]?[key] ?? key;
  }

  Future<void> _showLogoutDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(t('logout')),
          content: Text(t('confirm_logout')),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Semantics(
                label: t('cancel'),
                child: Text(t('cancel')),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final preferences = await SharedPreferences.getInstance();
                await preferences.clear();
                if (mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const login()),
                        (route) => false,
                  );
                }
              },
              child: Semantics(
                label: t('accept'),
                child: Text(t('accept')),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(t('perfil')),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [

              // FOTO
              Semantics(
                label: "${t('foto')} $user",
                image: true,
                child: const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/imatge.png'),
                ),
              ),

              const SizedBox(height: 18),

              Text(user, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              Text(bio),

              const SizedBox(height: 10),

              // STATS
              MergeSemantics(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatColumn(comptadorPost.toString(), t('posts')),
                    _buildStatColumn(followers.toString(), t('seguidors')),
                    _buildStatColumn(following.toString(), t('seguint')),
                  ],
                ),
              ),

              const Divider(height: 32),

              // 🔥 GRID AMB POSTS REALS
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemCount: userPosts.length,
                itemBuilder: (context, index) {
                  final post = userPosts[index];

                  return Semantics(
                    label: "${t('post_desc')} ${index + 1}. ${post['likes'] ?? 0} likes",
                    button: true,
                    child: Container(
                      margin: const EdgeInsets.all(2),
                      color: theme.colorScheme.primaryContainer,
                      child: post['rutaImagen'] != null
                          ? Image.asset(post['rutaImagen'], fit: BoxFit.cover)
                          : const Icon(Icons.image),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // SWITCH TEMA
              SwitchListTile(
                title: Text(t('tema')),
                value: temaOscuro,
                onChanged: (valor) {
                  setState(() => temaOscuro = valor);
                  _savePreferences();
                  MyApp.maybeOf(context)?.changeTheme(valor);
                },
              ),

              // LOGOUT
              ElevatedButton(
                onPressed: _showLogoutDialog,
                child: Text(t('logout')),
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
        Text(count, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        Text(label),
      ],
    );
  }
}
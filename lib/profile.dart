import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login.dart';
import 'feed.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'db.dart';

class profile extends StatefulWidget {
  const profile({super.key});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  String user = 'Usuario';
  int comptadorPost = 0;
  bool temaOscuro = false;
  bool notificacions = true;
  String idioma = 'Español';

  int followers = 150;
  int following = 200;
  String bio = "Aquesta és la meva bio accessible.";

  @override
  void initState() {
    super.initState();
    _loadUser();
    _loadPreferences();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      user = prefs.getString('currentUser') ?? 'Usuari';
    });
    await _loadUserPosts();
  }

  Future<void> _loadUserPosts() async {
    final database = await db.database;
    final usuarios = await database.query(
      'users',
      where: 'user = ?',
      whereArgs: [user],
      limit: 1,
    );

    if (usuarios.isNotEmpty) {
      setState(() {
        comptadorPost = (usuarios.first['posts'] as int?) ?? 0;
      });
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

  Future<void> _logout() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.clear();
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
      }
    };
    String langKey = (idioma == 'Catala') ? 'ca' : 'es';
    return traduccions[langKey]?[key] ?? key;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(t('perfil')),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const Feed()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Semantics(
                label: "${t('foto')} $user",
                image: true,
                child: const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/imatge.png'),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                user,
                style: theme.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(bio),
              const SizedBox(height: 10),

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

              const SizedBox(height: 20),

              Semantics(
                label: t('editar'),
                child: SizedBox(
                  height: 48,
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {},
                    child: Text(t('editar')),
                  ),
                ),
              ),

              const Divider(height: 32),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                ),
                itemCount: comptadorPost > 0 ? comptadorPost : 6,
                itemBuilder: (context, index) {
                  return Semantics(
                    label: "${t('post_desc')} ${index + 1}. 25 likes.",
                    onTapHint: "Obrir publicació",
                    button: true,
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        color: theme.colorScheme.primaryContainer,
                        child: const Icon(Icons.grid_on),
                      ),
                    ),
                  );
                },
              ),

              const Divider(height: 32),

              SwitchListTile(
                title: Text(t('tema')),
                value: temaOscuro,
                onChanged: (valor) {
                  setState(() => temaOscuro = valor);
                  _savePreferences();
                  final appState = MyApp.maybeOf(context);
                  appState?.changeTheme(valor);
                },
              ),
              SwitchListTile(
                title: Text(t('noti')),
                value: notificacions,
                onChanged: (valorN) {
                  setState(() => notificacions = valorN);
                  _savePreferences();
                  HapticFeedback.lightImpact();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        valorN ? 'Notificaciones activadas' : 'Notificaciones desactivadas',
                      ),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
              DropdownButton<String>(
                value: idioma,
                items: const [
                  DropdownMenuItem(value: 'Español', child: Text('Español')),
                  DropdownMenuItem(value: 'Catala', child: Text('Catala')),
                  DropdownMenuItem(value: 'English', child: Text('English')),
                ],
                onChanged: (valorI) async {
                  if (valorI != null) {
                    setState(() => idioma = valorI);
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString("eleccio", idioma);
                    _savePreferences();
                  }
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await _logout();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const login()),
                        (route) => false,
                  );
                },
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
        Text(count, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(label),
      ],
    );
  }
}
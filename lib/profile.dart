import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/imatge.png'),
            ),
            const SizedBox(height: 18),
            Text(
              user,
              style: theme.textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Posts: $comptadorPost'),
                  ),
                );
              },
              child: Text(
                'Posts: $comptadorPost',
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: theme.colorScheme.primary),
              ),
            ),
            const Divider(height: 32),
            SwitchListTile(
              title: const Text('Tema Oscuro'),
              value: temaOscuro,
              onChanged: (valor) {
                setState(() => temaOscuro = valor);
                _savePreferences();
                final appState = MyApp.maybeOf(context);
                appState?.changeTheme(valor);
              },
            ),

            SwitchListTile(
              title: const Text('Notificaciones'),
              value: notificacions,
              onChanged: (valorN) {
                setState(() => notificacions = valorN);
                _savePreferences();
              },
            ),
            DropdownButton<String>(
              value: idioma,
              dropdownColor: theme.scaffoldBackgroundColor,
              style: theme.textTheme.bodyMedium,
              items: const [
                DropdownMenuItem(value: 'Español', child: Text('Español')),
                DropdownMenuItem(value: 'English', child: Text('English')),
              ],
              onChanged: (valorI) {
                if (valorI != null) {
                  setState(() => idioma = valorI);
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
              style: theme.elevatedButtonTheme.style,
              child: const Text('Cerrar Sesión'),
            ),
          ],
        ),
      ),
    );
  }
}

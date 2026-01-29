import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'feed.dart';
import 'main.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = MyApp.maybeOf(context);
      if (appState != null) {
        setState(() {
          temaOscuro = appState.isDarkTheme;
        });
      }
    });
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      user = prefs.getString('currentUser') ?? 'Usuari';
    });
  }

  // carregar preferencies
  Future<void> _loadPreferences() async {
    final preferences = await SharedPreferences.getInstance();
    setState(() {

      comptadorPost = preferences.getInt('postCount') ?? 0;
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
                  MaterialPageRoute(builder: (_) => Feed()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
              },
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
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
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
                style: const TextStyle(fontSize: 18),
              ),
            ),

            const Divider(height: 32),

            SwitchListTile(
              title: const Text('Tema Oscuro'),
              value: temaOscuro,
              onChanged: (valor) {
                setState(() {
                  temaOscuro = valor;
                });
                _savePreferences();
                MyApp.maybeOf(context)?.changeTheme(valor);
              },
            ),

            SwitchListTile(
              title: const Text('Notificaciones'),
              value: notificacions,
              onChanged: (valorN) {
                setState(() {
                  notificacions = valorN;
                });
                _savePreferences();
              },
            ),

            DropdownButton<String>(
              value: idioma,
              items: const [
                DropdownMenuItem(
                  value: 'Español',
                  child: Text('Español'),
                ),
                DropdownMenuItem(
                  value: 'English',
                  child: Text('English'),
                ),
              ],
              onChanged: (valorI) {
                if (valorI != null) {
                  setState(() {
                    idioma = valorI;
                  });
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
                  MaterialPageRoute(builder: (_) => login()),
                    (route) => false,
                );
              },
              child: const Text('Cerrar Sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
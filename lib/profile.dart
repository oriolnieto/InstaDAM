import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class profile extends StatefulWidget {
  const profile({super.key});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  String user = 'Usuari';
  int comptadorPost = 0;
  bool temaOscuro = false;
  bool notificacions = true;
  String idioma = 'Español';

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  // carregar preferencies
  Future<void> _loadPreferences() async {
    final preferences = await SharedPreferences.getInstance();
    setState(() {
      user = preferences.getString('Username') ?? 'Usuari';
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
        title: const Text('Perfil de Usuario'),
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
                style: const TextStyle(fontSize: 18, color: Colors.blue),
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

            const Spacer(),

            ElevatedButton(
              onPressed: _logout,
              child: const Text('Cerrar Sesión'),
            ),
          ],
        ),
      ),
    );
  }
}

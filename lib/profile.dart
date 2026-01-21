import 'package:flutter/material.dart';
import 'login.dart';
import 'feed.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  final VoidCallback toggleTheme; // Función para cambiar el tema
  final bool isDarkTheme;         // Estado actual del tema

  const Profile({super.key, required this.toggleTheme, required this.isDarkTheme});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String user = 'Usuario';
  int postCount = 0;
  bool notifications = true;
  String language = 'Español';

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      user = prefs.getString('Username') ?? 'Usuario';
      postCount = prefs.getInt('postCount') ?? 0;
      notifications = prefs.getBool('notifications') ?? true;
      language = prefs.getString('language') ?? 'Español';
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkTheme', widget.isDarkTheme);
    await prefs.setBool('notifications', notifications);
    await prefs.setString('language', language);
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const Feed()),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => Profile(
                    toggleTheme: widget.toggleTheme,
                    isDarkTheme: widget.isDarkTheme,
                  ),
                ),
              ),
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
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Posts: $postCount')),
              ),
              child: Text(
                'Posts: $postCount',
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.primary),
              ),
            ),
            const Divider(height: 32),

            // Switch que cambia el tema
            SwitchListTile(
              title: const Text('Tema Oscuro'),
              value: widget.isDarkTheme,
              onChanged: (valor) {
                widget.toggleTheme(); // Cambia el tema global
                _savePreferences();
              },
            ),

            SwitchListTile(
              title: const Text('Notificaciones'),
              value: notifications,
              onChanged: (valor) {
                setState(() => notifications = valor);
                _savePreferences();
              },
            ),

            DropdownButton<String>(
              value: language,
              dropdownColor: theme.scaffoldBackgroundColor,
              style: theme.textTheme.bodyMedium,
              items: const [
                DropdownMenuItem(value: 'Español', child: Text('Español')),
                DropdownMenuItem(value: 'English', child: Text('English')),
              ],
              onChanged: (valor) {
                if (valor != null) {
                  setState(() => language = valor);
                  _savePreferences();
                }
              },
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                _logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const login()),
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

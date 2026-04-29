import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login.dart';
import 'feed.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'db.dart';

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
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              tooltip: "Inici",
              icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const Feed()),
                );
              },
            ),
            IconButton(
              tooltip: t('perfil'),
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
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(bio, style: theme.textTheme.bodyMedium),
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
                button: true,
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

              Semantics(
                container: true,
                toggled: temaOscuro,
                label: t('tema'),
                child: SwitchListTile(
                  secondary: Icon(temaOscuro ? Icons.dark_mode : Icons.light_mode),
                  title: Text(t('tema')),
                  value: temaOscuro,
                  onChanged: (valor) {
                    setState(() => temaOscuro = valor);
                    _savePreferences();
                    MyApp.maybeOf(context)?.changeTheme(valor);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(valor ? t('theme_on') : t('theme_off')), duration: const Duration(seconds: 1)),
                    );
                  },
                ),
              ),

              Semantics(
                container: true,
                toggled: notificacions,
                label: t('noti'),
                child: SwitchListTile(
                  secondary: Icon(notificacions ? Icons.notifications_active : Icons.notifications_off),
                  title: Text(t('noti')),
                  value: notificacions,
                  onChanged: (valorN) {
                    setState(() => notificacions = valorN);
                    _savePreferences();
                    HapticFeedback.lightImpact();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(valorN ? 'Notificaciones activadas' : 'Notificaciones desactivadas'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Selecciona idioma:", style: theme.textTheme.bodyLarge),
                    Semantics(
                      label: "Selector d'idioma actual: $idioma",
                      child: DropdownButton<String>(
                        value: idioma,
                        items: const [
                          DropdownMenuItem(value: 'Español', child: Text('Español')),
                          DropdownMenuItem(value: 'Catala', child: Text('Catala')),
                        ],
                        onChanged: (valorI) async {
                          if (valorI != null) {
                            setState(() => idioma = valorI);
                            _savePreferences();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(t('lang_changed'))),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Semantics(
                button: true,
                label: t('logout'),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.exit_to_app),
                  onPressed: _showLogoutDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.errorContainer,
                    foregroundColor: theme.colorScheme.onErrorContainer,
                  ),
                  label: Text(t('logout')),
                ),
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
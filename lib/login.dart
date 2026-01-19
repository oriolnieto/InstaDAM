import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'db.dart';
import 'register.dart';
import 'feed.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  bool logged = prefs.getBool('logged') ?? false;
  Widget inicio;
  if (logged) {
    inicio = const Feed();
  } else {
    inicio = const login();
  }
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: inicio,
  ));
}

class InstaDAM extends StatelessWidget {
  const InstaDAM({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(); // ha de tornar algo sino no funciona
  }
}

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => LoginState();
}

class LoginState extends State<login> {
  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      userController.text = prefs.getString('username') ?? '';
      rememberMe = prefs.getBool('remember') ?? false;
    });
  }

  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool rememberMe = false;

  // Función para el estilo de botones (cambia al hacer click)
  ButtonStyle customButtonStyle() {
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.pressed)) {
          return const Color(0xFF4CB7CD); // Fondo al presionar
        }
        return const Color(0xFF1F140F); // Fondo normal
      }),
      foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.pressed)) {
          return const Color(0xFF1F140F); // Texto al presionar
        }
        return const Color(0xFFFFFFFF); // Texto normal
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF), // Fondo blanco
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logoApp.png',
              height: 300,
              width: 300,
            ),

            // Usuario
            TextField(
              controller: userController,
              decoration: const InputDecoration(
                labelText: 'Usuario',
              ),
            ),
            const SizedBox(height: 16),

            // Contraseña
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
              ),
            ),
            const SizedBox(height: 8),

            // Checkbox
            CheckboxListTile(
              title: const Text('Recordar'),
              value: rememberMe,
              onChanged: (value) {
                setState(() {
                  rememberMe = value ?? false;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                if (states.contains(WidgetState.selected)) {
                  return const Color(0xFF4CB7CD); // Marcado azul
                }
                return const Color(0xFFFFFFFF); // No marcado blanco
              }),
            ),
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () async {
                final user = userController.text;
                final pass = passwordController.text;

                final prefs = await SharedPreferences.getInstance();

                await prefs.setBool('logged', true);
                await prefs.setBool('remember', rememberMe);

                if (rememberMe) {
                  await prefs.setString('username', user);
                } else {
                  await prefs.remove('username');
                }

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Feed()),
                );
              },
              style: customButtonStyle(),
              child: const Text('Ingresar'),
            ),
            const SizedBox(height: 10),
            // Botón Ir a Registro
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Register(),
                  ),
                );
              },
              style: customButtonStyle(),
              child: const Text('Ir a Registro'),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'register.dart';

void main() {
  runApp(const InstaDAM());
}

class InstaDAM extends StatelessWidget {
  const InstaDAM({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: login(),
    );
  }
}

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => LoginState();
}

class LoginState extends State<login> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool rememberMe = false;

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
            TextField(
              controller: userController,
              decoration: const InputDecoration(
                labelText: 'Usuario',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
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
                // Si el checkbox está seleccionado (marcado), usar azul
                if (states.contains(WidgetState.selected)) {
                  return const Color(0xFF4CB7CD);
                }
                // Si no está marcado, fondo blanco
                return const Color(0xFFFFFFFF);
              }),
            ),

            const SizedBox(height: 16),

            // Botón Ingresar
            ElevatedButton(
              onPressed: () {
                debugPrint('Usuario: ${userController.text}');
                debugPrint('Contraseña: ${passwordController.text}');
                debugPrint('checkbox: $rememberMe');
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.hovered)) {
                    return const Color(0xFF4CB7CD); // Hover fondo
                  }
                  return const Color(0xFF1F140F); // Normal fondo
                }),
                foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.hovered)) {
                    return const Color(0xFF1F140F); // Hover letra
                  }
                  return const Color(0xFFFFFFFF); // Normal letra
                }),
              ),
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
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.hovered)) {
                    return const Color(0xFF4CB7CD); // Hover fondo
                  }
                  return const Color(0xFF1F140F); // Normal fondo
                }),
                foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.hovered)) {
                    return const Color(0xFF1F140F); // Hover letra
                  }
                  return const Color(0xFFFFFFFF); // Normal letra
                }),
              ),
              child: const Text('Ir a Registro'),
            ),
          ],
        ),
      ),
    );
  }
}

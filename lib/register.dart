import 'package:flutter/material.dart';
import 'login.dart';
import 'db.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Register(),
    );
  }
}

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => RegisterState();
}

class RegisterState extends State<Register> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool acceptTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
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
            const SizedBox(height: 50),

            // Botón Registrarse
            ElevatedButton(
              onPressed: () async {
                await db.register(userController.text, passwordController.text); // fer await perque la funcio es async
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.hovered)) {
                    return const Color(0xFF4CB7CD);
                  }
                  return const Color(0xFF1F140F);
                }),
                foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.hovered)) {
                    return const Color(0xFF1F140F);
                  }
                  return const Color(0xFFFFFFFF);
                }),
              ),
              child: const Text('Registrarse'),
            ),

            const SizedBox(height: 10),

            // Botón Ir a Login
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const login(),
                  ),
                );
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.hovered)) {
                    return const Color(0xFF4CB7CD);
                  }
                  return const Color(0xFF1F140F);
                }),
                foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.hovered)) {
                    return const Color(0xFF1F140F);
                  }
                  return const Color(0xFFFFFFFF);
                }),
              ),
              child: const Text('Ir a Login'),
            ),
          ],
        ),
      ),
    );
  }
}

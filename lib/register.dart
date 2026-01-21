import 'package:flutter/material.dart';
import 'login.dart';
import 'db.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => RegisterState();
}

class RegisterState extends State<Register> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logoApp.png', height: 300, width: 300),
            TextField(
              controller: userController,
              decoration: const InputDecoration(labelText: 'Usuario'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Contraseña'),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () async {
                await db.register(userController.text, passwordController.text);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Usuario registrado')),
                );
              },
              style: theme.elevatedButtonTheme.style,
              child: const Text('Registrarse'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const login()),
                );
              },
              style: theme.elevatedButtonTheme.style,
              child: const Text('Ir a Login'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'register.dart';
import 'feed.dart';
import 'db.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
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
            CheckboxListTile(
              title: const Text('Recordar'),
              value: rememberMe,
              onChanged: (v) => setState(() => rememberMe = v ?? false),
            ),
            ElevatedButton(
              onPressed: () async {
                final ok = await db.login(
                  userController.text,
                  passwordController.text,
                );
                if (!ok) return;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const Feed()),
                );
              },
              child: const Text('Ingresar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const Register()),
                );
              },
              child: const Text('Ir a Registro'),
            ),
          ],
        ),
      ),
    );
  }
}

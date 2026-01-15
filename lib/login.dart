import 'package:flutter/material.dart';

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
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                debugPrint('Usuario: ${userController.text}');
                debugPrint('Contraseña: ${passwordController.text}');
                debugPrint('checkbox: $rememberMe');
              },
              child: const Text('Ingresar'),
            ),
          ],
        ),
      ),
    );
  }
}
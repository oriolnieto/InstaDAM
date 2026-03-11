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
  final FocusNode _passFocus = FocusNode();


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
              onSubmitted: (_) => FocusScope.of(context).requestFocus(_passFocus),
              decoration: const InputDecoration(labelText: 'Usuario',floatingLabelBehavior: FloatingLabelBehavior.always,),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              focusNode: _passFocus,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Contraseña',floatingLabelBehavior: FloatingLabelBehavior.always,),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () async {
                await db.register(userController.text, passwordController.text);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Usuario registrado')),
                );
              },
              style: theme.elevatedButtonTheme.style?.copyWith(minimumSize: const WidgetStatePropertyAll(Size(double.infinity, 48)),),
              child: const Text('Registrarse'),
            ),
            const SizedBox(height: 16),
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

import 'package:flutter/material.dart';
import 'login.dart';
import 'db.dart';

// 🔥 FIREBASE
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => RegisterState();
}

class RegisterState extends State<Register> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode _passFocus = FocusNode();

  bool _isLoading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Image.asset(
                'assets/logoApp.png',
                height: 300,
                width: 300,
                semanticLabel: 'Logo de InstaDAM',
              ),

              const SizedBox(height: 20),

              // ERROR GLOBAL ACCESSIBLE
              Semantics(
                liveRegion: true,
                child: _error != null
                    ? Text(_error!, style: const TextStyle(color: Colors.red))
                    : const SizedBox(),
              ),

              const SizedBox(height: 10),

              // USER
              TextField(
                controller: userController,
                onSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_passFocus),
                decoration: const InputDecoration(
                  labelText: 'Usuario',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),

              const SizedBox(height: 16),

              // PASSWORD
              TextField(
                controller: passwordController,
                focusNode: _passFocus,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),

              const SizedBox(height: 40),

              // 🔥 BOTÓ REGISTER
              Semantics(
                button: true,
                label: 'Registrar usuario',
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                    final user = userController.text.trim();
                    final pass = passwordController.text.trim();

                    if (user.isEmpty || pass.isEmpty) {
                      setState(() {
                        _error = "Todos los campos son obligatorios";
                      });
                      return;
                    }

                    setState(() {
                      _isLoading = true;
                      _error = null;
                    });

                    try {
                      // 🔥 FIREBASE AUTH (email fake)
                      final email = "$user@instadam.com";

                      final cred = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                        email: email,
                        password: pass,
                      );

                      // 🔥 FIRESTORE
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(cred.user!.uid)
                          .set({
                        'user': user,
                        'createdAt': DateTime.now().toString(),
                      });




                      if (!mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Usuario registrado correctamente'),
                        ),
                      );

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const login(),
                        ),
                      );

                    } on FirebaseAuthException catch (e) {
                      setState(() {
                        _error = e.message ?? "Error en registro";
                      });
                    } catch (e) {
                      setState(() {
                        _error = "Error inesperado";
                      });
                    }

                    setState(() {
                      _isLoading = false;
                    });
                  },
                  style: theme.elevatedButtonTheme.style?.copyWith(
                    minimumSize:
                    const WidgetStatePropertyAll(Size(double.infinity, 48)),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Registrarse'),
                ),
              ),

              const SizedBox(height: 16),

              // LOGIN
              Semantics(
                button: true,
                label: 'Ir a login',
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const login()),
                    );
                  },
                  style: theme.elevatedButtonTheme.style,
                  child: const Text('Ir a Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
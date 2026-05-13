import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'register.dart';
import 'feed.dart';
import 'package:firebase_auth/firebase_auth.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _LoginState();
}

class _LoginState extends State<login> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode _passFocus = FocusNode();

  bool rememberMe = false;
  String? _userError;
  String? _passError;
  String? _globalError;

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

  @override
  void dispose() {
    userController.dispose();
    passwordController.dispose();
    _passFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // 🔹 LOGO (no llegit com "imatge")
              ExcludeSemantics(
                child: Image.asset(
                  'assets/logoApp.png',
                  height: 300,
                  width: 300,
                ),
              ),

              const SizedBox(height: 20),

              // 🔹 USER FIELD
              TextField(
                controller: userController,
                textInputAction: TextInputAction.next,
                onSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(_passFocus),
                decoration: InputDecoration(
                  labelText: 'Usuario',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  errorText: _userError,
                ),
              ),

              const SizedBox(height: 16),

              // 🔹 PASSWORD FIELD
              TextField(
                controller: passwordController,
                focusNode: _passFocus,
                obscureText: true,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  errorText: _passError,
                ),
              ),

              const SizedBox(height: 8),

              // 🔹 CHECKBOX ACCESSIBLE
              Semantics(
                label: 'Recordar usuario',
                toggled: rememberMe,
                onTapHint: rememberMe
                    ? 'Desactivar recordar usuario'
                    : 'Activar recordar usuario',
                child: CheckboxListTile(
                  title: const Text('Recordar'),
                  value: rememberMe,
                  onChanged: (value) {
                    setState(() {
                      rememberMe = value ?? false;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),

              const SizedBox(height: 16),

              // 🔹 ERROR GLOBAL ACCESSIBLE
              Semantics(
                liveRegion: true,
                child: _globalError != null
                    ? Text(
                  _globalError!,
                  style: const TextStyle(color: Colors.red),
                )
                    : const SizedBox.shrink(),
              ),

              const SizedBox(height: 16),

              // 🔹 BOTÓ LOGIN ACCESSIBLE
              Semantics(
                button: true,
                label: 'Iniciar sesión',
                onTapHint: 'Validar credenciales y acceder',
                child: ElevatedButton(
                  onPressed: () async {
                    final user = userController.text.trim();
                    final pass = passwordController.text.trim();

                    setState(() {
                      _userError = user.isEmpty ? 'El usuario es obligatorio' : null;
                      _passError = pass.isEmpty ? 'La contraseña es obligatoria' : null;
                      _globalError = null;
                    });

                    if (_userError != null || _passError != null) return;

                    try {
                      final email = "$user@instadam.com";

                      // 🔥 LOGIN REAL CON FIREBASE AUTH
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: email,
                        password: pass,
                      );

                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString('currentUser', user);

                      if (rememberMe) {
                        await prefs.setString('username', user);
                        await prefs.setBool('logged', true);
                        await prefs.setBool('remember', true);
                      } else {
                        await prefs.remove('username');
                        await prefs.setBool('logged', false);
                        await prefs.setBool('remember', false);
                      }

                      if (!mounted) return;

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const Feed()),
                      );

                    } on FirebaseAuthException catch (e) {
                      setState(() {
                        _globalError = e.message ?? "Error de autenticación";
                      });
                    } catch (e) {
                      setState(() {
                        _globalError = "Error inesperado";
                      });
                    }
                  },
                  style: theme.elevatedButtonTheme.style?.copyWith(
                    minimumSize:
                    const WidgetStatePropertyAll(Size(double.infinity, 48)),
                  ),
                  child: const Text('Ingresar'),
                ),
              ),

              const SizedBox(height: 16),

              // 🔹 BOTÓ REGISTRE ACCESSIBLE
              Semantics(
                button: true,
                label: 'Ir a registro',
                onTapHint: 'Crear una nueva cuenta',
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const Register(),
                      ),
                    );
                  },
                  style: theme.elevatedButtonTheme.style,
                  child: const Text('Ir a Registro'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
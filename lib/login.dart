import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'db.dart';
import 'register.dart';
import 'feed.dart';

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
              Image.asset(
                'assets/logoApp.png',
                semanticLabel: 'Logo de InstaDAM',
                height: 300,
                width: 300,
              ),

              TextField(
                controller: userController,
                onSubmitted: (_) => FocusScope.of(context).requestFocus(_passFocus),
                decoration: InputDecoration(
                  labelText: 'Usuario',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  errorText: _userError,
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: passwordController,
                focusNode: _passFocus,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  errorText: _passError,
                ),
              ),

              const SizedBox(height: 8),

              Semantics(
                toggled: rememberMe,
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

              Semantics(
                liveRegion: true,
                child: _globalError != null ? Text(_globalError!, style: const TextStyle(color: Colors.red),) : const SizedBox.shrink(),
              ),

              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: () async {
                  final user = userController.text;
                  final pass = passwordController.text;

                  final ok = await db.login(user, pass);
                  if (!ok) {
                    setState(() {
                      _globalError = 'Usuario o contraseña incorrectos';
                    });
                    return;
                  }

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

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const Feed(),
                    ),
                  );
                },
                style: theme.elevatedButtonTheme.style?.copyWith(minimumSize: const WidgetStatePropertyAll(Size(double.infinity, 48)),),
                child: const Text('Ingresar'),
              ),

              const SizedBox(height: 16),

              ElevatedButton(
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
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'feed.dart';
import 'theme/tema_claro.dart';
import 'theme/tema_oscuro.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  bool logged = prefs.getBool('logged') ?? false;
  bool isDark = prefs.getBool('isDarkTheme') ?? false;

  runApp(MyApp(initialLogged: logged, initialDarkTheme: isDark));
}

class MyApp extends StatefulWidget {
  final bool initialLogged;
  final bool initialDarkTheme;

  const MyApp({super.key, required this.initialLogged, required this.initialDarkTheme});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ThemeData currentTheme;
  late bool isDarkTheme;

  @override
  void initState() {
    super.initState();
    isDarkTheme = widget.initialDarkTheme;
    currentTheme = isDarkTheme ? TemaOscuro.theme : TemaClaro.theme;
  }

  void toggleTheme() {
    setState(() {
      isDarkTheme = !isDarkTheme;
      currentTheme = isDarkTheme ? TemaOscuro.theme : TemaClaro.theme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: currentTheme,
      home: widget.initialLogged
          ? const Feed()
          : loginWrapper(toggleTheme: toggleTheme, isDarkTheme: isDarkTheme),
    );
  }
}

// Wrapper para pasar parámetros al login sin const
class loginWrapper extends StatelessWidget {
  final VoidCallback toggleTheme;
  final bool isDarkTheme;

  const loginWrapper({super.key, required this.toggleTheme, required this.isDarkTheme});

  @override
  Widget build(BuildContext context) {
    return login(); // login ya no necesita toggleTheme ni isDarkTheme
  }
}

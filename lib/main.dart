import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'loadScreen.dart';
import 'feed.dart';
import 'theme/tema_claro.dart';
import 'theme/tema_oscuro.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  bool logged = prefs.getBool('logged') ?? false;
  bool isDark = prefs.getBool('isDarkTheme') ?? true;

  runApp(MyApp(
    initialLogged: logged,
    initialDarkTheme: isDark,
  ));
}

class MyApp extends StatefulWidget {
  final bool initialLogged;
  final bool initialDarkTheme;

  const MyApp({
    super.key,
    required this.initialLogged,
    required this.initialDarkTheme,
  });

  static _MyAppState? maybeOf(BuildContext context) {
    return context.findAncestorStateOfType<_MyAppState>();
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool isDarkTheme;

  @override
  void initState() {
    super.initState();
    isDarkTheme = widget.initialDarkTheme;
  }

  void changeTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkTheme', value);

    setState(() {
      isDarkTheme = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: temaClaro,
      darkTheme: temaOscuro,
      themeMode: isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      home: widget.initialLogged ? const Feed() : const LoadScreen(),
    );
  }
}

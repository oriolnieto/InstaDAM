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
  bool isDark = prefs.getBool('isDarkTheme') ?? false;
  String language = prefs.getString('language') ?? 'Español';

  runApp(MyApp(
    initialLogged: logged,
    initialDarkTheme: isDark,
    initialLanguage: language,
  ));
}

class MyApp extends StatefulWidget {
  final bool initialLogged;
  final bool initialDarkTheme;
  final String initialLanguage;

  const MyApp({
    super.key,
    required this.initialLogged,
    required this.initialDarkTheme,
    required this.initialLanguage,
  });

  static _MyAppState? maybeOf(BuildContext context) {
    return context.findAncestorStateOfType<_MyAppState>();
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool isDarkTheme;
  late String language;

  @override
  void initState() {
    super.initState();
    isDarkTheme = widget.initialDarkTheme;
    language = widget.initialLanguage;
  }

  void changeTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkTheme', value);
    setState(() {
      isDarkTheme = value;
    });
  }

  void changeLanguage(String newLang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', newLang);
    setState(() {
      language = newLang;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: temaClaro,
      darkTheme: temaOscuro,
      themeMode: isDarkTheme ? ThemeMode.dark : ThemeMode.light,

      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: MediaQuery.of(context).textScaler,
          ),
          child: child!,
        );
      },

      home: widget.initialLogged ? const Feed() : const LoadScreen(),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Llenguatge extends ChangeNotifier {
  String _idioma = 'ca'; // idioma per defecte

  String get eleccio => _idioma;

  Future<void> nouLlenguatge() async {
    final prefs = await SharedPreferences.getInstance();
    _idioma = prefs.getString("eleccio") ?? 'ca';
    notifyListeners();
  }

  Future<void> applyLlenguatge(String nouLlenguatge) async {
    final prefs = await SharedPreferences.getInstance();
    _idioma = nouLlenguatge;
    await prefs.setString("eleccio" , nouLlenguatge);
    notifyListeners();
  }

  String text (String key) {
    final Map<String, Map<String, String>> traduccions = {
      "ca": {
        "settings": "Configuració",
        "language": "Idioma",
        "feed": "Inici",
      },

      "es": {
        "settings": "Configuración",
        "language": "Idioma",
        "feed": "Inicio",
      }
    };
    return traduccions[_idioma]?[key] ?? key;
  }


}
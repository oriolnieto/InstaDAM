import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Llenguatge extends ChangeNotifier {
  String _idioma = 'ca';

  String get eleccio => _idioma;

  // 🔹 Carregar idioma guardat al iniciar app
  Future<void> carregarLlenguatge() async {
    final prefs = await SharedPreferences.getInstance();
    _idioma = prefs.getString("eleccio") ?? 'ca';
    notifyListeners();
  }

  // 🔹 Canviar idioma
  Future<void> applyLlenguatge(String nouLlenguatge) async {
    final prefs = await SharedPreferences.getInstance();
    _idioma = nouLlenguatge;
    await prefs.setString("eleccio", nouLlenguatge);
    notifyListeners();
  }

  // 🔹 Traduccions
  String text(String key) {
    final Map<String, Map<String, String>> traduccions = {
      "ca": {
        "settings": "Configuració",
        "language": "Idioma",
        "feed": "Inici",
        "login": "Iniciar sessió",
        "logout": "Tancar sessió",
        "create_post": "Crear publicació",
        "comment": "Comentari",
        "send": "Enviar",
      },
      "es": {
        "settings": "Configuración",
        "language": "Idioma",
        "feed": "Inicio",
        "login": "Iniciar sesión",
        "logout": "Cerrar sesión",
        "create_post": "Crear publicación",
        "comment": "Comentario",
        "send": "Enviar",
      }
    };

    // 🔹 fallback segur
    return traduccions[_idioma]?[key] ??
        traduccions['ca']?[key] ??
        key;
  }
}
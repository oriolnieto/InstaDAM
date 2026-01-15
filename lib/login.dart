import 'package:flutter/material.dart';
import 'register.dart';

void main() {
  runApp(const InstaDAM());
}

class InstaDAM extends StatelessWidget {
  const InstaDAM({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.black), // Texto normal
          floatingLabelStyle: TextStyle(color: Color(0xFF4CB7CD)), // Texto al enfocar
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFF4CB7CD),
              width: 2.0,
            ),
          ),
          border: OutlineInputBorder(),
        ),
      ),
      home: const login(),
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

  // Función para el estilo de botones (cambia al hacer click)
  ButtonStyle customButtonStyle() {
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.pressed)) {
          return const Color(0xFF4CB7CD); // Fondo al presionar
        }
        return const Color(0xFF1F140F); // Fondo normal
      }),
      foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.pressed)) {
          return const Color(0xFF1F140F); // Texto al presionar
        }
        return const Color(0xFFFFFFFF); // Texto normal
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF), // Fondo blanco
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

            // Usuario
            TextField(
              controller: userController,
              decoration: const InputDecoration(
                labelText: 'Usuario',
              ),
            ),
            const SizedBox(height: 16),

            // Contraseña
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
              ),
            ),
            const SizedBox(height: 8),

            // Checkbox
            CheckboxListTile(
              title: const Text('Recordar'),
              value: rememberMe,
              onChanged: (value) {
                setState(() {
                  rememberMe = value ?? false;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                if (states.contains(WidgetState.selected)) {
                  return const Color(0xFF4CB7CD); // Marcado azul
                }
                return const Color(0xFFFFFFFF); // No marcado blanco
              }),
            ),
            const SizedBox(height: 16),

            // Botón Ingresar
            ElevatedButton(
              onPressed: () {
                debugPrint('Usuario: ${userController.text}');
                debugPrint('Contraseña: ${passwordController.text}');
                debugPrint('Recordar: $rememberMe');
              },
              style: customButtonStyle(),
              child: const Text('Ingresar'),
            ),
            const SizedBox(height: 10),

            // Botón Ir a Registro
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Register(),
                  ),
                );
              },
              style: customButtonStyle(),
              child: const Text('Ir a Registro'),
            ),
          ],
        ),
      ),
    );
  }
}

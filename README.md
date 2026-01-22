
<p align="center">
  <img src="assets/logoApp.png" alt="Logo" width="350">
</p>

# InstaDAM - Grupo 5

## Descripción del proyecto

InstaDAM es una app móvil inspirada en Instagram, desarrollada con Flutter y Dart. Permite iniciar sesión, crear publicaciones, dar likes y añadir comentarios. Usa SharedPreferences para guardar datos del usuario y ajustes, y SQFlite para almacenar publicaciones y comentarios. La app incluye un feed, perfil de usuario y una pantalla de configuración, obviamente con las pantallas de registro y login.

## Instalación

  cupertino_icons: ^1.0.8
  sqflite: ^2.4.2
  shared_preferences: ^2.5.4
  path: ^1.8.3

  - assets/logoApp.png

## Estructura del proyecto

assets -
         > logoApp.png

lib  - 
       > createPost.dart
       > db.dart
       > feed.dart
       > login.dart
       > profile.dart
       > register.dart
       > main.dart
       themes -
         >temaClaro.dart
         >temaOscuro.dart

Lo primero que se abre es el main, el cual decide que tema se está usando y se lo otorga a todos las demás páginas. 
El main te redirige al login, desde donde puedes ir a Register para registrarte, o, iniciar sesión y entrar al feed.
El feed te mustra todos los cards disponibles de forma aleatoria, desde aquí puedes entrar a cualquier publicación para escribir comentarios.
Desde el feed se puede abrir el profile, donde puedes cambiar los temas.
En feed tambien puedes acceder a createPost, donde se pueden crear nuevos post en forma de card que saldrán en el feed.

## Funcionalidades implementadas

Se ha implementado una función para subir los datos de registro a la BD, una para el login, otra para crear un post (parecido a un registro, insertar datos pero con distintos formatos).

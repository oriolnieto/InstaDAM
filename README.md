<p align="center">
  <img src="assets/logoApp.png" alt="LogoInstaDAM" width="350">
</p>

# InstaDAM - Grupo 5

## Descripción del proyecto

InstaDAM es una app móvil inspirada en Instagram, desarrollada con Flutter y Dart. Permite iniciar sesión, crear publicaciones, dar likes y añadir comentarios. Usa SharedPreferences para guardar datos del usuario y ajustes, y SQFlite para almacenar publicaciones y comentarios. La app incluye un feed, perfil de usuario y una pantalla de configuración, obviamente con las pantallas de registro y login.

## Instalación

  intl: ^0.18.1
  cupertino_icons: ^1.0.8
  sqflite: ^2.4.2
  shared_preferences: ^2.5.4
  path: ^1.8.3

  - assets/logoApp.png
  - assets/DES.jpg
  - assets/gordo.jpg
  - assets/gos.jpg

## Estructura del proyecto

assets -
         > dam2.png
         > DES.png
         > gordo.png
         > gos.png
         > imatge.png
         > logoApp.png
         

lib  - 
       > createPost.dart
       > db.dart
       > feed.dart
       > login.dart
       > profile.dart
       > comentaris.dart
       > register.dart
       > idioma.dart
       > main.dart
       
       themes -
         >temaClaro.dart
         >temaOscuro.dart

Lo primero que se abre es el main, el cual decide que tema se está usando y se lo otorga a todos las demás páginas. 
El main te redirige al login, desde donde puedes ir a Register para registrarte, o, iniciar sesión y entrar al feed.
El feed te mustra todos los cards (posts) disponibles del más reciente al más antiguo, desde aquí puedes entrar a cualquier publicación para escribir comentarios o dar un like a cualquier publicación.
Desde el feed se puede abrir el profile, donde puedes cambiar los temas.
En feed tambien puedes acceder a createPost, donde se pueden crear nuevos post, con una descripción personalizada y un desplegable de imagenes de muestra en forma de card que saldrán en el feed.

## Funcionalidades implementadas

Se ha implementado una función para subir los datos de registro a la BD, una para el login, otra para crear un post (parecido a un registro, insertar datos pero con distintos formatos), una función para añadir comentarios, otra para recibirlos, otra para dar un like con un getter del currentUser para controlar que el usuario no de más de un like en una publicación i finalmente un getter con todos los posts. Se crean todas las tablas al principio del archivo db.dart .

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class db {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 🔹 USUARIO ACTUAL
  static Future<String?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('currentUser');
  }

  // 🔹 LOGIN
  static Future<bool> login(String user, String pass) async {
    try {
      final result = await _firestore
          .collection('users')
          .where('user', isEqualTo: user)
          .get();

      if (result.docs.isEmpty) return false;

      final userData = result.docs.first.data();

      return userData['pass'] == pass;
    } catch (e) {
      print("Error login: $e");
      return false;
    }
  }
  // 🔹 REGISTER
  static Future<String?> register(String user, String pass) async {
    try {
      final exists = await _firestore
          .collection('users')
          .where('user', isEqualTo: user)
          .get();

      if (exists.docs.isNotEmpty) {
        return "El usuario ya existe";
      }

      await _firestore.collection('users').add({
        'user': user,
        'pass': pass,
        'posts': 0,
      });

      return null; // OK
    } catch (e) {
      print("Error register: $e");
      return "Error al registrar usuario";
    }
  }

  // 🔹 CREAR POST
  static Future<void> createPost(
      String rutaImagen, String user, String desc, String fecha) async {
    await _firestore.collection('posts').add({
      'rutaImagen': rutaImagen,
      'user': user,
      'desc': desc,
      'fecha': Timestamp.now(), // 🔥 importante
      'likesCount': 0,
      'comentariosCount': 0,
    });
  }

  // 🔹 OBTENIR POSTS
  static Future<List<Map<String, dynamic>>> getPosts() async {
    final user = await getCurrentUser();

    final snapshot = await _firestore
        .collection('posts')
        .orderBy('fecha', descending: true)
        .get();

    List<Map<String, dynamic>> posts = [];

    for (var doc in snapshot.docs) {
      final data = doc.data();

      // 🔥 comprovar si l'usuari ha fet like
      final likeDoc = await _firestore
          .collection('posts')
          .doc(doc.id)
          .collection('likes')
          .doc(user)
          .get();

      posts.add({
        'id': doc.id,
        ...data,
        'isLiked': likeDoc.exists,
      });
    }

    return posts;
  }

  // 🔹 LIKE / UNLIKE
  static Future<void> like(String postId) async {
    final user = await getCurrentUser();
    if (user == null) return;

    final likeRef = _firestore
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(user);

    final doc = await likeRef.get();

    if (doc.exists) {
      // 🔥 UNLIKE
      await likeRef.delete();

      await _firestore.collection('posts').doc(postId).update({
        'likesCount': FieldValue.increment(-1),
      });
    } else {
      // 🔥 LIKE
      await likeRef.set({'liked': true});

      await _firestore.collection('posts').doc(postId).update({
        'likesCount': FieldValue.increment(1),
      });
    }
  }

  // 🔹 OBTENIR COMENTARIS
  static Future<List<Map<String, dynamic>>> getComentarios(
      String postId) async {
    final snapshot = await _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('fecha', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      return {
        'id': doc.id,
        ...doc.data(),
      };
    }).toList();
  }

  // 🔹 AFEGIR COMENTARI
  static Future<void> addComentario(
      String postId, String user, String contenido, String fecha) async {
    await _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .add({
      'user': user,
      'contenido': contenido, // 🔥 IMPORTANT (igual que UI)
      'fecha': Timestamp.now(),
    });

    await _firestore.collection('posts').doc(postId).update({
      'comentariosCount': FieldValue.increment(1),
    });
  }
}
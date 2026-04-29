import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class db {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Usuari actual (igual que abans)
  static Future<String?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('currentUser');
  }

  // LOGIN (simulat com tenies)
  static Future<bool> login(String user, String pass) async {
    final result = await _firestore
        .collection('users')
        .where('user', isEqualTo: user)
        .where('pass', isEqualTo: pass)
        .get();

    return result.docs.isNotEmpty;
  }

  // REGISTER
  static Future<void> register(String user, String pass) async {
    await _firestore.collection('users').add({
      'user': user,
      'pass': pass,
      'posts': 0,
    });
  }

  // CREAR POST
  static Future<void> createPost(
      String rutaImagen, String user, String desc, String fecha) async {
    await _firestore.collection('posts').add({
      'rutaImagen': rutaImagen,
      'user': user,
      'desc': desc,
      'fecha': fecha,
      'likesCount': 0,
      'comentariosCount': 0,
    });
  }

  // OBTENIR POSTS
  static Future<List<Map<String, dynamic>>> getPosts() async {
    final snapshot = await _firestore
        .collection('posts')
        .orderBy('fecha', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      return {
        'id': doc.id,
        ...doc.data(),
      };
    }).toList();
  }

  // LIKE
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
      // Treure like
      await likeRef.delete();

      await _firestore.collection('posts').doc(postId).update({
        'likesCount': FieldValue.increment(-1),
      });
    } else {
      // Donar like
      await likeRef.set({'liked': true});

      await _firestore.collection('posts').doc(postId).update({
        'likesCount': FieldValue.increment(1),
      });
    }
  }

  // GET COMENTARIS
  static Future<List<Map<String, dynamic>>> getComentarios(
      String postId) async {
    final snapshot = await _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('fecha', descending: true)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  // AFEGIR COMENTARI
  static Future<void> addComentario(
      String postId, String user, String contenido, String fecha) async {
    await _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .add({
      'user': user,
      'text': contenido,
      'fecha': fecha,
    });

    await _firestore.collection('posts').doc(postId).update({
      'comentariosCount': FieldValue.increment(1),
    });
  }
}
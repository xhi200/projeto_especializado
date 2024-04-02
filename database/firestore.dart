import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/*

This database stores posts 
that users have published in the app.

It is stored in a collection called 'Posts' in Firebase

Each post contains;
- a message
- email of user
- timestamp

*/

class FirestoreDatabase {
  // current logged in user
  User? user = FirebaseAuth.instance.currentUser;

  // get collection of posts from firebase
  final CollectionReference posts =
      FirebaseFirestore.instance.collection('Post');

  // post a message
  Future<void> addPost(String message, String nomeEvento) {
    return posts.doc(nomeEvento).collection('comment').add({
      'UserEmail': user!.email,
      'PostMessage': message,
      'TimeStamp': Timestamp.now(),
    });
  }

// read Likes from database
  Stream<QuerySnapshot> getLikesStream(String name) {
    if (user != null) {
      final likesStream = FirebaseFirestore.instance
          .collection('Like')
          .doc(name)
          .collection('usersLike')
          .snapshots();

      return likesStream;
    } else {
      // Lidar com o caso em que o usuário não está autenticado
      return Stream.empty();
    }
  }

  // read cart from database
  Stream<QuerySnapshot> getCartStream() {
    if (user != null) {
      final cartStream = FirebaseFirestore.instance
          .collection('Users')
          .doc(user!.email)
          .collection('cart')
          .snapshots();

      return cartStream;
    } else {
      // Lidar com o caso em que o usuário não está autenticado
      return Stream.empty();
    }
  }

  // read posts from database
  Stream<QuerySnapshot> getPostsStream(String nomeEvento) {
    final postsStream = FirebaseFirestore.instance
        .collection('Post')
        .doc(nomeEvento)
        .collection('comment')
        .orderBy('TimeStamp', descending: true)
        .snapshots();

    return postsStream;
  }
}

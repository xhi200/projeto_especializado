import 'package:debrave_v2/components/my_app_bar.dart';
import 'package:debrave_v2/components/my_bottom_navigation_bar.dart';
import 'package:debrave_v2/components/my_list_tile.dart';
import 'package:debrave_v2/components/my_textfield.dart';
import 'package:debrave_v2/database/firestore.dart';
import 'package:debrave_v2/models/event.dart';
import 'package:flutter/material.dart';

class EventCommentPage extends StatelessWidget {
  Event evento;
  EventCommentPage({super.key, required this.evento});

  // firestore access
  final FirestoreDatabase database = FirestoreDatabase();

  final TextEditingController newPostController = TextEditingController();

  // method to post a message
  /*void postMessage(String nome) {
    // only post if there is something in the textfield
    if (newPostController.text.isNotEmpty) {
      String message = newPostController.text;
      database.addPost(message);
    }

    // clear the controller
    newPostController.clear();
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(text: 'COMENTÁRIOS'),
      bottomNavigationBar: MyBottomNavigationBar(),
      backgroundColor: Colors.grey[300],
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: MyTextField(
                      hintText: 'Escrever...',
                      obscureText: false,
                      controller: newPostController),
                ),
                const SizedBox(width: 5),
                IconButton(
                  onPressed: () {
                    // only post if there is something in the textfield
                    if (newPostController.text.isNotEmpty) {
                      String message = newPostController.text;
                      database.addPost(message, evento.name);
                    }

                    // clear the controller
                    newPostController.clear();
                  },
                  icon: const Icon(Icons.send_rounded),
                ),
              ],
            ),

            const SizedBox(height: 10),
            // Post
            StreamBuilder(
              stream: database.getPostsStream(evento.name),
              builder: (context, snapshot) {
                // show loading circle
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // get all posts
                final posts = snapshot.data!.docs;

                // no data?
                if (snapshot.data == null || posts.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(25),
                      child: Text('Sem comentários... Escreva alguma coisa!'),
                    ),
                  );
                }

                // return as a list
                return Expanded(
                  child: ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      // get each individual post
                      final post = posts[index];

                      // get data from each post
                      String message = post['PostMessage'];
                      String userEmail = post['UserEmail'];

                      // return as a list tile
                      return MyListTile(
                        title: message,
                        subTitle: userEmail,
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

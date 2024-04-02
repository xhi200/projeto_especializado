import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:debrave_v2/components/like_buttom.dart';
import 'package:debrave_v2/components/my_app_bar.dart';
import 'package:debrave_v2/components/my_bottom_navigation_bar.dart';
import 'package:debrave_v2/components/my_buttom.dart';
import 'package:debrave_v2/database/firestore.dart';
import 'package:debrave_v2/models/event.dart';
import 'package:debrave_v2/models/event_shop.dart';
import 'package:debrave_v2/pages/event_comment_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventDetailsPage extends StatefulWidget {
  final Event event;

  EventDetailsPage({
    super.key,
    required this.event,
  });

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  // user
  final currentUser = FirebaseAuth.instance.currentUser!;
  // firestore access
  final FirestoreDatabase database = FirestoreDatabase();
  bool isLiked = false;

  void toggleLike(Event evento) async {
    if (!isLiked) {
      // if the event is now liked, add the user's email
      FirebaseFirestore.instance
          .collection('Like')
          .doc(evento.name)
          .collection('usersLike')
          .add({
        'Likes': currentUser.email,
      });
    } else {
      // Consulta para obter o usuario
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Like')
          .doc(evento.name)
          .collection('usersLike')
          .where('Likes', isEqualTo: currentUser.email)
          .get();

      // Verifica se a consulta retornou algum documento
      if (querySnapshot.docs.isNotEmpty) {
        // Obtém o ID do primeiro documento retornado pela consulta
        String documentId = querySnapshot.docs[0].id;

        // Referência ao documento no Firestore com base no ID obtido
        DocumentReference documentReference = FirebaseFirestore.instance
            .collection('Like')
            .doc(evento.name)
            .collection('usersLike')
            .doc(documentId);

        // Remove o documento do Firestore
        await documentReference.delete();
      }
    }
    setState(() {
      isLiked = !isLiked;
    });
  }

  void addToCart(BuildContext context, Event evento) {
    // get acess to cart
    //final meusEventos = context.read<EventShop>();

    // add to cart
    //meusEventos.addToCart(widget.event);

    // MOSTRAR NOTIFICAÇÃO
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.blue,
        content: const Text(
          "Adicionar ao Meus Eventos?",
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        actions: [
          // CANCELAR BOTÃO
          IconButton(
            onPressed: () {
              // pop to remove dialog box
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.cancel,
              color: Colors.white,
            ),
          ),

          // CONFIRMAR BOTÃO
          IconButton(
            onPressed: () {
              // pop to remove dialog box
              Navigator.pop(context);

              // add to cart
              context.read<EventShop>().addToCart(evento);
            },
            icon: const Icon(
              Icons.done,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: MyAppBar(text: widget.event.name),
      bottomNavigationBar: const MyBottomNavigationBar(),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              // IMAGEM
              child: Image.asset(
                widget.event.imagePath,
                height: 200,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    // NOME DO EVENTO
                    Text(
                      widget.event.name,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // DATA DO EVENTO
                    Text(
                      'Dia(s): ${widget.event.date}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),

                // BOTÃO LIKE
                StreamBuilder(
                  stream: database.getLikesStream(widget.event.name),
                  builder: (context, snapshot) {
                    // show loading circle
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    // get all likes
                    final likes = snapshot.data!.docs;

                    // no data?
                    /*if (snapshot.data == null || likes.isEmpty) {
                      return Column(
                        children: [
                          LikeButtom(
                            isLiked: isLiked,
                            onTap: () => toggleLike(widget.event),
                          ),
                          Text(likes.length.toString())
                        ],
                      );
                    }*/

                    isLiked =
                        likes.any((doc) => doc['Likes'] == currentUser.email);

                    return Column(
                      children: [
                        LikeButtom(
                          isLiked: isLiked,
                          onTap: () => toggleLike(widget.event),
                        ),
                        Text(likes.length.toString())
                      ],
                    );
                  },
                ),

                // BOTÃO ADICIONAR
                ClipOval(
                  child: Material(
                    color: const Color.fromRGBO(0, 95, 135, 1),
                    child: IconButton(
                      onPressed: () => addToCart(context, widget.event),
                      icon: const Icon(
                        Icons.add,
                        size: 32,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Divider(
                color: Color.fromRGBO(0, 95, 135, 1),
                thickness: 2,
              ),
            ),
            const Text(
              'Descrição:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    widget.event.descricao,
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            MyButton(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EventCommentPage(evento: widget.event),
                    )),
                text: 'Comentar'),
          ],
        ),
      ),
    );
  }
}

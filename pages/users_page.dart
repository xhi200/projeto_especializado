import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:debrave_v2/components/my_app_bar.dart';
import 'package:debrave_v2/components/my_bottom_navigation_bar.dart';
import 'package:debrave_v2/database/firestore.dart';
import 'package:debrave_v2/models/event.dart';
import 'package:debrave_v2/models/event_shop.dart';
import 'package:debrave_v2/pages/event_detailsV2_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyEventsPage extends StatelessWidget {
  MyEventsPage({super.key});

  final FirestoreDatabase database = FirestoreDatabase();

  // remove item from the cart method
  void removeItemFromCart(BuildContext context, Event evento) {
    // MOSTRAR NOTIFICAÇÃO PARA EXCLUIR
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.blue,
        content: const Text(
          "Remover do Meus Eventos?",
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
            onPressed: () async {
              // pop to remove dialog box
              Navigator.pop(context);

              // add to cart
              //context.read<EventShop>().removeFromCart(evento);

              // remove from cart
              context.read<EventShop>().removeFromCart(evento);
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
    return StreamBuilder<QuerySnapshot>(
      stream: database.getCartStream(),
      builder: (context, snapshot) {
        // show loading circle
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        // Se snapshot tem dados
        if (snapshot.hasData) {
          // Obter todos os documentos (itens do carrinho)
          final cart = snapshot.data!.docs;

          return Scaffold(
            backgroundColor: Colors.grey[300],
            appBar: MyAppBar(text: 'M E U S   E V E N T O S'),
            bottomNavigationBar: MyBottomNavigationBar(),
            body: Column(
              children: [
                // CART LIST
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      // get individual item in cart
                      final item = cart[index];

                      // Extrair dados do documento para criar um objeto Event
                      Event event = Event(
                        name: item['name'],
                        date: item['date'],
                        imagePath: item['imagePath'] ??
                            'Caminho da imagem não disponível',
                        descricao:
                            item['descricao'] ?? 'Descrição não disponível',
                      );

                      // return as a cart tile UI
                      return ListTile(
                        title: Text(event.name),
                        subtitle: Text(event.date),
                        trailing: IconButton(
                          onPressed: () => removeItemFromCart(context, event),
                          icon: Icon(Icons.remove),
                        ),
                        leading: IconButton(
                          icon: Icon(Icons.info),
                          onPressed: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventDetailsPage(
                                event: event,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          // Se não há dados, você pode exibir uma mensagem ou um widget alternativo
          return Center(
            child: Text('Nenhum item no carrinho.'),
          );
        }
      },
    );
  }
}

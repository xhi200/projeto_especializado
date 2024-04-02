import 'package:debrave_v2/components/my_app_bar.dart';
import 'package:debrave_v2/components/my_bottom_navigation_bar.dart';
import 'package:debrave_v2/components/my_event_tile.dart';
import 'package:debrave_v2/components/my_textfield.dart';
import 'package:debrave_v2/models/event_shop.dart';
import 'package:debrave_v2/pages/event_detailsV2_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final TextEditingController searchInputController = TextEditingController();

  // navegar para o evento
  void navigateToEventDetails(BuildContext context, index) {
    // get the event cart and it's menu
    final cart = Provider.of<EventShop>(context, listen: false);
    final eventMenu = cart.eventShop;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailsPage(
          event: eventMenu[index],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // access events in event_shop
    final eventos = context.watch<EventShop>().eventShop;

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: const MyAppBar(
        text: 'H O M E',
      ),
      bottomNavigationBar: const MyBottomNavigationBar(),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: MyTextField(
                    hintText: 'Buscar...',
                    obscureText: false,
                    controller: searchInputController,
                  ),
                ),
                const SizedBox(width: 10),
                ClipOval(
                  child: Image.asset(
                    'lib/images/logoDebrave.png',
                    height: 75,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Text(
              "Eventos",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 10),

            // eventos
            Flexible(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: eventos.length,
                itemBuilder: (context, index) {
                  // pega cada evento individualmente do EventShop
                  final event = eventos[index];

                  // retorna como Evento Tile UI
                  return MyEventTile(
                    event: event,
                    onTap: () => navigateToEventDetails(context, index),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:debrave_v2/models/event.dart';
import 'package:flutter/material.dart';

class MyEventTile extends StatelessWidget {
  final Event event;
  final void Function()? onTap;

  const MyEventTile({
    super.key,
    required this.event,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(
          left: 25,
          bottom: 50,
        ),
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Foto do Evento
            Image.asset(
              event.imagePath,
              height: 140,
            ),

            // Nome do Evento
            Text(
              event.name,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),

            // date
            SizedBox(
              width: 160,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // price
                  Text(
                    'Dia(s): ${event.date}',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            //const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}

import 'package:debrave_v2/components/my_app_bar.dart';
import 'package:debrave_v2/components/my_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

class EventDetailsPage0 extends StatelessWidget {
  const EventDetailsPage0({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(text: 'Event Details'),
      bottomNavigationBar: MyBottomNavigationBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'lib/images/abacate.png',
              height: 200,
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Festa do Abacate',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/event_comment'),
                    icon: Icon(
                      Icons.comment,
                      size: 40,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

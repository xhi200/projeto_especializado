import 'package:flutter/material.dart';

class MyBottomNavigationBar extends StatelessWidget {
  const MyBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color.fromRGBO(0, 95, 135, 1),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white,
      items: [
        // home
        BottomNavigationBarItem(
          icon: IconButton(
            icon: Icon(
              Icons.home,
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/home_page');
            },
          ),
          label: 'Home',
        ),

        // Meus Eventos
        BottomNavigationBarItem(
          icon: IconButton(
            icon: Icon(Icons.event),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/my_events_page');
            },
          ),
          label: 'Meus Eventos',
        ),

        // Perfil
        BottomNavigationBarItem(
          icon: IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/profile_page');
            },
          ),
          label: 'Perfil',
        )
      ],
    );
  }
}

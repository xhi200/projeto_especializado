import 'package:debrave_v2/auth/auth.dart';
import 'package:debrave_v2/auth/login_or_register.dart';
import 'package:debrave_v2/firebase_options.dart';
import 'package:debrave_v2/models/event_shop.dart';
import 'package:debrave_v2/pages/event_details_page.dart';
import 'package:debrave_v2/pages/home_page.dart';
import 'package:debrave_v2/pages/profile_page.dart';
import 'package:debrave_v2/pages/users_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ChangeNotifierProvider(
    create: (context) => EventShop(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthPage(),
      routes: {
        '/login_register_page': (context) => const LoginOrRegister(),
        '/home_page': (context) => HomePage(),
        '/profile_page': (context) => ProfilePage(),
        '/my_events_page': (context) => MyEventsPage(),
        '/event_details': (context) => EventDetailsPage0(),
        //'/event_comment': (context) => EventCommentPage(),
      },
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:debrave_v2/components/my_app_bar.dart';
import 'package:debrave_v2/components/my_bottom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  // logout
  void logout(BuildContext context) {
    FirebaseAuth.instance.signOut();
    Navigator.pushNamed(context, '/login_register_page');
  }

  // current logged in user
  User? currentUser = FirebaseAuth.instance.currentUser;

  // future to fetch user details
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser!.email)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: const MyAppBar(text: 'P E R F I L'),
      bottomNavigationBar: const MyBottomNavigationBar(),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: getUserDetails(),
        builder: (context, snapshot) {
          // loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // error
          else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          // data receive
          else if (snapshot.hasData) {
            // extract data
            Map<String, dynamic>? user = snapshot.data!.data();

            return Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // profile pic
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          child: const Icon(
                            Icons.person,
                            size: 64,
                          ),
                        ),

                        // email
                        Text(
                          user!['username'],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        // username
                        Text(
                          user['email'],
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // text logout
                        GestureDetector(
                          onTap: () {
                            FirebaseAuth.instance.signOut();
                            Navigator.pushReplacementNamed(
                                context, '/login_register_page');
                          },
                          child: Text(
                            'Logout',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        // logout button
                        IconButton(
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                            Navigator.pushReplacementNamed(
                                context, '/login_register_page');
                          },
                          icon: Icon(
                            Icons.logout,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 5),
                  ],
                ),
              ),
            );
          } else {
            return const Text('No data');
          }
        },
      ),
    );
  }
}

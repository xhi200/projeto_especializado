import 'package:debrave_v2/components/my_buttom.dart';
import 'package:debrave_v2/components/my_textfield.dart';
import 'package:debrave_v2/helper/help_function.dart';
import 'package:debrave_v2/models/event_shop.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text controllers
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  void login() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      context.read<EventShop>().retrieveCartFromFirestore();

      // pop the loading circle
      if (context.mounted) Navigator.pop(context);
      Navigator.pushReplacementNamed(context, '/home_page');
    }

    // display errors
    on FirebaseAuthException catch (e) {
      // pop loading circle
      Navigator.pop(context);
      displayMessageToUser(e.code, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 95, 135, 1),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // logo
                Image.asset(
                  'lib/images/logoDebrave.png',
                  height: 280,
                ),

                const SizedBox(height: 25),

                // email
                MyTextField(
                  hintText: "E-mail",
                  obscureText: false,
                  controller: emailController,
                ),

                const SizedBox(height: 10),

                // senha
                MyTextField(
                  hintText: "Senha",
                  obscureText: true,
                  controller: passwordController,
                ),

                const SizedBox(height: 25),

                // Sign in buttom
                MyButton(
                  onTap: login,
                  text: 'Entrar',
                ),

                const SizedBox(height: 25),

                // registrar um conta
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Não tem uma conta?',
                      style: TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    GestureDetector(
                      child: const Text(
                        ' Cadastre-se Aqui',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: widget.onTap,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

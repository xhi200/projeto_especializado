import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:debrave_v2/components/my_buttom.dart';
import 'package:debrave_v2/components/my_textfield.dart';
import 'package:debrave_v2/helper/help_function.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text controllers
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // register method
  void registerUser() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // make sure password match
    if (passwordController.text != confirmPasswordController.text) {
      // pop loading circle
      Navigator.pop(context);

      // shoe error message to user
      displayMessageToUser('As Senhas não são iguais', context);
    }

    // if password do match
    else {
      // try create user
      try {
        // create user
        UserCredential? userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // cria um documento de usuário e adiciona ao firestore
        createUserDocument(userCredential);

        // pop loading circle
        if (context.mounted) Navigator.pop(context);
        Navigator.pushReplacementNamed(context, '/home_page');
      } on FirebaseAuthException catch (e) {
        // pop the circle
        Navigator.pop(context);

        // display error message to user
        displayMessageToUser(e.code, context);
      }
    }
  }

  // cria um documento de usuário e armazena no firestore
  Future<void> createUserDocument(UserCredential? userCredential) async {
    if (userCredential != null && userCredential.user != null) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email)
          .set({
        'email': userCredential.user!.email,
        'username': userNameController.text,
      });
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

                // username
                MyTextField(
                  hintText: "Nome do Usuário",
                  obscureText: false,
                  controller: userNameController,
                ),

                const SizedBox(height: 10),

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

                const SizedBox(height: 10),

                // confirmar senha
                MyTextField(
                  hintText: "Confirmar Senha",
                  obscureText: true,
                  controller: confirmPasswordController,
                ),

                const SizedBox(height: 25),

                // Sign in buttom
                MyButton(
                  onTap: registerUser,
                  text: 'Cadastrar',
                ),

                const SizedBox(height: 25),

                // registrar um conta
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Já tem uma conta?',
                      style: TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    GestureDetector(
                      child: const Text(
                        ' Entre Aqui',
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

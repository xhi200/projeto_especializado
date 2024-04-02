import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:debrave_v2/models/event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EventShop extends ChangeNotifier {
  // event menu
  final List<Event> _eventShop = [
    Event(
        name: 'Oktoberfest',
        date: '05/05/1999',
        imagePath: "lib/images/oktoberfest.png",
        descricao:
            'A melhor festa da cerveja de todos os tempos, em BLUMENAU!'),
    Event(
        name: 'Febratex',
        date: '05/68/2686',
        imagePath: 'lib/images/febratex.png',
        descricao: 'A maior feira da indústria têxtil em BLUMENAU!'),
    Event(
        name: 'Linguição',
        date: '02/08/0466',
        imagePath: 'lib/images/linguicao.png',
        descricao: 'A Festa!'),
    Event(
        name: 'Sommerfest',
        date: '4/5/666',
        imagePath: 'lib/images/sommerfest.png',
        descricao: 'Mais uma festa da cerveja em Blumenau! Mas no verão'),
  ];

  // my events
  List<Event> _cart = [];

  // get event list
  List<Event> get eventShop => _eventShop;

  // get user cart
  List<Event> get cart => _cart;

  // add to cart
  /*void addToCart(Event item) {
    _cart.add(item);
    notifyListeners();
  }*/

  // remove from cart
  /*void removeFromCart(Event item) {
    _cart.remove(item);
    notifyListeners();
  }*/

  // remove from cart
  void removeFromCart(Event item) async {
    _cart.remove(item);
    notifyListeners();

    // current logged in user
    User? currentUser = FirebaseAuth.instance.currentUser;

    // Consulta para obter o ID do documento com base no nome do item
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser!.email)
        .collection('cart')
        .where('name', isEqualTo: item.name)
        .get();

    // Verifica se a consulta retornou algum documento
    if (querySnapshot.docs.isNotEmpty) {
      // Obtém o ID do primeiro documento retornado pela consulta
      String documentId = querySnapshot.docs[0].id;

      // Referência ao documento no Firestore com base no ID obtido
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser.email)
          .collection('cart')
          .doc(documentId);

      // Remove o documento do Firestore
      await documentReference.delete();
    }
  }

  void addToCart(Event item) async {
    _cart.add(item);
    notifyListeners();

    // current logged in user
    User? currentUser = FirebaseAuth.instance.currentUser;

    // Armazenar no Firestore
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser!.email)
        .collection('cart')
        .add({
      'name': item.name,
      'date': item.date,
      'imagePath': item.imagePath,
      'descricao': item.descricao,
    });
  }

  void retrieveCartFromFirestore() async {
    // current logged in user
    User? currentUser = FirebaseAuth.instance.currentUser;

    // Recuperar dados do Firestore
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance
            .collection('Users') // Substitua por sua coleção de usuários
            .doc(currentUser!.email) // Substitua pelo ID do usuário logado
            .collection('cart')
            .get();

    // Limpar carrinho existente
    _cart.clear();

    // Adicionar itens recuperados ao carrinho local
    querySnapshot.docs.forEach((doc) {
      _cart.add(
        Event(
          name: doc['name'],
          date: doc['date'],
          imagePath: doc['imagePath'],
          descricao: doc['descricao'],
        ),
      );
    });

    notifyListeners();
  }
}

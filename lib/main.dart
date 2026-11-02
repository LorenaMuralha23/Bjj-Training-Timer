import 'package:flutter/material.dart';
import 'ui/home.dart';

void main() {
  runApp(const MyApp());
}

// Estrutura stateless que ira a estrutura principal do app
//O StatelessWidget não significa que o aplicativo inteiro é imutável. Significa que esse Widget não gerencia um estado mutável próprio.
//No seu exemplo, ScaffoldMainApp não precisa controlar nenhuma informação variável. Ele apenas configura o MaterialApp.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const ScaffoldHome()
    );
  }
}




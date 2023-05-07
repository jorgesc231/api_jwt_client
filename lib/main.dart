import 'package:flutter/material.dart';
import 'package:user_jwt_client/screens/register_screen.dart';
import 'package:user_jwt_client/screens/welcome_screen.dart';
import 'package:user_jwt_client/screens/config_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Cuando se retorna un objeto, el new es implicito
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      routes: {
        '/': (context) => const ServerConfig(),
        '/login': (context) => const RegisterScreen(),
        '/welcome': (context) => const WelcomeScreen(),
      },
      initialRoute: '/',
      // Si se usa initialRoute no se puede especificar un home
      //home: IntroScreen()
    );
  }
}

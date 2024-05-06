
import 'package:car_mate/map_text.dart';
import 'package:flutter/material.dart';

import 'login_async.dart';
import 'home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Mate',
      initialRoute: '/',
      routes: {
        '/': (context) => /*LoginScreen()*/ HomeScreen(),
        '/home': (context) => const HomeScreen(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: Colors.black,
        )
      ),
    );
  }
}


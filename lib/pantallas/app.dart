import 'package:flutter/material.dart';

import 'home.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
      title: "database",
      theme: ThemeData(
          primarySwatch: Colors.brown,
          primaryColor: Colors.black,
          useMaterial3: true),
      home: const Home(),
    );
  }
}

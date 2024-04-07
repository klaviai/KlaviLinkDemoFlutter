import 'package:flutter/material.dart';
import 'package:klavi_link_demo_flutter/router.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Klavi Link Demo',
      routerConfig: router,
      theme: ThemeData(
        useMaterial3: true,
      ),
    );
  }
}

import 'package:flutter/material.dart';

class RedirectPage extends StatelessWidget {
  const RedirectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Redirect'),
        ),
        body: const Text('redirect success'));
  }
}

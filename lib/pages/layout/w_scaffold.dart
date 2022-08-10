import 'package:flutter/material.dart';

class WScaffold extends StatelessWidget {
  const WScaffold({
    Key? key,
    required this.body,
    this.floatingActionButton,
  }) : super(key: key);

  final Widget body;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wager'),
        centerTitle: true,
        leading: const SizedBox(),
      ),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}

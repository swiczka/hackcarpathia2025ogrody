import 'package:flutter/material.dart';

class AddPlant extends StatelessWidget {
  const AddPlant({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dodaj Roślinkę'),
      ),
      body: const Center(
        child: Text(
          'Strona dodawania rośliny',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
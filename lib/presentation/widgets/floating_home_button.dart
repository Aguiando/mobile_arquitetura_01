import 'package:flutter/material.dart';

class FloatingHomeButton extends StatelessWidget {
  const FloatingHomeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'home_btn',
      onPressed: () => Navigator.pushNamedAndRemoveUntil(
        context,
        '/home',
        (route) => false,
      ),
      tooltip: 'Ir para Home',
      backgroundColor: Colors.deepPurple.withOpacity(0.85),
      child: const Icon(Icons.home, color: Colors.white),
    );
  }
}
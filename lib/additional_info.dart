import 'package:flutter/material.dart';

class Additional extends StatelessWidget {
  final IconData icon;
  final String text;
  final String value;
  const Additional(
      {super.key, required this.icon, required this.text, required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Column(
              children: [
                Icon(
                  icon,
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(text),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

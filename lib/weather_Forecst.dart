import 'package:flutter/material.dart';

class Hourly extends StatelessWidget {
  final IconData icons;
  final String time;
  final String value;
  const Hourly({
    super.key,
    required this.icons,
    required this.time,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Card(
        elevation: 6,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: Column(
            children: [
              Text(
                time,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Icon(
                icons,
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }
}

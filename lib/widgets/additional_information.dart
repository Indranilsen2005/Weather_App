import 'package:flutter/material.dart';

class AdditionalInformation extends StatelessWidget {
  const AdditionalInformation({
    super.key,
    this.iconColor = Colors.white,
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      width: 120,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              icon,
              size: 50,
              color: iconColor,
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

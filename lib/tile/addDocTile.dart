import 'package:flutter/material.dart';

class DocTile extends StatelessWidget {
  const DocTile(
      {super.key, required this.name, required this.icon, required this.onTap});
  final String name;
  final Icon icon;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shadowColor: Theme.of(context).shadowColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center vertically
            crossAxisAlignment:
                CrossAxisAlignment.center, // Center horizontally
            children: [
              icon,
              const SizedBox(height: 8), // Spacing between icon and text
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

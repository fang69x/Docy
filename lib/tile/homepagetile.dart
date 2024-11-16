import 'package:flutter/material.dart';

class HomeTile extends StatelessWidget {
  const HomeTile({
    super.key,
    required this.icon,
    required this.onTap,
    required this.name,
  });

  final String name;
  final Icon icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300), // Animation duration
        curve: Curves.easeInOut, // Smooth animation curve
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor, // Dynamic color based on theme
          borderRadius: BorderRadius.circular(16.0), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4), // Subtle shadow for elevation effect
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center vertically
            crossAxisAlignment:
                CrossAxisAlignment.center, // Center horizontally
            children: [
              AnimatedScale(
                duration: const Duration(
                    milliseconds: 200), // Animation duration for icon
                scale: 1.2, // Scale up the icon when hovered
                child: icon,
              ),
              const SizedBox(height: 8), // Spacing between icon and text
              AnimatedDefaultTextStyle(
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .color, // Text color based on theme
                ),
                duration: const Duration(
                    milliseconds: 200), // Animation duration for text
                child: Text(name),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8,
          children: [
            // Animated number placeholder
            SizedBox(
              height: 50,
              child: Center(
                child: Text(
                  '0', // Placeholder for animated number
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Text(
              'days',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'Keep pushing forward! You got this!',
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
            Divider(),
            // List of goals
            Text(
              'Goals:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            GoalItem(icon: Icons.check, label: 'Exercise', onPressed: () {}),
            GoalItem(icon: Icons.book, label: 'Read a book', onPressed: () {}),
            GoalItem(icon: Icons.whatshot_outlined, label: 'Meditate', onPressed: () {}),
          ],
        ),
      ),
    );
  }
}

class GoalItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const GoalItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon),
            SizedBox(width: 8),
            Text(label),
          ],
        ),
        ElevatedButton(
          onPressed: onPressed,
          child: Text('Done'),
        ),
      ],
    );
  }
}
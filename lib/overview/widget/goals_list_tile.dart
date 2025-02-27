import 'package:flutter/material.dart';

class GoalsListTile extends StatelessWidget {
  const GoalsListTile({
    super.key,
    required this.name,
    this.iconDataCodePoint,
    this.timestampAchieved,
    this.onPressed,
  });

  final String name;
  final int? iconDataCodePoint;
  final int? timestampAchieved;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(IconData(iconDataCodePoint ?? 128312, fontFamily: 'NotoEmoji')),
            SizedBox(width: 8),
            Text(name)
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
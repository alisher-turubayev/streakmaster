import 'package:flutter/material.dart';

class StreakHeroWidget extends StatelessWidget {
  const StreakHeroWidget({
    super.key,
    required this.days,
  });

  final int days;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16), 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // TODO: animated number
          SizedBox(
            height: 50,
            child: Center(
              child: Text(
                days.toString(),
                style: TextTheme.of(context).displayMedium
              ),
            ),
          ),
          Text(
            'days',
            style: TextTheme.of(context).bodyLarge,
          ),
          Text(
            'Keep pushing forward! You got this!',
            style: TextTheme.of(context).labelMedium
          ),
        ],
      ),
    );
  }
}
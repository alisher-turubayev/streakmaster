import 'package:flutter/material.dart';

class Milestone {
  final String name;
  final String description;
  final bool isComplete;

  Milestone({
    required this.name,
    required this.description,
    required this.isComplete,
  });
}

class GoalViewScreen extends StatelessWidget {
  final List<Milestone> milestones = [
    Milestone(name: 'Lose 1 kg', description: 'From starting weight of 88 kg', isComplete: false),
    Milestone(name: 'Lose 5 kg', description: 'From starting weight of 88 kg', isComplete: false),
  ];

  GoalViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(IconData(128205, fontFamily: 'NotoEmoji',)),
                  const Text('Started on:'),
                  const Text('22nd Oct. 2024')
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(IconData(128293, fontFamily: 'NotoEmoji',)),
                  const Text('Streak days:'),
                  const Text('10')
                ],
              )
            ],
          ),
          Text(
            'Milestones:',
            style: TextTheme.of(context).titleMedium,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: milestones.length,
              itemBuilder: (context, index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(milestones[index].name),
                        Text(milestones[index].description, style: TextTheme.of(context).labelSmall),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {},
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
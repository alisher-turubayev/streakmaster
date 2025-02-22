import 'package:flutter/material.dart';

class GoalsListScreen extends StatelessWidget {
  final List<Goal> goals = [
    Goal(
      title: 'Exercise',
      streakDays: 5,
      milestones: ['Run 5km', 'Lift weights', 'Yoga'],
      completedMilestones: [true, false, true],
    ),
    Goal(
      title: 'Read a Book',
      streakDays: 3,
      milestones: ['Chapter 1', 'Chapter 2', 'Chapter 3'],
      completedMilestones: [false, true, false],
    ),
    Goal(
      title: 'Meditate',
      streakDays: 7,
      milestones: ['Morning meditation', 'Evening meditation'],
      completedMilestones: [true, true],
    ),
  ];

  GoalsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: goals.length + 1,
      itemBuilder: (context, index) {
        if (index < goals.length) {
          return GoalCard(goal: goals[index]);
        } else {
          return AddGoalCard();
        }
      },
    );
  }
}

class Goal {
  final String title;
  final int streakDays;
  final List<String> milestones;
  final List<bool> completedMilestones;

  Goal({
    required this.title,
    required this.streakDays,
    required this.milestones,
    required this.completedMilestones,
  });
}

class GoalCard extends StatelessWidget {
  final Goal goal;

  const GoalCard({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animation placeholder
            // Goal title
            Text(
              goal.title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            // Streak days
            Text('Streak days: ${goal.streakDays}'),
            Divider(),
            // Milestones
            ListView.builder(
              shrinkWrap: true,
              itemCount: goal.milestones.length,
              itemBuilder: (context, index) {
                return Text(
                  goal.milestones[index],
                  style: TextStyle(
                    decoration: goal.completedMilestones[index]
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                );  
              },
            ),
            // Edit button
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  // Handle edit action
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddGoalCard extends StatelessWidget {
  const AddGoalCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 0,
      color: Colors.grey.withValues(alpha: 0.2),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 8,
          children:
          [
            const Icon(
              Icons.add,
              size: 48,
              color: Colors.grey,
            ),
            const Text('Add a new goal?'),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

class ListShowcaseScreen extends StatelessWidget {
  const ListShowcaseScreen({super.key});

  List<String> _parseTasks(String aiResponse) {
    // Split by sentence or step, filter out empty, limit to 3-5
    final sentences = aiResponse
        .split(RegExp(r'[.\n\-•]'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    if (sentences.length >= 3) {
      return sentences.take(5).toList();
    } else if (sentences.isNotEmpty) {
      return sentences;
    } else {
      return [aiResponse];
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String? aiResponse = args?['aiResponse'] as String?;
    final String? userGoal = args?['userGoal'] as String?;

    final List<String> tasks = aiResponse != null && aiResponse.trim().isNotEmpty
        ? _parseTasks(aiResponse)
        : [
            'Review today\'s goals',
            'Complete 1 Pomodoro of focused work',
            'Take a 5-minute break',
            'Check in with your mood',
            'Plan tomorrow\'s top task',
          ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Plan'),
        centerTitle: true,
        elevation: 0.5,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (userGoal != null && userGoal.trim().isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your goal:',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userGoal,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              Text(
                'Your personalized plan based on your goal',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.separated(
                  itemCount: tasks.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                        child: Text(
                          tasks[index],
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.mainMenu);
                  },
                  child: const Text('Go to Main Menu'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

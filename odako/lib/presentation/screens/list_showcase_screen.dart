import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

class ListShowcaseScreen extends StatelessWidget {
  const ListShowcaseScreen({super.key});

  // Placeholder/mock tasks
  final List<String> _tasks = const [
    'Review today\'s goals',
    'Complete 1 Pomodoro of focused work',
    'Take a 5-minute break',
    'Check in with your mood',
    'Plan tomorrow\'s top task',
  ];

  @override
  Widget build(BuildContext context) {
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
              Text(
                "Here's your plan for today:",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.separated(
                  itemCount: _tasks.length,
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
                          _tasks[index],
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

import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Add import for DailyProgressCircle
import '../widgets/daily_progress_circle.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final username = user?.displayName ?? (user?.email?.split('@').first ?? 'User');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Odako'),
        centerTitle: true,
        elevation: 0.5,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome + Progress Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      'Hi $username!',
                      style: Theme.of(context).textTheme.headlineSmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Circular progress bar
                  const DailyProgressCircle(size: 56, showLabel: false),
                ],
              ),
              const SizedBox(height: 24),
              // Today's Task List Preview
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Today\'s Tasks', style: Theme.of(context).textTheme.titleMedium),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.taskList);
                    },
                    child: const Text('See All'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseAuth.instance.currentUser == null
                    ? null
                    : FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection('selectedTasks')
                        .where('priority', isEqualTo: 'High')
                        .limit(1)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final docs = snapshot.data!.docs;
                  if (docs.isEmpty) {
                    return const Text('No tasks yet.');
                  }
                  final doc = docs.first;
                  final data = doc.data() as Map<String, dynamic>;
                  final isCompleted = data['isCompleted'] == true;
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: ListTile(
                      leading: Checkbox(
                        value: isCompleted,
                        onChanged: (_) async {
                          await doc.reference.update({'isCompleted': !isCompleted});
                        },
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                      title: Text(
                        data['text'] ?? '',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              decoration: isCompleted ? TextDecoration.lineThrough : null,
                              color: isCompleted ? Colors.grey : null,
                            ),
                      ),
                      subtitle: data['priority'] != null ? Text('Priority: ${data['priority']}') : null,
                      onTap: () async {
                        await doc.reference.update({'isCompleted': !isCompleted});
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              // Replace mascot with OpenChatSection
              const OpenChatSection(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 1:
              Navigator.pushNamed(context, AppRoutes.taskList);
              break;
            case 2:
              Navigator.pushNamed(context, AppRoutes.profile);
              break;
            case 0:
            default:
              // Home, do nothing or pop to root if needed
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
      ),
    );
  }
}

// Add this widget at the bottom of the file for reuse
class OpenChatSection extends StatelessWidget {
  const OpenChatSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text('If you are anxious talk to me!', style: Theme.of(context).textTheme.bodyMedium),
        ),
        const SizedBox(height: 12),
        Center(
          child: Column(
            children: [
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text('🐙', style: TextStyle(fontSize: 36)),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/chat');
                },
                child: const Text('Open Chat'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

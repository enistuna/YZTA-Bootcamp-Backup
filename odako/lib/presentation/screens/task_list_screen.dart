import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String title;
  final String? emoji;
  bool isCompleted;
  Task({required this.title, this.emoji, this.isCompleted = false});
}

// Move OpenChatSection to the top-level
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

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final twentyFourHoursAgo = Timestamp.fromDate(now.subtract(const Duration(hours: 24)));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Tasks'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('You are doing well! Keep pushing!', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseAuth.instance.currentUser == null
                    ? null
                    : FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .collection('selectedTasks')
                        .where('createdAt', isGreaterThanOrEqualTo: twentyFourHoursAgo)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final docs = snapshot.data!.docs;
                  if (docs.isEmpty) {
                    return const Center(child: Text('No tasks yet.'));
                  }
                  return ListView.separated(
                    itemCount: docs.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final doc = docs[index];
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
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            const OpenChatSection(),
          ],
        ),
      ),
      floatingActionButton: null, // Remove add task button for selected tasks only
    );
  }
}

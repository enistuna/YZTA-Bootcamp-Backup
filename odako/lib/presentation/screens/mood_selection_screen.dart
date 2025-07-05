import 'package:flutter/material.dart';
import '../widgets/mood_slider.dart';
import '../../routes/app_routes.dart';

class MoodSelectionScreen extends StatefulWidget {
  const MoodSelectionScreen({super.key});

  @override
  State<MoodSelectionScreen> createState() => _MoodSelectionScreenState();
}

class _MoodSelectionScreenState extends State<MoodSelectionScreen> {
  int _mood = 1;

  static const _moodData = [
    {
      'emoji': '😞',
      'label': 'MEH',
      'color': Color(0xFFF7DADA),
    },
    {
      'emoji': '😐',
      'label': 'NOT BAD',
      'color': Color(0xFFFDF5D3),
    },
    {
      'emoji': '🙂',
      'label': 'GOOD',
      'color': Color(0xFFE8F5E0),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final mood = _moodData[_mood];
    return Scaffold(
      backgroundColor: mood['color'] as Color,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(height: 24),
                Text(
                  "How’s your mood today?",
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                Text(
                  mood['emoji'] as String,
                  style: const TextStyle(fontSize: 72),
                ),
                const SizedBox(height: 16),
                Text(
                  mood['label'] as String,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                MoodSlider(
                  value: _mood,
                  onChanged: (val) {
                    setState(() {
                      _mood = val;
                    });
                  },
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.dailyQuestion);
                    },
                    child: const Text('Continue'),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

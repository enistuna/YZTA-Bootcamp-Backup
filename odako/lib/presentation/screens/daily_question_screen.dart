import 'package:flutter/material.dart';
import '../widgets/chat_bubble.dart';
import '../../routes/app_routes.dart';

class DailyQuestionScreen extends StatefulWidget {
  const DailyQuestionScreen({super.key});

  @override
  State<DailyQuestionScreen> createState() => _DailyQuestionScreenState();
}

class _DailyQuestionScreenState extends State<DailyQuestionScreen> {
  final TextEditingController _controller = TextEditingController();
  String? _userMessage;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _userMessage = text;
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Text(
                'What do you want to accomplish today?',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    const ChatBubble(
                      text: 'What do you want to accomplish today?',
                      isUser: false,
                    ),
                    if (_userMessage != null)
                      ChatBubble(
                        text: _userMessage!,
                        isUser: true,
                      ),
                    // Placeholder for future AI reply
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      minLines: 1,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'Type your goal...'
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _userMessage == null || _userMessage!.isEmpty
                      ? null
                      : () {
                          Navigator.pushNamed(context, AppRoutes.listShowcase);
                        },
                  child: const Text('Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

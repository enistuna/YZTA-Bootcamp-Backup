import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static const String _geminiApiKey = 'AIzaSyBj-AeElRI9QL2J7NBIQA4HpJ_QgKDNm6o';
  static const String _geminiApiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

  static Future<String> getDailyTaskSuggestion(String userInput) async {
    final prompt =
        'You are a friendly and motivational assistant helping someone with ADHD plan their day. '
        'The user wants to accomplish the following goal: "$userInput". '
        'Suggest a simple, encouraging first step. Be concise and positive.';

    try {
      final response = await http.post(
        Uri.parse('$_geminiApiUrl?key=$_geminiApiKey'),
        headers: {
          'Content-Type': 'application/json',
          'X-goog-api-key': _geminiApiKey,
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['candidates']?[0]?['content']?['parts']?[0]?['text'];
        if (text != null && text is String && text.trim().isNotEmpty) {
          return text.trim();
        }
      } else {
        print('Gemini API Error: ${response.statusCode}');
        print('Body: ${response.body}');
      }
    } catch (e) {
      print('Gemini API exception: $e');
    }

    await Future.delayed(const Duration(seconds: 1));
    return "Try breaking it into small steps";
  }
}

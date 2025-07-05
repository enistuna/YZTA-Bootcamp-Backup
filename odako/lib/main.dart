import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'presentation/screens/splash_screen.dart';
import 'presentation/screens/mood_selection_screen.dart';
import 'presentation/screens/task_list_screen.dart';
import 'presentation/screens/daily_question_screen.dart';
import 'presentation/screens/list_showcase_screen.dart';
import 'presentation/screens/main_menu.dart';
import 'presentation/screens/chat_screen.dart';

void main() {
  runApp(const OdakoApp());
}

class OdakoApp extends StatelessWidget {
  const OdakoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Odako',
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (context) => const SplashScreen(), 
        AppRoutes.moodSelection: (context) => const MoodSelectionScreen(),
        AppRoutes.moodSelector: (context) => const MoodSelectionScreen(),
        AppRoutes.taskList: (context) => const TaskListScreen(),
        AppRoutes.dailyQuestion: (context) => const DailyQuestionScreen(),
        AppRoutes.listShowcase: (context) => const ListShowcaseScreen(),
        AppRoutes.mainMenu: (context) => const MainMenuScreen(),
        AppRoutes.chat: (context) => const ChatScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

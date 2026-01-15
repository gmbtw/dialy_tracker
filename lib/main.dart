import 'package:flutter/material.dart';
import 'theme.dart';
import 'screens/today_screen.dart';
import 'screens/stats_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.bg,
        fontFamily: 'Roboto',
      ),
      home: Scaffold(
        body: index == 0 ? const TodayScreen() : const StatsScreen(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: index,
          backgroundColor: AppColors.card,
          selectedItemColor: AppColors.green,
          unselectedItemColor: AppColors.muted,
          onTap: (i) => setState(() => index = i),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Сегодня',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Статистика',
            ),
          ],
        ),
      ),
    );
  }
}

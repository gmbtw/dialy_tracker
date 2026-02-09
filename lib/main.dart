import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'theme.dart';
import 'screens/today_screen.dart';
import 'screens/stats_screen.dart';
import 'screens/auth_screen.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Инициализация уведомлений
  await NotificationService.init();
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int index = 0;
  final Future<FirebaseApp> _initialization = Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAbhZYwi8iWIZERiDsDwtpiF9nM8UHFSjo",
      appId: "1:173017761867:android:274886066559962fe1a5ce",
      messagingSenderId: "173017761867",
      projectId: "void-app-d2d22",
    ),
  );

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    setState(() {
      index = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.bg,
        fontFamily: 'Roboto',
      ),
      home: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text(
                  "Ошибка инициализации Firebase:\n${snapshot.error}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.redAccent),
                ),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, authSnapshot) {
                if (authSnapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator(color: AppColors.green)),
                  );
                }
                
                if (authSnapshot.hasData) {
                  // При успешном входе планируем ежедневное уведомление (например, в 9:00)
                  NotificationService.scheduleDailyNotification(
                    title: "Пора проверить привычки! 🎯",
                    body: "Зайди в приложение и отметь выполненные задачи.",
                    hour: 9,
                    minute: 0,
                  );

                  return Scaffold(
                    body: index == 0 
                        ? TodayScreen(onLogout: _logout) 
                        : StatsScreen(onLogout: _logout),
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
                  );
                }
                
                return AuthScreen(
                  onAuthSuccess: () {}, 
                );
              },
            );
          }

          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: AppColors.green)),
          );
        },
      ),
    );
  }
}

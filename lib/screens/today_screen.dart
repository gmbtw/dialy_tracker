import 'package:flutter/material.dart';
import '../theme.dart';
import '../services/notification_service.dart';

class HabitItem {
  String emoji;
  String title;
  bool done;

  HabitItem({required this.emoji, required this.title, this.done = false});
}

class TodayScreen extends StatefulWidget {
  final VoidCallback onLogout;
  const TodayScreen({super.key, required this.onLogout});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  final List<HabitItem> habits = [
    HabitItem(emoji: '🧘', title: 'Утренняя медитация', done: true),
    HabitItem(emoji: '💧', title: 'Выпить 2л воды', done: true),
    HabitItem(emoji: '📚', title: 'Прочитать 30 минут'),
    HabitItem(emoji: '💪', title: 'Тренировка'),
    HabitItem(emoji: '💻', title: 'Изучить код 1 час', done: true),
    HabitItem(emoji: '😴', title: 'Лечь до 23:00'),
  ];

  double get progress {
    if (habits.isEmpty) return 0;
    final doneCount = habits.where((h) => h.done).length;
    return doneCount / habits.length;
  }

  void toggleHabit(int index) {
    setState(() {
      habits[index].done = !habits[index].done;
    });
    
    // Показываем уведомление при клике на задачу
    final status = habits[index].done ? 'выполнена' : 'отменена';
    NotificationService.showInstantNotification(
      title: 'Привычка обновлена!',
      body: 'Задача "${habits[index].title}" $status',
    );
  }

  void addHabit(String emoji, String title) {
    setState(() {
      habits.add(HabitItem(emoji: emoji, title: title));
    });
    
    // Показываем уведомление при добавлении задачи
    NotificationService.showInstantNotification(
      title: 'Новая привычка!',
      body: 'Привычка "$title" успешно добавлена в список',
    );
  }

  void showAddHabitDialog() {
    final titleController = TextEditingController();
    final emojiController = TextEditingController(text: '🔥');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.card,
          title: const Text('Новая привычка', style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emojiController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Эмодзи',
                  labelStyle: TextStyle(color: AppColors.muted),
                ),
              ),
              TextField(
                controller: titleController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Название привычки',
                  labelStyle: TextStyle(color: AppColors.muted),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена', style: TextStyle(color: AppColors.muted)),
            ),
            TextButton(
              onPressed: () {
                if (titleController.text.trim().isNotEmpty) {
                  addHabit(
                    emojiController.text.trim().isEmpty
                        ? '🔥'
                        : emojiController.text.trim(),
                    titleController.text.trim(),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Добавить', style: TextStyle(color: AppColors.green)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final doneCount = habits.where((h) => h.done).length;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Сегодня',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Четверг, 15 января',
                      style: TextStyle(color: AppColors.muted),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: widget.onLogout,
                  icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
                  tooltip: 'Выйти',
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Прогресс
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Прогресс за день',
                          style: TextStyle(color: Colors.white)),
                      Text('${(progress * 100).round()}%',
                          style: const TextStyle(
                              color: AppColors.green,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.white12,
                    valueColor:
                    const AlwaysStoppedAnimation(AppColors.green),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$doneCount из ${habits.length} привычек выполнено',
                    style: const TextStyle(color: AppColors.muted, fontSize: 12),
                  )
                ],
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                itemCount: habits.length,
                itemBuilder: (context, index) {
                  final habit = habits[index];
                  return GestureDetector(
                    onTap: () => toggleHabit(index),
                    child: habitWidget(habit),
                  );
                },
              ),
            ),

            GestureDetector(
              onTap: showAddHabitDialog,
              child: Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.green,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text(
                    '+ Добавить привычку',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget habitWidget(HabitItem habit) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: habit.done
            ? Border.all(color: AppColors.green)
            : Border.all(color: Colors.transparent),
      ),
      child: Row(
        children: [
          Text(habit.emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(habit.title,
                style: const TextStyle(color: Colors.white)),
          ),
          Icon(
            habit.done ? Icons.check_circle : Icons.circle_outlined,
            color: habit.done ? AppColors.green : AppColors.muted,
          )
        ],
      ),
    );
  }
}

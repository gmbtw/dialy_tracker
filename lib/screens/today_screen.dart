import 'package:flutter/material.dart';
import '../theme.dart';

class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Сегодня",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "Четверг, 15 января",
              style: TextStyle(color: AppColors.muted),
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
                    children: const [
                      Text("Прогресс за день",
                          style: TextStyle(color: Colors.white)),
                      Text("50%",
                          style: TextStyle(
                              color: AppColors.green,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: 0.5,
                    backgroundColor: Colors.white12,
                    valueColor:
                    const AlwaysStoppedAnimation(AppColors.green),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "3 из 6 привычек выполнено",
                    style: TextStyle(color: AppColors.muted, fontSize: 12),
                  )
                ],
              ),
            ),

            const SizedBox(height: 16),
            habit("🧘", "Утренняя медитация", true),
            habit("💧", "Выпить 2л воды", true),
            habit("📚", "Прочитать 30 минут", false),
            habit("💪", "Тренировка", false),
            habit("💻", "Изучить код 1 час", true),
            habit("😴", "Лечь до 23:00", false),

            const Spacer(),

            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.green,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text(
                  "+ Добавить привычку",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget habit(String emoji, String title, bool done) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: done
            ? Border.all(color: AppColors.green)
            : Border.all(color: Colors.transparent),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title,
                style: const TextStyle(color: Colors.white)),
          ),
          Icon(
            done ? Icons.check_circle : Icons.circle_outlined,
            color: done ? AppColors.green : AppColors.muted,
          )
        ],
      ),
    );
  }
}

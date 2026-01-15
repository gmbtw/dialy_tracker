import 'package:flutter/material.dart';
import '../theme.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text(
              "Статистика",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Твой прогресс за неделю",
              style: TextStyle(color: AppColors.muted),
            ),

            const SizedBox(height: 20),

            /// --- Карточки статистики ---
            Row(
              children: [
                _statCard("5", "Текущая\nсерия"),
                const SizedBox(width: 12),
                _statCard("12", "Лучшая\nсерия"),
                const SizedBox(width: 12),
                _statCard("81%", "Среднее\nза неделю"),
              ],
            ),

            const SizedBox(height: 24),

            /// --- Заглушка графика ---
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text(
                  "График выполнения\n(можно подключить fl_chart)",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.muted),
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// --- Привычки за неделю ---
            const Text(
              "Привычки на этой неделе",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),

            _progressItem("Утренняя медитация", 0.86),
            _progressItem("Выпить 2л воды", 1.0),
            _progressItem("Прочитать 30 минут", 0.57),
          ],
        ),
      ),
    );
  }

  // --- Карточка с цифрой ---
  Widget _statCard(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                color: AppColors.green,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.muted,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Прогресс привычки ---
  Widget _progressItem(String title, double value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                "${(value * 100).round()}%",
                style: const TextStyle(color: AppColors.green),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 8,
              backgroundColor: Colors.white12,
              valueColor:
              const AlwaysStoppedAnimation(AppColors.green),
            ),
          ),
        ],
      ),
    );
  }
}

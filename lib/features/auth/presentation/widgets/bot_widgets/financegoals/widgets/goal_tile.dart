import 'package:flutter/material.dart';
import 'package:money_track/features/auth/presentation/widgets/bot_widgets/financegoals/model/goal_data.dart';

class GoalTile extends StatelessWidget {
  final GoalData goal;
  final String userId;
  final void Function(String prefsKey) onDelete;
  const GoalTile(
      {Key? key,
      required this.goal,
      required this.userId,
      required this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prefsKey = 'goal_${userId}_${goal.goalName}';
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                      goal.goalName == "House"
                          ? "🏠 ${goal.goalName}"
                          : goal.goalName == "Bike"
                              ? "🏍 ${goal.goalName}"
                              : "🚗 ${goal.goalName}",
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  tooltip: "Remove Goal",
                  onPressed: () =>
                      _showDeleteDialog(context, prefsKey, goal.goalName),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Target Amount: ₹${goal.amount.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16)),
            Text('Target Date: ${goal.targetDate}',
                style: const TextStyle(fontSize: 16)),
            Text('Duration: ${goal.months} months',
                style: const TextStyle(fontSize: 16)),
            const Divider(height: 20),
            const Text('Installments:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            Text('• Large Cap: ₹${goal.largeCapInstallment.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16)),
            Text('• Mid Cap: ₹${goal.midCapInstallment.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16)),
            Text(
                '• Long Term Debt: ₹${goal.longTermDebtInstallment.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(
      BuildContext context, String prefsKey, String goalName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Remove Goal"),
        content: Text("Are you sure you want to remove \"${goalName}\"?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              onDelete(prefsKey);
            },
            child: const Text("Remove", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

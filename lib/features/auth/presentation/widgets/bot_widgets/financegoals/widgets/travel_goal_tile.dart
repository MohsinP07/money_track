import 'package:flutter/material.dart';
import 'package:money_track/features/auth/presentation/widgets/bot_widgets/financegoals/model/travel_goal_data.dart';

class TravelGoalTile extends StatelessWidget {
  final TravelGoalData goal;
  final VoidCallback onDelete;
  const TravelGoalTile({Key? key, required this.goal, required this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  "🌍 Travel Goal",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  tooltip: "Remove Travel Goal",
                  onPressed: onDelete,
                )
              ],
            ),
            const SizedBox(height: 8),
            Text('Location: ${goal.location}',
                style: const TextStyle(fontSize: 16)),
            Text('Number of People: ${goal.numberOfPeople}',
                style: const TextStyle(fontSize: 16)),
            Text('Travel Date: ${goal.travelDate}',
                style: const TextStyle(fontSize: 16)),
            Text('Duration: ${goal.months} months',
                style: const TextStyle(fontSize: 16)),
            const Divider(height: 20),
            const Text(
              'Installment:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Text(
                '• Monthly Installment: ₹${goal.monthlyInstallment.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16)),
            Text('• Total Cost: ₹${goal.totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:money_track/features/auth/presentation/widgets/bot_widgets/financegoals/model/wedding_goal_data.dart';

class WeddingGoalTile extends StatelessWidget {
  final WeddingGoalData goal;
  final VoidCallback onDelete;
  const WeddingGoalTile({Key? key, required this.goal, required this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              const Text("💍 Wedding Goal", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const Spacer(),
              IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _showDeleteWeddingDialog(context)),
            ],
          ),
          Text('Entered Amount: ₹${goal.enteredAmount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
          Text('Wedding Date: ${goal.weddingDate}', style: const TextStyle(fontSize: 16)),
          Text('Saved Amount: ₹${goal.savedAmount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
          Text('Duration: ${goal.months} months', style: const TextStyle(fontSize: 16)),
          const Divider(height: 20),
          const Text('Installment:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          Text('• Monthly Installment: ₹${goal.monthlyInstallment.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
        ]),
      ),
    );
  }

  void _showDeleteWeddingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Remove Wedding Goal"),
        content: const Text("Are you sure you want to remove your wedding goal?"),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              onDelete();
            },
            child: const Text("Remove", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

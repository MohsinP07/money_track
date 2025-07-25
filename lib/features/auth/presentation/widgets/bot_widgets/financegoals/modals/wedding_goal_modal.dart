import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_track/features/auth/presentation/widgets/bot_widgets/financegoals/model/wedding_goal_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/sip_card.dart';
import 'package:money_track/core/common/widgets/custom_button.dart';

void showWeddingGoalModal(BuildContext context, String userId) {
  TextEditingController amountController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      bool emptyWeddingForm = false;
      return StatefulBuilder(
        builder: (context, setState) => Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Set Your Wedding Goal',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Target Wedding Amount',
                      border: OutlineInputBorder(),
                      hintText: 'Enter your wedding budget (₹)',
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: dateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Wedding Date',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        setState(() {
                          dateController.text = formattedDate;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  if (emptyWeddingForm)
                    const Text('Fields cannot be empty',
                        style: TextStyle(color: Colors.red)),
                  const SizedBox(height: 10),
                  CustomButton(
                    onTap: () {
                      final amt = double.tryParse(amountController.text);
                      final date = dateController.text;
                      if (amt == null || amt <= 0 || date.isEmpty) {
                        setState(() => emptyWeddingForm = true);
                        return;
                      }
                      setState(() => emptyWeddingForm = false);
                      Navigator.pop(context);

                      double averageWeddingCost =
                          1000000; 
                      double weddingCost =
                          amt < averageWeddingCost ? averageWeddingCost : amt;
                      DateTime targetDate =
                          DateFormat('yyyy-MM-dd').parse(date);
                      int months =
                          targetDate.difference(DateTime.now()).inDays ~/ 30;
                      if (months <= 0) months = 1; 
                      double monthlyInstallment = weddingCost / months;

                      showWeddingInstallmentModal(
                        context,
                        userId,
                        amt,
                        date,
                        weddingCost,
                        months,
                        monthlyInstallment,
                      );
                    },
                    text: 'Calculate Installments',
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

void showWeddingInstallmentModal(
  BuildContext context,
  String userId,
  double enteredAmount,
  String date,
  double totalAmount,
  int months,
  double monthlyInstallment,
) {
  bool saved = false;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) => Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Wedding Installment Details',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Based on your wedding goal, the total estimated wedding cost is ₹${totalAmount.toStringAsFixed(2)}.',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'You have $months months until your planned wedding date. Below is the suggested monthly installment:',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  SIPCard(
                      title: 'Monthly Installment', amount: monthlyInstallment),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          icon: const Icon(Icons.save, color: Colors.white),
                          label: saved
                              ? const Text('Saved!',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white))
                              : const Text('Save Goal',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white)),
                          onPressed: saved
                              ? null
                              : () async {
                                  final prefsKey = 'goal_${userId}_Wedding';
                                  final goalData = WeddingGoalData(
                                    enteredAmount: enteredAmount,
                                    savedAmount: totalAmount,
                                    weddingDate: date,
                                    months: months,
                                    monthlyInstallment: monthlyInstallment,
                                  );
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.setString(
                                      prefsKey, goalData.toJson());
                                  setState(() {
                                    saved = true;
                                  });
                                },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade300,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close',
                              style: TextStyle(fontSize: 16)),
                        ),
                      )
                    ],
                  ),
                  if (saved)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "Wedding goal saved locally!",
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

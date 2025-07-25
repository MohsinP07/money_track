import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/sip_card.dart';
import '../utils/sip_calculator.dart';
import 'package:money_track/core/common/widgets/custom_button.dart';
import '../model/goal_data.dart'; 

void showGoalModal(BuildContext context, String goalName, String userId) {
  TextEditingController amountController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  final String prefsKey = 'goal_${userId}_$goalName';

  Future<void> loadSavedGoal() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString(prefsKey);
    if (savedData != null) {
      try {
        final goalData = GoalData.fromJson(savedData);
        amountController.text = goalData.amount.toString();
        dateController.text = goalData.targetDate;
      } catch (_) {}
    }
  }

  loadSavedGoal();

  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        bool emptyCommonForm = false;
        return StatefulBuilder(
            builder: (context, setState) => Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Set your $goalName Goal',
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: amountController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: goalName == "House"
                                  ? 'Target Downpayment Amount'
                                  : 'Target Amount',
                              border: const OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: dateController,
                            readOnly: true,
                            decoration: const InputDecoration(
                              labelText: 'Target Date',
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
                          if (emptyCommonForm)
                            const Text("Fields cannot be empty or invalid",
                                style: TextStyle(color: Colors.red)),
                          const SizedBox(height: 20),
                          CustomButton(
                            text: 'Calculate SIP',
                            height: 48,
                            fontSize: 16,
                            borderRadius: 14,
                            onTap: () {
                              double? amount =
                                  double.tryParse(amountController.text);
                              if (amount == null ||
                                  amount <= 0 ||
                                  dateController.text.isEmpty) {
                                setState(() {
                                  emptyCommonForm = true;
                                });
                                return;
                              }
                              DateTime targetDate;
                              try {
                                targetDate = DateFormat('yyyy-MM-dd')
                                    .parse(dateController.text);
                              } catch (_) {
                                setState(() {
                                  emptyCommonForm = true;
                                });
                                return;
                              }
                              int months = targetDate
                                      .difference(DateTime.now())
                                      .inDays ~/
                                  30;
                              if (months <= 0) {
                                setState(() {
                                  emptyCommonForm = true;
                                });
                                return;
                              }

                              final largeCap =
                                  calculateSIP(amount, 0.15, months);
                              final midCap = calculateSIP(amount, 0.16, months);
                              final debt = calculateSIP(amount, 0.07, months);

                              Navigator.pop(context); 

                              showSIPDetailsModal(
                                context,
                                goalName,
                                userId,
                                amount,
                                dateController.text,
                                months,
                                largeCap,
                                midCap,
                                debt,
                                prefsKey,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ));
      });
}

void showSIPDetailsModal(
  BuildContext context,
  String goalName,
  String userId,
  double amount,
  String targetDate,
  int months,
  double largeCapSIP,
  double midCapSIP,
  double longTermDebtSIP,
  String prefsKey,
) {
  bool saving = false;
  bool savedSuccessfully = false;

  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'SIP Installment Details',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Based on your goal of investing ₹${amount.toStringAsFixed(2)} over $months months, below are the SIP installment details for different investment types:',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    SIPCard(
                        title: 'Large Cap (15% annual return)',
                        amount: largeCapSIP),
                    const SizedBox(height: 10),
                    SIPCard(
                        title: 'Mid Cap (16% annual return)',
                        amount: midCapSIP),
                    const SizedBox(height: 10),
                    SIPCard(
                        title: 'Long Term Debt (7% annual return)',
                        amount: longTermDebtSIP),
                    const SizedBox(height: 20),
                    if (savedSuccessfully)
                      const Text(
                        "Goal saved successfully!",
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade600,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: saving
                                ? null
                                : () async {
                                    setState(() {
                                      saving = true;
                                    });

                                    final goalData = GoalData(
                                      goalName: goalName,
                                      amount: amount,
                                      targetDate: targetDate,
                                      months: months,
                                      largeCapInstallment: largeCapSIP,
                                      midCapInstallment: midCapSIP,
                                      longTermDebtInstallment: longTermDebtSIP,
                                    );
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    await prefs.setString(
                                        prefsKey, goalData.toJson());

                                    setState(() {
                                      saving = false;
                                      savedSuccessfully = true;
                                    });
                                  },
                            child: saving
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ))
                                : const Text("Save Goal",
                                    style: TextStyle(fontSize: 16)),
                          ),
                        ),
                        const SizedBox(width: 15),
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
                    )
                  ],
                ),
              ),
            ),
          );
        });
      });
}

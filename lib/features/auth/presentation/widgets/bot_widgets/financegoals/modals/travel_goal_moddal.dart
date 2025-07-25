import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/travel_cost_helper.dart';
import '../widgets/sip_card.dart';
import 'package:money_track/core/common/widgets/custom_button.dart';
import '../model/travel_goal_data.dart';

void showTravelGoalModal(BuildContext context, String userId) {
  TextEditingController locationController = TextEditingController();
  TextEditingController peopleController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      bool emptyTravelForm = false;

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
                    'Set your Travel Goal',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: locationController,
                    decoration: const InputDecoration(
                      labelText: 'Location',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: peopleController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Number of People',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: dateController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Travel Date',
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
                  if (emptyTravelForm)
                    const Text('Fields cannot be empty or invalid',
                        style: TextStyle(color: Colors.red)),
                  const SizedBox(height: 10),
                  CustomButton(
                    text: 'Calculate Installments',
                    height: 48,
                    fontSize: 16,
                    borderRadius: 14,
                    onTap: () {
                      if (locationController.text.isEmpty ||
                          dateController.text.isEmpty ||
                          peopleController.text.isEmpty) {
                        setState(() {
                          emptyTravelForm = true;
                        });
                        return;
                      }
                      final int? people = int.tryParse(peopleController.text);
                      if (people == null || people <= 0) {
                        setState(() {
                          emptyTravelForm = true;
                        });
                        return;
                      }
                      setState(() {
                        emptyTravelForm = false;
                      });
                      Navigator.pop(context);

                      double avgTravelCost =
                          getLocationAverageCost(locationController.text);
                      DateTime travelDate =
                          DateFormat('yyyy-MM-dd').parse(dateController.text);
                      double totalAmount = avgTravelCost * people;
                      int months =
                          travelDate.difference(DateTime.now()).inDays ~/ 30;
                      if (months <= 0) months = 1; 
                      double monthlyInstallment = totalAmount / months;

                      showTravelInstallmentModal(
                        context,
                        userId,
                        locationController.text,
                        people,
                        dateController.text,
                        totalAmount,
                        monthlyInstallment,
                        months,
                      );
                    },
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

void showTravelInstallmentModal(
  BuildContext context,
  String userId,
  String location,
  int people,
  String travelDate,
  double totalAmount,
  double monthlyInstallment,
  int months,
) {
  bool saving = false;
  bool savedSuccessfully = false;

  final String prefsKey = 'goal_${userId}_Travel';

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Travel Installment Details',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Based on your travel goal, the total cost for your trip to $location with $people people is ₹${totalAmount.toStringAsFixed(2)}.',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'You have $months months until your planned travel date. Below is the suggested monthly installment:',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  SIPCard(
                      title: 'Monthly Installment', amount: monthlyInstallment),
                  const SizedBox(height: 20),
                  if (savedSuccessfully)
                    const Text(
                      "Travel goal saved successfully!",
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
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: saving
                              ? null
                              : () async {
                                  setState(() {
                                    saving = true;
                                  });

                                  final goalData = TravelGoalData(
                                    location: location,
                                    numberOfPeople: people,
                                    travelDate: travelDate,
                                    totalAmount: totalAmount,
                                    monthlyInstallment: monthlyInstallment,
                                    months: months,
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
                                  ),
                                )
                              : const Text('Save Goal',
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
                              borderRadius: BorderRadius.circular(12),
                            ),
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
    },
  );
}

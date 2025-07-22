import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_track/core/common/widgets/custom_button.dart';
import 'package:money_track/core/themes/app_pallete.dart';
import 'package:intl/intl.dart'; 
import 'dart:math';

import 'package:money_track/features/auth/presentation/widgets/bot_widgets/goal_box.dart'; // For calculations

class CreateFinanceGoals extends StatefulWidget {
  static const String routeName = 'create-fitness-screen';
  const CreateFinanceGoals({super.key});

  @override
  State<CreateFinanceGoals> createState() => _CreateFinanceGoalsState();
}

class _CreateFinanceGoalsState extends State<CreateFinanceGoals> {
  TextEditingController amountController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController peopleController = TextEditingController();
  bool emptyCommonForm = false;
  bool emptyTravelForm = false;
  bool emptyWeddingForm = false;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0).copyWith(top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                maxLines: 2,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Finance".tr,
                      style: const TextStyle(
                        color: AppPallete.blackColor,
                        fontSize: 30,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    TextSpan(
                      text: "Goals".tr,
                      style: const TextStyle(
                        color: AppPallete.blackColor,
                        fontSize: 34,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 16,
                  children: [
                    GoalBox(
                      deviceSize: deviceSize,
                      title: "Bike Goal",
                      image: 'assets/images/bike.png',
                      onPressed: () {
                        _showGoalModal(context, 'Bike');
                      },
                    ),
                    GoalBox(
                      deviceSize: deviceSize,
                      title: "Car Goal",
                      image: 'assets/images/car.png',
                      onPressed: () {
                        _showGoalModal(context, 'Car');
                      },
                    ),
                    GoalBox(
                      deviceSize: deviceSize,
                      title: "House Goal",
                      image: 'assets/images/home.png',
                      onPressed: () {
                        _showGoalModal(context, 'House');
                      },
                    ),
                    GoalBox(
                      deviceSize: deviceSize,
                      title: "Wedding Goal",
                      image: 'assets/images/wedding.png',
                      onPressed: () {
                        _showWeddingGoalModal(context);
                      },
                    ),
                    GoalBox(
                      deviceSize: deviceSize,
                      title: "Travel Goal",
                      image: 'assets/images/travel.png',
                      onPressed: () {
                        _showTravelGoalModal(context);
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Modal for Bike Goal Input
  void _showGoalModal(BuildContext context, String goalName) {
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
                    Text(
                      'Set your $goalName Goal',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
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
                    if (emptyCommonForm) const Text("Fields cannot be empty"),
                    const SizedBox(height: 10),
                    CustomButton(
                      onTap: () {
                        if (amountController.text.isEmpty ||
                            dateController.text.isEmpty) {
                          setState(() {
                            emptyCommonForm = true;
                          });
                        } else {
                          setState(() {
                            emptyCommonForm = false;
                          });
                          _calculateSIP(context);
                        }
                      },
                      text: 'Calculate SIP',
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

  // SIP Calculation and open result sheet
  void _calculateSIP(BuildContext context) {
    double amount = double.parse(amountController.text);
    DateTime targetDate = DateFormat('yyyy-MM-dd').parse(dateController.text);
    int months = targetDate.difference(DateTime.now()).inDays ~/
        30; // Approximate months

    double calculateInstallment(double rateOfReturn) {
      double monthlyRate = rateOfReturn / 12;
      return (amount * monthlyRate) / (pow(1 + monthlyRate, months) - 1);
    }

    double largeCapSIP = calculateInstallment(0.15); // 15% for Large Cap
    double midCapSIP = calculateInstallment(0.16); // 16% for Mid Cap
    double longTermDebtSIP =
        calculateInstallment(0.07); // 7% for Long Term Debt

    // Close current modal
    Navigator.pop(context);

    // Open new modal to show results
    _showSIPDetailsModal(
      context,
      largeCapSIP,
      midCapSIP,
      longTermDebtSIP,
      months,
    );
  }

  // Show SIP Details for all plans
  void _showSIPDetailsModal(BuildContext context, double largeCapSIP,
      double midCapSIP, double longTermDebtSIP, int months) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
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
                    'SIP Installment Details',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Based on your goal of investing ₹${amountController.text} over $months months, below are the SIP installment details for different investment types:',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  _buildSIPCard('Large Cap (15% annual return)', largeCapSIP),
                  const SizedBox(height: 10),
                  _buildSIPCard('Mid Cap (16% annual return)', midCapSIP),
                  const SizedBox(height: 10),
                  _buildSIPCard(
                      'Long Term Debt (7% annual return)', longTermDebtSIP),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.red.shade300,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context); // Close the modal
                    },
                    child: const Text(
                      'Close',
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showTravelGoalModal(BuildContext context) {
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
                      'Set your Travel Goal',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
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
                      const Text(
                        'Fields cannot be empty',
                      ),
                    const SizedBox(height: 10),
                    CustomButton(
                      onTap: () {
                        if (locationController.text.isEmpty ||
                            dateController.text.isEmpty ||
                            peopleController.text.isEmpty) {
                          setState(() {
                            emptyTravelForm = true;
                          });
                        } else {
                          setState(() {
                            emptyTravelForm = false;
                          });
                          _calculateTravelGoal(context);
                        }
                      },
                      text: 'Calculate Installments',
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

  void _calculateTravelGoal(BuildContext context) {
    // Mocked average travel cost per person per location
    double avgTravelCost = _getLocationAverageCost(locationController.text);
    int people = int.parse(peopleController.text);
    DateTime travelDate = DateFormat('yyyy-MM-dd').parse(dateController.text);

    // Calculate the total cost for all people
    double totalAmount = avgTravelCost * people;

    int months = travelDate.difference(DateTime.now()).inDays ~/ 30;

    // Installment calculation (as SIP style)
    double monthlyInstallment = totalAmount / months;

    // Close current modal
    Navigator.pop(context);

    // Open new modal to show results
    _showTravelInstallmentModal(
      context,
      totalAmount,
      monthlyInstallment,
      months,
    );
  }

  // Get average travel cost based on location
  double _getLocationAverageCost(String location) {
    // Mocking average costs for different locations
    if (location.toLowerCase() == 'paris') {
      return 100000; // Example average cost for Paris per person
    } else if (location.toLowerCase() == 'new york') {
      return 120000; // Example for New York
    } else {
      return 80000; // Default average for other locations
    }
  }

  // Show travel installment details modal
  void _showTravelInstallmentModal(BuildContext context, double totalAmount,
      double monthlyInstallment, int months) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
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
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Based on your travel goal, the total cost for your trip to ${locationController.text} with ${peopleController.text} people is ₹${totalAmount.toStringAsFixed(2)}.',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'You have $months months until your planned travel date. Below is the suggested monthly installment:',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  _buildSIPCard('Monthly Installment', monthlyInstallment),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.red.shade300,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context); // Close the modal
                    },
                    child: const Text(
                      'Close',
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showWeddingGoalModal(BuildContext context) {
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
                      'Set Your Wedding Goal',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Amount Input Field
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

                    // Date Input Field
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
                      const Text(
                        'Fields cannot be empty',
                      ),
                    const SizedBox(height: 10),

                    // Calculate Button
                    CustomButton(
                      onTap: () {
                        if (amountController.text.isEmpty ||
                            dateController.text.isEmpty) {
                          setState(() {
                            emptyWeddingForm = true;
                          });
                        } else {
                          setState(() {
                            emptyWeddingForm = false;
                          });
                          _calculateWeddingGoal(context);
                        }
                      },
                      text: 'Calculate Installments',
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  void _calculateWeddingGoal(BuildContext context) {
    // Mocked average wedding cost in India
    double averageWeddingCost =
        1000000; // Assuming ₹10,00,000 as the average cost

    // Get the amount and date inputs
    double amount = double.parse(amountController.text);
    DateTime targetDate = DateFormat('yyyy-MM-dd').parse(dateController.text);

    // If the input amount is less than the average cost, use the average cost
    double weddingCost =
        amount < averageWeddingCost ? averageWeddingCost : amount;

    // Calculate the number of months between today and the target wedding date
    int months = targetDate.difference(DateTime.now()).inDays ~/ 30;

    // Calculate monthly installment for the goal
    double monthlyInstallment = weddingCost / months;

    // Close current modal
    Navigator.pop(context);

    // Open a new modal to show installment plan
    _showWeddingInstallmentModal(
      context,
      weddingCost,
      monthlyInstallment,
      months,
    );
  }

// Show wedding installment details modal
  void _showWeddingInstallmentModal(BuildContext context, double totalAmount,
      double monthlyInstallment, int months) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
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
                    'Wedding Installment Details',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
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
                  _buildSIPCard('Monthly Installment', monthlyInstallment),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.red.shade300,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context); // Close the modal
                    },
                    child: const Text(
                      'Close',
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Widget for SIP card-style layout
  Widget _buildSIPCard(String title, double amount) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Installment: ₹${amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.green[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

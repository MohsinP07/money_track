import 'package:flutter/material.dart';
import 'package:money_track/core/common/widgets/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IncomeInfoSheet extends StatelessWidget {
  final TextEditingController monthlyIncomeController;
  final TextEditingController annualIncomeController;
  final GlobalKey<FormState> formKey;
  final SharedPreferences prefs;
  final BuildContext context;

  const IncomeInfoSheet({
    required this.monthlyIncomeController,
    required this.annualIncomeController,
    required this.formKey,
    required this.prefs,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Please Enter Income Information',
                style: TextStyle(
                  color: Colors.red.shade300,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: monthlyIncomeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Monthly Income in ₹',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter monthly income';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: annualIncomeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Annual Income in ₹',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter annual income';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Submit',
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    prefs.setBool('showDialog', false);
                    prefs.setString(
                        'monthlyIncome', monthlyIncomeController.text.trim());
                    prefs.setString(
                        'annualIncome', annualIncomeController.text.trim());

                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

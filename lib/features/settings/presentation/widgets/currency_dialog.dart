import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_track/core/common/widgets/custom_button.dart';
import 'package:money_track/core/constants/global_variables.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrencyDialog extends StatefulWidget {
  const CurrencyDialog({super.key});

  @override
  State<CurrencyDialog> createState() => _CurrencyDialogState();
}

class _CurrencyDialogState extends State<CurrencyDialog> {
  SharedPreferences? prefs;

  final List<String> currencies = [
    'Dollar',
    'Rupees',
  ];

  String? selectedCurrency;

  @override
  void initState() {
    super.initState();
    _loadSharedPreferences();
  }

  Future<void> _loadSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedCurrency = prefs?.getString('currency') ?? currencies[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 0,
      content: Container(
        height: deviceSize(context).height * 0.28,
        width: deviceSize(context).width * 0.4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Select Currency',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return RadioListTile(
                    title: Text(
                      currencies[index],
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    value: currencies[index],
                    groupValue: selectedCurrency,
                    onChanged: (value) {
                      setState(() {
                        selectedCurrency = value as String?;
                      });
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    color: Colors.blue,
                  );
                },
                itemCount: currencies.length,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (selectedCurrency != null)
                  SizedBox(
                    width: deviceSize(context).width * 0.26,
                    child: CustomButton(
                      text: 'Submit',
                      onTap: () {
                        prefs?.setString('currency', selectedCurrency!);
                        Navigator.of(context).pop(selectedCurrency);
                      },
                    ),
                  ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

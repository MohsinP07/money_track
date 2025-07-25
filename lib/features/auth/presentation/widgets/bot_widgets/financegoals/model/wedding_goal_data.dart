import 'dart:convert';

class WeddingGoalData {
  final double enteredAmount;
  final double savedAmount;
  final String weddingDate; 
  final int months;
  final double monthlyInstallment;

  WeddingGoalData({
    required this.enteredAmount,
    required this.savedAmount,
    required this.weddingDate,
    required this.months,
    required this.monthlyInstallment,
  });

  Map<String, dynamic> toMap() => {
        'enteredAmount': enteredAmount,
        'savedAmount': savedAmount,
        'weddingDate': weddingDate,
        'months': months,
        'monthlyInstallment': monthlyInstallment,
      };

  factory WeddingGoalData.fromMap(Map<String, dynamic> map) => WeddingGoalData(
        enteredAmount: map['enteredAmount'],
        savedAmount: map['savedAmount'],
        weddingDate: map['weddingDate'],
        months: map['months'],
        monthlyInstallment: map['monthlyInstallment'],
      );

  String toJson() => json.encode(toMap());

  factory WeddingGoalData.fromJson(String source) =>
      WeddingGoalData.fromMap(json.decode(source));
}

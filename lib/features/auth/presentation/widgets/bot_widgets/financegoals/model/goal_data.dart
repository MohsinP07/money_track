import 'dart:convert';

class GoalData {
  final String goalName;
  final double amount;
  final String targetDate; 
  final int months;
  final double largeCapInstallment;
  final double midCapInstallment;
  final double longTermDebtInstallment;

  GoalData({
    required this.goalName,
    required this.amount,
    required this.targetDate,
    required this.months,
    required this.largeCapInstallment,
    required this.midCapInstallment,
    required this.longTermDebtInstallment,
  });

  Map<String, dynamic> toMap() {
    return {
      'goalName': goalName,
      'amount': amount,
      'targetDate': targetDate,
      'months': months,
      'largeCapInstallment': largeCapInstallment,
      'midCapInstallment': midCapInstallment,
      'longTermDebtInstallment': longTermDebtInstallment,
    };
  }

  factory GoalData.fromMap(Map<String, dynamic> map) {
    return GoalData(
      goalName: map['goalName'],
      amount: map['amount'],
      targetDate: map['targetDate'],
      months: map['months'],
      largeCapInstallment: map['largeCapInstallment'],
      midCapInstallment: map['midCapInstallment'],
      longTermDebtInstallment: map['longTermDebtInstallment'],
    );
  }

  String toJson() => json.encode(toMap());

  factory GoalData.fromJson(String source) =>
      GoalData.fromMap(json.decode(source));
}

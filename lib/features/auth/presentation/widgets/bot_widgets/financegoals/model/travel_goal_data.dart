import 'dart:convert';

class TravelGoalData {
  final String location;
  final int numberOfPeople;
  final String travelDate; 
  final double totalAmount;
  final double monthlyInstallment;
  final int months;

  TravelGoalData({
    required this.location,
    required this.numberOfPeople,
    required this.travelDate,
    required this.totalAmount,
    required this.monthlyInstallment,
    required this.months,
  });

  Map<String, dynamic> toMap() {
    return {
      'location': location,
      'numberOfPeople': numberOfPeople,
      'travelDate': travelDate,
      'totalAmount': totalAmount,
      'monthlyInstallment': monthlyInstallment,
      'months': months,
    };
  }

  factory TravelGoalData.fromMap(Map<String, dynamic> map) {
    return TravelGoalData(
      location: map['location'] ?? '',
      numberOfPeople: map['numberOfPeople'] ?? 0,
      travelDate: map['travelDate'] ?? '',
      totalAmount: (map['totalAmount'] is int)
          ? (map['totalAmount'] as int).toDouble()
          : map['totalAmount'] ?? 0.0,
      monthlyInstallment: (map['monthlyInstallment'] is int)
          ? (map['monthlyInstallment'] as int).toDouble()
          : map['monthlyInstallment'] ?? 0.0,
      months: map['months'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory TravelGoalData.fromJson(String source) =>
      TravelGoalData.fromMap(json.decode(source));
}

import 'dart:math';

double calculateSIP(double amount, double rateOfReturn, int months) {
  double monthlyRate = rateOfReturn / 12;
  return (amount * monthlyRate) / (pow(1 + monthlyRate, months) - 1);
}

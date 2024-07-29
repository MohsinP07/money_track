import 'package:get/get.dart';

class UnbordingContent {
  String image;
  String title;
  String discription;

  UnbordingContent(
      {required this.image, required this.title, required this.discription});
}

List<UnbordingContent> contents = [
  UnbordingContent(
      title: 'manage_expenses'.tr,
      image: 'assets/svg/expenses.svg',
      discription: "manage_expenses_desc".tr),
  UnbordingContent(
      title: 'analyze_expenses'.tr,
      image: 'assets/svg/analysis.svg',
      discription: "analyze_expenses_desc".tr),
  UnbordingContent(
      title: 'ai_assistance'.tr,
      image: 'assets/svg/ai.svg',
      discription: "ai_assistance_desc".tr),
];

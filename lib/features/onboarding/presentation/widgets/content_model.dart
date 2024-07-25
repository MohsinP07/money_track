class UnbordingContent {
  String image;
  String title;
  String discription;

  UnbordingContent(
      {required this.image, required this.title, required this.discription});
}

List<UnbordingContent> contents = [
  UnbordingContent(
      title: 'Manage Expenses',
      image: 'assets/svg/expenses.svg',
      discription:
          "Keep track of all your expenses effortlessly. Our tool helps you organize your spending and stay on top of your finances."),
  UnbordingContent(
      title: 'Analyze Expenses',
      image: 'assets/svg/analysis.svg',
      discription:
          "Gain insights into your spending patterns. Analyze your expenses to make better financial decisions."),
  UnbordingContent(
      title: 'AI Assistance',
      image: 'assets/svg/ai.svg',
      discription:
          "Leverage AI to get smart recommendations on managing your finances more effectively and efficiently."),
];

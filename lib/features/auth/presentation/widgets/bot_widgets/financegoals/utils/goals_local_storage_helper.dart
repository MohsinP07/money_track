import 'package:money_track/features/auth/presentation/widgets/bot_widgets/financegoals/model/goal_data.dart';
import 'package:money_track/features/auth/presentation/widgets/bot_widgets/financegoals/model/travel_goal_data.dart';
import 'package:money_track/features/auth/presentation/widgets/bot_widgets/financegoals/model/wedding_goal_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoalsLoadResult {
  final List<GoalData> goals;
  final WeddingGoalData? weddingGoal;
  final TravelGoalData? travelGoal; 

  GoalsLoadResult(this.goals, this.weddingGoal, this.travelGoal);
}

class GoalsLocalStorageHelper {
  static Future<GoalsLoadResult> loadGoals(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    final prefix = 'goal_${userId}_';
    List<GoalData> goals = [];
    WeddingGoalData? weddingGoal;
    TravelGoalData? travelGoal; 

    for (String key in keys) {
      if (key.startsWith(prefix) &&
          key != 'goal_${userId}_Wedding' &&
          key != 'goal_${userId}_Travel') {
        final data = prefs.getString(key);
        if (data != null) {
          try {
            goals.add(GoalData.fromJson(data));
          } catch (_) {}
        }
      }
    }

    
    final wgData = prefs.getString('goal_${userId}_Wedding');
    if (wgData != null) {
      try {
        weddingGoal = WeddingGoalData.fromJson(wgData);
      } catch (_) {}
    }

    
    final trData = prefs.getString('goal_${userId}_Travel');
    if (trData != null) {
      try {
        travelGoal = TravelGoalData.fromJson(trData);
      } catch (_) {}
    }

    return GoalsLoadResult(goals, weddingGoal, travelGoal);
  }

  static Future<void> removeGoal(String prefsKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(prefsKey);
  }

  static Future<void> removeWeddingGoal(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('goal_${userId}_Wedding');
  }

  static Future<void> removeTravelGoal(String userId) async {
   
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('goal_${userId}_Travel');
  }
}

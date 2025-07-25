import 'package:flutter/material.dart';
import 'goal_tile.dart';
import 'wedding_goal_tile.dart';
import 'travel_goal_tile.dart'; // new
import 'package:money_track/features/auth/presentation/widgets/bot_widgets/financegoals/model/goal_data.dart';
import 'package:money_track/features/auth/presentation/widgets/bot_widgets/financegoals/model/wedding_goal_data.dart';
import 'package:money_track/features/auth/presentation/widgets/bot_widgets/financegoals/model/travel_goal_data.dart'; // new
import 'package:money_track/features/auth/presentation/widgets/bot_widgets/financegoals/utils/goals_local_storage_helper.dart';

class FinanceGoalList extends StatefulWidget {
  final String userId;
  const FinanceGoalList({Key? key, required this.userId}) : super(key: key);

  @override
  State<FinanceGoalList> createState() => _FinanceGoalListState();
}

class _FinanceGoalListState extends State<FinanceGoalList> {
  List<GoalData> _goals = [];
  WeddingGoalData? _weddingGoal;
  TravelGoalData? _travelGoal; // new
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadGoals();
  }

  Future<void> _loadGoals() async {
    final result = await GoalsLocalStorageHelper.loadGoals(widget.userId);
    setState(() {
      _goals = result.goals;
      _weddingGoal = result.weddingGoal;
      _travelGoal = result.travelGoal; // new
      _loading = false;
    });
  }

  void _deleteGoal(String prefsKey) async {
    await GoalsLocalStorageHelper.removeGoal(prefsKey);
    _loadGoals();
  }

  void _deleteWeddingGoal() async {
    await GoalsLocalStorageHelper.removeWeddingGoal(widget.userId);
    _loadGoals();
  }

  void _deleteTravelGoal() async {
    // new
    await GoalsLocalStorageHelper.removeTravelGoal(widget.userId);
    _loadGoals();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());

    final tiles = <Widget>[];
    if (_weddingGoal != null) {
      tiles.add(
          WeddingGoalTile(goal: _weddingGoal!, onDelete: _deleteWeddingGoal));
    }
    if (_travelGoal != null) {
      tiles
          .add(TravelGoalTile(goal: _travelGoal!, onDelete: _deleteTravelGoal));
    }
    tiles.addAll(_goals.map((g) => GoalTile(
          goal: g,
          userId: widget.userId,
          onDelete: (prefsKey) => _deleteGoal(prefsKey),
        )));
    if (tiles.isEmpty) {
      return const Center(
          child: Text("No goals created", style: TextStyle(fontSize: 16)));
    }
    return ListView(children: tiles);
  }
}

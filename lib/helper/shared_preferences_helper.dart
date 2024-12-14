import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:workout_app/models/workout_plan.dart';
import 'package:workout_app/models/workout_history.dart';
import 'package:workout_app/models/workout.dart';

class SharedPreferencesHelper {
  static const _workoutPlanKey = 'workoutPlan';
  static const _workoutHistoryKey = 'workoutHistory';
  static const _workoutKey = 'workout';

  // Save Workout Plan to SharedPreferences
  Future<void> saveWorkoutPlan(WorkoutPlan workoutPlan) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_workoutPlanKey, json.encode(workoutPlan.toMap()));
  }

  // Load Workout Plan from SharedPreferences
  Future<WorkoutPlan?> getWorkoutPlan() async {
    final prefs = await SharedPreferences.getInstance();
    final workoutPlanJson = prefs.getString(_workoutPlanKey);
    if (workoutPlanJson == null) {
      return null;
    }
    final workoutPlanMap = json.decode(workoutPlanJson);
    return WorkoutPlan.fromMap(workoutPlanMap);
  }

  // Save Workout History to SharedPreferences
  Future<void> saveWorkoutHistory(List<WorkoutHistory> workoutHistory) async {
    final prefs = await SharedPreferences.getInstance();
    final workoutHistoryList =
        workoutHistory.map((e) => json.encode(e.toMap())).toList();
    prefs.setStringList(_workoutHistoryKey, workoutHistoryList);
  }

  // Load Workout History from SharedPreferences
  Future<List<WorkoutHistory>> getWorkoutHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final workoutHistoryList = prefs.getStringList(_workoutHistoryKey) ?? [];
    return workoutHistoryList
        .map((e) => WorkoutHistory.fromMap(json.decode(e)))
        .toList();
  }

  // Save Workout to SharedPreferences
  Future<void> saveWorkout(Workout workout) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_workoutKey, json.encode(workout.toMap()));
  }

  // Load Workout from SharedPreferences
  Future<Workout?> getWorkout() async {
    final prefs = await SharedPreferences.getInstance();
    final workoutJson = prefs.getString(_workoutKey);
    if (workoutJson == null) {
      return null;
    }
    final workoutMap = json.decode(workoutJson);
    return Workout.fromMap(workoutMap);
  }
}

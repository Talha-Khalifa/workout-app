import 'package:shared_preferences/shared_preferences.dart';

class WorkoutPlan {
  String workoutName;
  int duration; // in minutes
  List<String> exercises;
  String goal;
  String? description; // Nullable description for extra details
  String? imageUrl; // Nullable image URL for plan image

  WorkoutPlan({
    required this.workoutName,
    required this.duration,
    required this.exercises,
    required this.goal,
    this.description,
    this.imageUrl,
  });

  // Method to calculate total workout duration based on exercises
  int calculateTotalDuration() {
    // Assuming each exercise has a fixed duration; this can be modified to use real data
    return exercises.length * 10; // Assuming each exercise takes 10 minutes
  }

  Map<String, dynamic> toMap() {
    return {
      'workout_name': workoutName,
      'workout_duration': duration,
      'workout_exercises': exercises,
      'workout_goal': goal,
      'workout_description': description,
      'workout_image_url': imageUrl,
    };
  }

  factory WorkoutPlan.fromMap(Map<String, dynamic> map) {
    return WorkoutPlan(
      workoutName: map['workout_name'],
      duration: map['workout_duration'],
      exercises: List<String>.from(map['workout_exercises'] ?? []),
      goal: map['workout_goal'] ?? "No goal specified",
      description: map['workout_description'],
      imageUrl: map['workout_image_url'],
    );
  }

  // Method to save workout plan to local storage using shared preferences
  Future<void> saveToLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final workoutPlanMap = toMap();

    prefs.setString('workout_name', workoutPlanMap['workout_name']);
    prefs.setInt('workout_duration', workoutPlanMap['workout_duration']);
    prefs.setStringList('workout_exercises', workoutPlanMap['workout_exercises']);
    prefs.setString('workout_goal', workoutPlanMap['workout_goal']);
    if (workoutPlanMap['workout_description'] != null) {
      prefs.setString('workout_description', workoutPlanMap['workout_description']);
    }
    // if (workoutPlanMap['workout_image_url'] != null) {
    //   prefs.setString('workout_image_url', workoutPlanMap['workout_image_url']);
    // }
  }

  // Static method to load workout plan from local storage
  static Future<WorkoutPlan?> loadFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final workoutName = prefs.getString('workout_name');
    if (workoutName != null) {
      final duration = prefs.getInt('workout_duration') ?? 0;
      final exercises = prefs.getStringList('workout_exercises') ?? [];
      final goal = prefs.getString('workout_goal') ?? "No goal specified";
      final description = prefs.getString('workout_description');
      final imageUrl = prefs.getString('workout_image_url');
      return WorkoutPlan(
        workoutName: workoutName,
        duration: duration,
        exercises: exercises,
        goal: goal,
        description: description,
        imageUrl: imageUrl,
      );
    }
    return null;
  }
}

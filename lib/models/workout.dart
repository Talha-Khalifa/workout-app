import 'package:shared_preferences/shared_preferences.dart';

class Workout {
  String exercise;
  int duration; // in minutes
  int sets;
  int reps;
  String? videoUrl; // Nullable URL for exercise video, if available
  String? notes; // Nullable field for additional notes

  Workout({
    required this.exercise,
    required this.duration,
    required this.sets,
    required this.reps,
    this.videoUrl,
    this.notes,
  });

  // Method to calculate total duration for this exercise (sets * reps * duration)
  int calculateTotalDuration() {
    return sets * reps * duration; // Simple logic to calculate total duration for the exercise
  }

  // Method to convert Workout instance to a Map (for saving to SharedPreferences or other storage)
  Map<String, dynamic> toMap() {
    return {
      'exercise_name': exercise,
      'exercise_duration': duration,
      'exercise_sets': sets,
      'exercise_reps': reps,
      'exercise_video_url': videoUrl,
      'exercise_notes': notes,
    };
  }

  // Static method to create a Workout instance from a Map (for loading from SharedPreferences or other storage)
  factory Workout.fromMap(Map<String, dynamic> map) {
    return Workout(
      exercise: map['exercise_name'],
      duration: map['exercise_duration'],
      sets: map['exercise_sets'],
      reps: map['exercise_reps'],
      videoUrl: map['exercise_video_url'],
      notes: map['exercise_notes'],
    );
  }

  // Method to save workout to local storage using SharedPreferences
  Future<void> saveToLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final workoutMap = toMap();

    prefs.setString('exercise_name', workoutMap['exercise_name']);
    prefs.setInt('exercise_duration', workoutMap['exercise_duration']);
    prefs.setInt('exercise_sets', workoutMap['exercise_sets']);
    prefs.setInt('exercise_reps', workoutMap['exercise_reps']);
    if (workoutMap['exercise_video_url'] != null) {
      prefs.setString('exercise_video_url', workoutMap['exercise_video_url']);
    }
    if (workoutMap['exercise_notes'] != null) {
      prefs.setString('exercise_notes', workoutMap['exercise_notes']);
    }
  }

  // Static method to load workout from local storage
  static Future<Workout?> loadFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final exercise = prefs.getString('exercise_name');
    
    if (exercise != null) {
      final duration = prefs.getInt('exercise_duration') ?? 0;
      final sets = prefs.getInt('exercise_sets') ?? 0;
      final reps = prefs.getInt('exercise_reps') ?? 0;
      final videoUrl = prefs.getString('exercise_video_url');
      final notes = prefs.getString('exercise_notes');
      
      return Workout(
        exercise: exercise,
        duration: duration,
        sets: sets,
        reps: reps,
        videoUrl: videoUrl,
        notes: notes,
      );
    }
    return null;
  }
}

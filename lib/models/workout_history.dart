import 'package:shared_preferences/shared_preferences.dart';

class WorkoutHistory {
  String workoutName;
  DateTime date;
  String status; // "Completed", "Pending"
  String? notes; // Nullable notes for extra information like feedback.

  WorkoutHistory({
    required this.workoutName,
    required this.date,
    required this.status,
    this.notes,
  });

  // Method to mark workout as completed and update the status
  void markAsCompleted() {
    status = "Completed";
    // You can save it to local storage here as well
  }

  Map<String, dynamic> toMap() {
    return {
      'workout_name': workoutName,
      'workout_status': status,
      'workout_date': date.toIso8601String(),
      'workout_notes': notes,
    };
  }


  factory WorkoutHistory.fromMap(Map<String, dynamic> map) {
    return WorkoutHistory(
      workoutName: map['workout_name'],
      date: DateTime.parse(map['workout_date']),
      status: map['workout_status'] ?? "Pending", // Default to "Pending" if no status
      notes: map['workout_notes'],
    );
  }

  // Method to save workout history to local storage using shared preferences
  Future<void> saveToLocalStorage() async {
    // Use SharedPreferences or any other local storage method
    final prefs = await SharedPreferences.getInstance();
    final workoutHistoryMap = toMap();
    prefs.setString('workout_name', workoutHistoryMap['workout_name']);
    prefs.setString('workout_status', workoutHistoryMap['workout_status']);
    prefs.setString('workout_date', workoutHistoryMap['workout_date']);
    if (workoutHistoryMap['workout_notes'] != null) {
      prefs.setString('workout_notes', workoutHistoryMap['workout_notes']);
    }
  }

  // Static method to load workout history from local storage
  static Future<WorkoutHistory?> loadFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final workoutName = prefs.getString('workout_name');
    if (workoutName != null) {
      final status = prefs.getString('workout_status') ?? "Pending";
      final date = DateTime.parse(prefs.getString('workout_date') ?? DateTime.now().toIso8601String());
      final notes = prefs.getString('workout_notes');
      return WorkoutHistory(workoutName: workoutName, date: date, status: status, notes: notes);
    }
    return null;
  }
}

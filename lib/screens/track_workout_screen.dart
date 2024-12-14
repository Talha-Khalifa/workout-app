import 'package:flutter/material.dart';
// import '../helper/shared_preferences_helper.dart';
// import '../models/workout_history.dart'; // Import the WorkoutHistory model

class TrackWorkoutScreen extends StatefulWidget {
  @override
  _TrackWorkoutScreenState createState() => _TrackWorkoutScreenState();
}

class _TrackWorkoutScreenState extends State<TrackWorkoutScreen> {
  final TextEditingController _workoutNameController = TextEditingController();
  String _status = 'Pending'; // Default status
  List<WorkoutHistory> _workoutHistoryList = [];

  @override
  void initState() {
    super.initState();
    _loadWorkoutHistory();
  }

  // Function to load workout history from SharedPreferences
  void _loadWorkoutHistory() async {
    final history = await SharedPreferencesHelper().getWorkoutHistory();
    setState(() {
      _workoutHistoryList = history;
    });
  }

  // Function to save workout history
  void _saveWorkoutHistory() async {
    final workoutHistory = WorkoutHistory(
      workoutName: _workoutNameController.text,
      date: DateTime.now(),
      status: _status,
    );

    // Get existing history and add the new one
    final currentHistory = await SharedPreferencesHelper().getWorkoutHistory();
    currentHistory.add(workoutHistory);

    // Save updated history
    await SharedPreferencesHelper().saveWorkoutHistory(currentHistory);

    // Update the local list and UI
    setState(() {
      _workoutHistoryList = currentHistory;
    });

    // Show confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Workout saved: ${_workoutNameController.text}')),
    );
    _workoutNameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Workout'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _workoutNameController,
              decoration: const InputDecoration(
                labelText: 'Workout Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: _status,
              onChanged: (String? newValue) {
                setState(() {
                  _status = newValue!;
                });
              },
              items: <String>['Pending', 'Completed']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveWorkoutHistory,
              child: const Text('Save Workout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _workoutHistoryList.length,
                itemBuilder: (context, index) {
                  final workout = _workoutHistoryList[index];
                  return ListTile(
                    title: Text(workout.workoutName),
                    subtitle: Text(
                        '${workout.status} - ${workout.date.toLocal().toString().split(' ')[0]}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// SharedPreferencesHelper class to manage data persistence
class SharedPreferencesHelper {
  // Function to get workout history
  Future<List<WorkoutHistory>> getWorkoutHistory() async {
    // Simulated data retrieval
    return []; // Replace with actual implementation
  }

  // Function to save workout history
  Future<void> saveWorkoutHistory(List<WorkoutHistory> history) async {
    // Simulated data saving
    // Replace with actual implementation
  }
}

// WorkoutHistory model class
class WorkoutHistory {
  final String workoutName;
  final DateTime date;
  final String status;

  WorkoutHistory({
    required this.workoutName,
    required this.date,
    required this.status,
  });

  // Add fromJson and toJson methods for saving and retrieving from SharedPreferences
  factory WorkoutHistory.fromJson(Map<String, dynamic> json) {
    return WorkoutHistory(
      workoutName: json['workoutName'],
      date: DateTime.parse(json['date']),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'workoutName': workoutName,
      'date': date.toIso8601String(),
      'status': status,
    };
  }
}

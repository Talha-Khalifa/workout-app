import 'package:flutter/material.dart';
import 'package:workout_app/models/workout_history.dart' as model;
import 'package:workout_app/screens/track_workout_screen.dart' as screen;
import 'package:workout_app/helper/shared_preferences_helper.dart' as helper;

// import '../helper/shared_preferences_helper.dart';
// import '../models/workout_history.dart';
// import '../screens/track_workout_screen.dart';

class WorkoutHistoryScreen extends StatefulWidget {
  @override
  _WorkoutHistoryScreenState createState() => _WorkoutHistoryScreenState();
}

class _WorkoutHistoryScreenState extends State<WorkoutHistoryScreen> {
  late Future<List<model.WorkoutHistory>> _workoutHistoryFuture;

  @override
  void initState() {
    super.initState();
    _loadWorkoutHistory();
  }

  Future<void> _loadWorkoutHistory() async {
    setState(() {
      _workoutHistoryFuture = helper.SharedPreferencesHelper().getWorkoutHistory();
    });
  }

  Future<void> _addWorkoutHistory(model.WorkoutHistory workoutHistory) async {
    final workoutHistoryList = await helper.SharedPreferencesHelper().getWorkoutHistory();
    workoutHistoryList.add(workoutHistory);
    await helper.SharedPreferencesHelper().saveWorkoutHistory(workoutHistoryList);
    _loadWorkoutHistory();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Workout history added successfully')),
    );
  }

  Future<void> _removeWorkoutHistory(model.WorkoutHistory workoutHistory) async {
    final workoutHistoryList = await helper.SharedPreferencesHelper().getWorkoutHistory();
    workoutHistoryList.removeWhere((item) =>
        item.workoutName == workoutHistory.workoutName &&
        item.date == workoutHistory.date);
    await helper.SharedPreferencesHelper().saveWorkoutHistory(workoutHistoryList);
    _loadWorkoutHistory();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Workout history removed successfully')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout History'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<model.WorkoutHistory>>(
          future: _workoutHistoryFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Error loading data.'));
            }

            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'No workouts recorded yet.',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => screen.TrackWorkoutScreen(),
                          ),
                        ).then((value) => _loadWorkoutHistory());
                      },
                      child: const Text('Track Workout'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final workoutHistory = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              workoutHistory.workoutName,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Date: ${workoutHistory.date}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Status: ${workoutHistory.status}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete),
                              color: Colors.red,
                              onPressed: () {
                                _removeWorkoutHistory(workoutHistory);
                              },
                            ),
                            Icon(
                              Icons.fitness_center,
                              color: Colors.teal,
                              size: 30,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => screen.TrackWorkoutScreen(),
            ),
          ).then((value) => _loadWorkoutHistory());
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
    );
  }
}

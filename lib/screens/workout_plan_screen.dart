import 'package:flutter/material.dart';
import '../helper/shared_preferences_helper.dart';
import '../screens/edit_workout_plan_screen.dart';
import '../models/workout_plan.dart';

class WorkoutPlanScreen extends StatefulWidget {
  @override
  _WorkoutPlanScreenState createState() => _WorkoutPlanScreenState();
}

class _WorkoutPlanScreenState extends State<WorkoutPlanScreen> {
  late Future<WorkoutPlan?> _workoutPlanFuture;

  @override
  void initState() {
    super.initState();
    _workoutPlanFuture = SharedPreferencesHelper().getWorkoutPlan();
  }

  Future<void> _saveWorkoutPlan(WorkoutPlan workoutPlan) async {
    await SharedPreferencesHelper().saveWorkoutPlan(workoutPlan);
    setState(() {
      _workoutPlanFuture = SharedPreferencesHelper().getWorkoutPlan();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Plan'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<WorkoutPlan?>(
          future: _workoutPlanFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Error loading data.'));
            }

            if (!snapshot.hasData) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'No workout plan found. Please create one.',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditWorkoutPlanScreen(),
                          ),
                        );
                      },
                      child: const Text('Create Workout Plan'),
                    ),
                  ],
                ),
              );
            }

            final workoutPlan = snapshot.data!;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Workout Plan: ${workoutPlan.workoutName}',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Text('Duration: ${workoutPlan.duration} minutes'),
                Text('Exercises: ${workoutPlan.exercises.join(', ')}'),
                Text('Goal: ${workoutPlan.goal}'),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditWorkoutPlanScreen(),
                      ),
                    );
                  },
                  child: const Text('Edit Workout Plan'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../helper/shared_preferences_helper.dart';
import '../models/workout_plan.dart';

class EditWorkoutPlanScreen extends StatefulWidget {
  @override
  _EditWorkoutPlanScreenState createState() => _EditWorkoutPlanScreenState();
}

class _EditWorkoutPlanScreenState extends State<EditWorkoutPlanScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _exercisesController = TextEditingController();
  final TextEditingController _goalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadWorkoutPlan();
  }

  // Load workout plan asynchronously from SharedPreferences
  Future<void> _loadWorkoutPlan() async {
    final plan = await SharedPreferencesHelper().getWorkoutPlan();
    if (plan != null) {
      setState(() {
        _nameController.text = plan.workoutName;
        _durationController.text = plan.duration.toString();
        _exercisesController.text = plan.exercises.join(', ');
        _goalController.text = plan.goal;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _durationController.dispose();
    _exercisesController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  // Save workout plan asynchronously to SharedPreferences
  Future<void> _saveWorkoutPlan() async {
    if (_formKey.currentState!.validate()) {
      final plan = WorkoutPlan(
        workoutName: _nameController.text,
        duration: int.parse(_durationController.text),
        exercises: _exercisesController.text.split(', '),
        goal: _goalController.text,
      );
      await SharedPreferencesHelper().saveWorkoutPlan(plan);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Workout Plan'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Workout Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a workout name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(labelText: 'Duration (minutes)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a duration';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _exercisesController,
                decoration: const InputDecoration(labelText: 'Exercises (comma separated)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter exercises';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _goalController,
                decoration: const InputDecoration(labelText: 'Goal'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a goal';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveWorkoutPlan,
                child: const Text('Save Workout Plan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:workout_app/models/workout.dart';
// import 'package:workout_app/models/workout_history.dart';
// import 'package:workout_app/models/workout_plan.dart';

// class ApiHelper {
//   static const String baseUrl = 'https://your-api-url.com/api/'; // Your API base URL

//   // GET request to fetch workout plans
//   Future<WorkoutPlan?> fetchWorkoutPlan() async {
//     try {
//       final response = await http.get(Uri.parse('$baseUrl/workoutPlan'));
//       if (response.statusCode == 200) {
//         return WorkoutPlan.fromMap(json.decode(response.body));
//       } else {
//         throw Exception('Failed to load workout plan');
//       }
//     } catch (e) {
//       throw Exception('Failed to load workout plan: $e');
//     }
//   }

//   // POST request to send workout data
//   Future<void> sendWorkout(Workout workout) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$baseUrl/workout'),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode(workout.toMap()),
//       );
//       if (response.statusCode != 201) {
//         throw Exception('Failed to create workout');
//       }
//     } catch (e) {
//       throw Exception('Failed to send workout: $e');
//     }
//   }

//   // GET request to fetch workout history
//   Future<List<WorkoutHistory>> fetchWorkoutHistory() async {
//     try {
//       final response = await http.get(Uri.parse('$baseUrl/workoutHistory'));
//       if (response.statusCode == 200) {
//         List<dynamic> data = json.decode(response.body);
//         return data.map((e) => WorkoutHistory.fromMap(e)).toList();
//       } else {
//         throw Exception('Failed to load workout history');
//       }
//     } catch (e) {
//       throw Exception('Failed to load workout history: $e');
//     }
//   }

//   // PUT request to update a workout plan (if applicable)
//   Future<void> updateWorkoutPlan(WorkoutPlan workoutPlan) async {
//     try {
//       final response = await http.put(
//         Uri.parse('$baseUrl/workoutPlan/${workoutPlan.id}'),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode(workoutPlan.toMap()),
//       );
//       if (response.statusCode != 200) {
//         throw Exception('Failed to update workout plan');
//       }
//     } catch (e) {
//       throw Exception('Failed to update workout plan: $e');
//     }
//   }
// }

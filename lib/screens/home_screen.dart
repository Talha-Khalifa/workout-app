import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'workout_history_screen.dart';
import 'track_your_progress.dart';
import 'setting_screen.dart';
import 'workout_plan_screen.dart';

/// HomeScreen class with navigation to other screens.
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late SharedPreferences _prefs;
  bool? _notificationsEnabled = false;

  List<String> _welcomeMessages = [
    "Welcome back, let's crush your fitness goals today!",
    "Ready to push your limits? Let's get started!",
    "Good to see you again! Let's make today count!",
  ];
  String _randomWelcomeMessage = "";

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _setRandomWelcomeMessage();
  }

  Future<void> _loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = _prefs.getBool('notificationsEnabled') ?? false;
    });
  }

  void _setRandomWelcomeMessage() {
    setState(() {
      _randomWelcomeMessage = _welcomeMessages[
          DateTime.now().millisecondsSinceEpoch % _welcomeMessages.length];
    });
  }

  Future<void> _savePreferences() async {
    _prefs.setBool('notificationsEnabled', _notificationsEnabled ?? false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Random Welcome Text
            Text(
              _randomWelcomeMessage,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'What would you like to do today?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // Track Your Progress Button
            _buildCustomButton(
              context,
              'Track Your Progress',
              TrackYourProgressScreen(),
              Colors.orange,
            ),
            const SizedBox(height: 20),

            // Workout History Button
            _buildCustomButton(
              context,
              'View Workout History',
              WorkoutHistoryScreen(),
              Colors.blueAccent,
            ),
            const SizedBox(height: 20),

            // Workout Plan Button
            _buildCustomButton(
              context,
              'View Workout Plan',
              WorkoutPlanScreen(),
              Colors.purpleAccent,
            ),
            const SizedBox(height: 20),

            // Settings Button
            _buildCustomButton(
              context,
              'Settings',
              SettingsScreen(),
              Colors.redAccent,
            ),
            const SizedBox(height: 20),

            // Notification Switch
            SwitchListTile(
              title: const Text('Enable Notifications'),
              value: _notificationsEnabled ?? false,
              onChanged: (bool value) {
                setState(() {
                  _notificationsEnabled = value;
                });
                _savePreferences();
              },
              activeColor: Colors.green,
              inactiveThumbColor: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  // Custom button to avoid code repetition
  ElevatedButton _buildCustomButton(
    BuildContext context,
    String text,
    Widget screen,
    Color color,
  ) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        textStyle: const TextStyle(fontSize: 18),
        backgroundColor: color, // Button color dynamically passed
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 5, // Adding shadow effect for a modern look
      ),
      child: Text(text),
    );
  }
}

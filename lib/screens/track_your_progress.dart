import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// TrackYourProgressScreen class to show the user's progress.
class TrackYourProgressScreen extends StatefulWidget {
  @override
  _TrackYourProgressScreenState createState() => _TrackYourProgressScreenState();
}

class _TrackYourProgressScreenState extends State<TrackYourProgressScreen> {
  late SharedPreferences _prefs;
  List<Progress> _progressList = [];
  final TextEditingController _goalController = TextEditingController();
  bool? _notificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = _prefs.getBool('notificationsEnabled') ?? false;
      _progressList = _loadProgress();
    });
  }

  List<Progress> _loadProgress() {
    List<String>? progressData = _prefs.getStringList('progressList');
    if (progressData != null) {
      return progressData.map((item) => Progress.fromJson(item)).toList();
    }
    return [
      Progress(title: 'Weekly Progress', value: 75, color: Colors.blue),
      Progress(title: 'Monthly Progress', value: 60, color: Colors.orange),
    ];
  }

  Future<void> _savePreferences() async {
    _prefs.setBool('notificationsEnabled', _notificationsEnabled ?? false);
    _prefs.setStringList(
      'progressList',
      _progressList.map((progress) => progress.toJson()).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Your Progress'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Fitness Progress',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Keep track of your weekly and monthly fitness progress here. '
              'Review your goals, achievements, and set new targets.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: _progressList.length,
                itemBuilder: (context, index) {
                  return _buildProgressCard(_progressList[index]);
                },
              ),
            ),
            const SizedBox(height: 20),
            _buildSettingsSection(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewGoal,
        child: const Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
    );
  }

  Widget _buildProgressCard(Progress progress) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  progress.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${progress.value}%',
                  style: TextStyle(
                    fontSize: 16,
                    color: progress.color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            // CircularProgressIndicator(
            //   value: progress.value / 100,
            //   strokeWidth: 8,
            //   valueColor: AlwaysStoppedAnimation<Color>(progress.color),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          title: const Text('Enable Notifications'),
          value: _notificationsEnabled ?? false,
          onChanged: (bool value) {
            setState(() {
              _notificationsEnabled = value;
            });
            _savePreferences();
          },
        ),
        const SizedBox(height: 20),
        _buildActionButton(
          'Reset Progress',
          Colors.redAccent,
          () {
            showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Reset Progress'),
                content: const Text('Are you sure you want to reset your progress?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _progressList.clear();
                      });
                      _savePreferences();
                      Navigator.pop(context);
                    },
                    child: const Text('Reset'),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 5,
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }

  void _addNewGoal() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Add New Goal'),
        content: TextField(
          controller: _goalController,
          decoration: const InputDecoration(hintText: 'Enter your goal'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _progressList.add(
                  Progress(title: _goalController.text, value: 0, color: Colors.green),
                );
                _goalController.clear();
              });
              _savePreferences();
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

class Progress {
  String title;
  double value;
  Color color;

  Progress({
    required this.title,
    required this.value,
    required this.color,
  });

  Progress.fromJson(String json)
      : title = json.split('|')[0],
        value = double.parse(json.split('|')[1]),
        color = Color(int.parse(json.split('|')[2]));

  String toJson() {
    return '$title|$value|${color.value}';
  }
}

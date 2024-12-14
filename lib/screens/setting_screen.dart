import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// SettingsScreen class to modify user preferences and settings.
class SettingsScreen extends StatefulWidget {
  
  final bool initialNotificationsEnabled;
  final bool initialDarkModeEnabled;

  SettingsScreen({
    Key? key,
    this.initialNotificationsEnabled = true,
    this.initialDarkModeEnabled = false,
  }): super(key: key);

  SettingsScreen.updateProfile({
    Key? key,
    bool initialNotificationsEnabled = true,
    bool initialDarkModeEnabled = false,
  }) : //super(key: key),
  this(
    initialNotificationsEnabled: initialNotificationsEnabled,
    initialDarkModeEnabled: initialDarkModeEnabled,
  );

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _isNotificationsEnabled;
  late bool _isDarkModeEnabled;
  bool _isAccountPrivate = false;
  // String _language = 'English';

  Map<String, bool> _settings = {
    'notifications': true,
    'darkMode': false,
    'accountPrivate': false,
  };

  @override
  void initState() {
    super.initState();
    _isNotificationsEnabled = widget.initialNotificationsEnabled;
    _isDarkModeEnabled = widget.initialDarkModeEnabled;
    _loadSettings();
  }

  // Load saved preferences when the screen is initialized
  void _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isNotificationsEnabled = prefs.getBool('notifications') ?? true;
      _isDarkModeEnabled = prefs.getBool('darkMode') ?? false;
      _isAccountPrivate = prefs.getBool('accountPrivate') ?? false;
      // _language = prefs.getString('language') ?? 'English';
    });
  }

  // Save preferences when the user toggles switches
  void _saveSettings({bool? notifications, bool? darkMode, bool? accountPrivate, String? language}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (notifications != null) {
      prefs.setBool('notifications', notifications);
    }
    if (darkMode != null) {
      prefs.setBool('darkMode', darkMode);
    }
    if (accountPrivate != null) {
      prefs.setBool('accountPrivate', accountPrivate);
    }
    if (language != null) {
      prefs.setString('language', language);
    }
  }

  bool get isNotificationsEnabled => _isNotificationsEnabled;
  set isNotificationsEnabled(bool value) {
    setState(() {
      _isNotificationsEnabled = value;
    });
    _saveSettings(notifications: value);
  }

  bool get isDarkModeEnabled => _isDarkModeEnabled;
  set isDarkModeEnabled(bool value) {
    setState(() {
      _isDarkModeEnabled = value;
    });
    _saveSettings(darkMode: value);
  }

  // Toggle a specific setting
  void _toggleSetting(String key) {
    setState(() {
      _settings[key] = !_settings[key]!;
    });
    _saveSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Title for settings screen
            const Text(
              'App Settings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 20),

            // Notification toggle setting
            _buildSwitchTile(
              'Enable Notifications',
              'Receive notifications for workout reminders and progress updates.',
              _isNotificationsEnabled,
              (bool value) {
                isNotificationsEnabled = value;
              },
            ),

            const SizedBox(height: 20),

            // Dark mode toggle setting
            _buildSwitchTile(
              'Enable Dark Mode',
              'Switch to dark mode for a better night-time experience.',
              _isDarkModeEnabled,
              (bool value) {
                isDarkModeEnabled = value;
              },
            ),

            const SizedBox(height: 20),

            // Account private toggle setting
            _buildSwitchTile(
              'Account Private',
              'Make your account private to restrict access.',
              _isAccountPrivate,
              (bool value) {
                setState(() {
                  _isAccountPrivate = value;
                });
                _saveSettings(accountPrivate: value);
              },
            ),

            const SizedBox(height: 20),

            // Profile update button (can add functionality later)
            _buildActionButton(
              context,
              'Update Profile',
              Colors.blueAccent,
              () {
                _showDialog(context, 'Update Profile', 'You can update your profile here.');
              },
            ),
            const SizedBox(height: 20),

            // Logout button
            _buildActionButton(
              context,
              'Logout',
              Colors.redAccent,
              () {
                _showDialog(context, 'Logout', 'Are you sure you want to logout?', isLogout: true);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to create a switch tile for toggle settings
  Widget _buildSwitchTile(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.teal,
        ),
      ),
    );
  }

  // Action button for various actions like logout, profile update
  Widget _buildActionButton(BuildContext context, String text, Color color, VoidCallback onPressed) {
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

  // Show a dialog for profile update or logout confirmation
  void _showDialog(BuildContext context, String title, String content, {bool isLogout = false}) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close'),
          ),
          if (isLogout)
            TextButton(
              onPressed: () async {
                // Add your logout functionality here
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove('userLoggedIn'); // Remove stored user login data
                Navigator.pop(context);
                // Navigate to login screen or show a confirmation
              },
              child: const Text('Logout'),
            ),
        ],
      ),
    );
  }
}

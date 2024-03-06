import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;

  SettingsScreen({Key? key, required this.onThemeChanged}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 20),
        children: <Widget>[
          ListTile(
            title: Text(
              'Theme',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          RadioListTile(
            title: Text('Follow System'),
            value: ThemeMode.system,
            groupValue: _themeMode,
            onChanged: (value) {
              setState(() {
                _themeMode = value as ThemeMode;
              });
              widget.onThemeChanged(_themeMode); // Notify parent widget
            },
          ),
          RadioListTile(
            title: Text('Dark Mode'),
            value: ThemeMode.dark,
            groupValue: _themeMode,
            onChanged: (value) {
              setState(() {
                _themeMode = value as ThemeMode;
              });
              widget.onThemeChanged(_themeMode); // Notify parent widget
            },
          ),
          RadioListTile(
            title: Text('Light Mode'),
            value: ThemeMode.light,
            groupValue: _themeMode,
            onChanged: (value) {
              setState(() {
                _themeMode = value as ThemeMode;
              });
              widget.onThemeChanged(_themeMode); // Notify parent widget
            },
          ),
        ],
      ),
    );
  }
}

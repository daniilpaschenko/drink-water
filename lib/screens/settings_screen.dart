import 'package:flutter/material.dart';
import '../widgets/appbar.dart'; // appbar из отдельного файла

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildMainAppBar(context: context)
    );
  }
}
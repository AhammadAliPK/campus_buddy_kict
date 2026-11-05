import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // State variables
  String _nickname = 'Guest Student';
  String _bio = 'Kuliyyah of ICT Year 4.';
  String _matric = '2316589';

  // Text editing controllers
  late final TextEditingController _nicknameCtrl;
  late final TextEditingController _bioCtrl;
  late final TextEditingController _matricCtrl;

  bool _editing = false;

  @override
  void initState() {
    super.initState();
    _nicknameCtrl = TextEditingController(text: _nickname);
    _bioCtrl = TextEditingController(text: _bio);
    _matricCtrl = TextEditingController(text: _matric);
  }

  @override
  void dispose() {
    _nicknameCtrl.dispose();
    _bioCtrl.dispose();
    _matricCtrl.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      if (_editing) {
        // Homework 2: Fall back to 'Guest Student' if empty or whitespace only
        final trimmedName = _nicknameCtrl.text.trim();
        _nickname = trimmedName.isEmpty ? 'Guest Student' : trimmedName;

        _bio = _bioCtrl.text.trim();

        // Homework 1: Read matric value
        final trimmedMatric = _matricCtrl.text.trim();
        _matric = trimmedMatric.isEmpty ? '2316589' : trimmedMatric;
      }
      _editing = !_editing;
    });
  }

  // Exercise D: Reset back to initial default values
  void _resetDefaults() {
    setState(() {
      _nickname = 'Guest Student';
      _bio = 'Kuliyyah of ICT Year 4.';
      _matric = '2316589';

      _nicknameCtrl.text = _nickname;
      _bioCtrl.text = _bio;
      _matricCtrl.text = _matric;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: Icon(_editing ? Icons.check : Icons.edit),
            onPressed: _toggleEdit,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Homework 3: Local asset photo
            const Center(
              child: CircleAvatar(
                radius: 48,
                backgroundImage: AssetImage('assets/me.jpeg'),
              ),
            ),
            const SizedBox(height: 12),
            if (_editing) ...[
              // Nickname field
              TextField(
                controller: _nicknameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nickname',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 12),
              // Homework 1: Matric number field with number keyboard
              TextField(
                controller: _matricCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Matric Number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.badge),
                ),
              ),
              const SizedBox(height: 12),
              // Bio field
              TextField(
                controller: _bioCtrl,
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  labelText: 'Bio',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _toggleEdit,
                icon: const Icon(Icons.save),
                label: const Text('Save'),
              ),
              // Exercise D: Reset button
              TextButton(
                onPressed: _resetDefaults,
                child: const Text('Reset'),
              ),
            ] else ...[
              // Display mode
              Text(
                _nickname,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                _bio,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 6),
              // Homework 1: Small grey matric display
              Text(
                _matric,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black45, fontSize: 13),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
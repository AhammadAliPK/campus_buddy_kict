import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // State variables
  String _nickname = 'Guest Student';
  String _bio =
      'Kuliyyah of ICT · Year 2 · Loves nasi ayam and clean code.';
  String _matric = '2317819';

  // Text Controllers
  final _nicknameCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();
  final _matricCtrl = TextEditingController();

  bool _editing = false;

  @override
  void initState() {
    super.initState();
    _nicknameCtrl.text = _nickname;
    _bioCtrl.text = _bio;
    _matricCtrl.text = _matric;
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
        // Homework #2: Fallback to 'Guest Student' if empty or spaces only
        final trimmedName = _nicknameCtrl.text.trim();
        _nickname = trimmedName.isEmpty ? 'Guest Student' : trimmedName;

        _bio = _bioCtrl.text.trim();
        _matric = _matricCtrl.text.trim();
      }
      _editing = !_editing;
    });
  }

  void _resetProfile() {
    setState(() {
      _nickname = 'Guest Student';
      _bio = 'Kuliyyah of ICT · Year 2 · Loves nasi ayam and clean code.';
      _matric = '2317819';

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
            // Homework #3: Local Asset Image
            const CircleAvatar(
              radius: 48,
              backgroundImage: AssetImage('assets/me.jpg'),
            ),
            const SizedBox(height: 12),

            if (_editing) ...[
              // Nickname Input
              TextField(
                controller: _nicknameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nickname',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 12),

              // Bio Input
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

              // Homework #1: Matric Number Input
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

              // Save Button
              ElevatedButton.icon(
                onPressed: _toggleEdit,
                icon: const Icon(Icons.save),
                label: const Text('Save'),
              ),
              const SizedBox(height: 8),

              // Exercise D: Reset Button
              TextButton(
                onPressed: _resetProfile,
                child: const Text('Reset'),
              ),
            ] else ...[
              // View Mode: Display Nickname
              Text(
                _nickname,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),

              // View Mode: Display Bio
              Text(
                _bio,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 6),

              // Homework #1: Display Matric Number (small grey text)
              Text(
                'Matric No: $_matric',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
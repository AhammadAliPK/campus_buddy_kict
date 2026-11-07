
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Profile information
  String _nickname = 'Guest Student';
  String _bio = 'Kuliyyah of ICT · Year 2 · Loves nasi ayam and clean code.';
  String _matric = '202300000';

  // Text controllers
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

  // Switch between editing and displaying profile
  void _toggleEdit() {
    if (_editing) {
      setState(() {
        // Prevent empty nickname
        _nickname = _nicknameCtrl.text.trim().isEmpty
            ? 'Guest Student'
            : _nicknameCtrl.text.trim();

        _bio = _bioCtrl.text.trim();
        _matric = _matricCtrl.text.trim();

        _editing = false;
      });
    } else {
      setState(() {
        _editing = true;
      });
    }
  }

  // Reset profile to default values
  void _resetProfile() {
    setState(() {
      _nickname = 'Guest Student';
      _bio = 'Kuliyyah of ICT · Year 2 · Loves nasi ayam and clean code.';
      _matric = '202300000';

      // Reset text fields too
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
            // Profile picture
            Center(
              child: ClipOval(
                child: SizedBox(
                  width: 96,
                  height: 96,
                  child: Image.asset(
                    'assets/me.jpg',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Editing mode
            if (_editing) ...[
              TextField(
                controller: _nicknameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nickname',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),

              const SizedBox(height: 12),

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

              // Matric number input
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

              // Save button
              ElevatedButton.icon(
                onPressed: _toggleEdit,
                icon: const Icon(Icons.save),
                label: const Text('Save'),
              ),

              const SizedBox(height: 8),

              // Reset button
              TextButton(
                onPressed: _resetProfile,
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

              const SizedBox(height: 8),

              // Matric number in small grey text
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

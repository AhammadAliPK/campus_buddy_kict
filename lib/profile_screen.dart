import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _nickname = 'Guest Student';
  String _matric = '2313233'; 
  final _matricCtrl = TextEditingController();
  String _bio = 'Kuliyyah of ICT Year 2\nLoves nasi ayam and clean code.';

  final _nicknameCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    _nicknameCtrl.text = _nickname; // pre-fill from current state
    _bioCtrl.text = _bio;
    _matricCtrl.text = _matric;
  }

  @override
  void dispose() {
    _nicknameCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
    _matricCtrl.dispose();
  }

  void _toggleEdit() {
    setState(() {
      if (_editing) {
      String newName = _nicknameCtrl.text.trim();
        _nickname = newName.isEmpty ? 'Guest Student' : newName;
        _bio = _bioCtrl.text.trim();
        _matric = _matricCtrl.text.trim();
      }
      _editing = !_editing;
    });
  }

  void _resetProfile() {
    setState(() {
      _nickname = 'Guest Student';
      _matric = '2313233';
      _bio = 'Kuliyyah of ICT Year 2\nLoves nasi ayam and clean code.';
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
            ClipOval(
              child: Image.asset(
                'assets/me.jpg',
                width: 96,
                height: 96,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 12),
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
              TextField(
                controller: _matricCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Matric Number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _toggleEdit,
                icon: const Icon(Icons.save),
                label: const Text('Save'),
              ),
              const SizedBox(height: 8),
            TextButton(
              onPressed: _resetProfile,
              child: const Text('Reset to Default'),
            ),
            ] else ...[
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
              Text(
                _matric,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
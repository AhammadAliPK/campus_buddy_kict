import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _nickname = 'Nik Aliff';
  String _bio = 'Kuliyyah of ICT · Year 4 · Loves nasi ayam and clean code.';
  String _matric = '2317891';
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
    // pre-fill from current state
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
        // leaving edit mode: copy controller values into state
        String inputName = _nicknameCtrl.text.trim();
        // 👇 Check if empty, fallback to 'Guest Student' if it is
        _nickname = inputName.isEmpty ? 'Guest Student' : inputName;
        _bio = _bioCtrl.text.trim();
        _matric = _matricCtrl.text.trim();
      }
    });
    _editing = !_editing;
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
            const CircleAvatar(
              radius: 48,
              backgroundImage: AssetImage('assets/pp2.jpg'),
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
                controller: _matricCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Matric Number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.pin),
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
              ElevatedButton.icon(
                onPressed: _toggleEdit,
                icon: const Icon(Icons.save),
                label: const Text('Save'),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    // 1. Reset the underlying state strings back to default values
                    _nickname = 'Guest Student';
                    _bio = 'Kuliyyah of ICT · Year 2 · Loves nasi ayam and clean code.';
                    _matric = '2317891';
                     // 2. Immediately update the text inside the input fields
                     _nicknameCtrl.text = _nickname;
                     _bioCtrl.text = _bio;
                     _matricCtrl.text = _matric;
                     // 3. Exit editing mode so it shows the freshly reset profile view
                     _editing = false;
                    });
                   },
                   icon: const Icon(Icons.refresh, color: Colors.red),
                   label: const Text('Reset', style: TextStyle(color: Colors.red)),
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
              Text(
                _matric,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black38, fontSize: 14),
              )
            ],
          ],
        ),
      ),
    );
  }
}
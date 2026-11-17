
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _nickname = 'Guest Student';
  String _bio =
      'Kuliyyah of ICT · Year 2 · Loves nasi ayam and clean code.';
  String _matric = '2314323';

  bool _editing = false;

  final TextEditingController _nicknameController =
      TextEditingController();

  final TextEditingController _bioController =
      TextEditingController();

  final TextEditingController _matricController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    _nicknameController.text = _nickname;
    _bioController.text = _bio;
    _matricController.text = _matric;
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _bioController.dispose();
    _matricController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    if (_editing) {
      setState(() {
        _nickname = _nicknameController.text.trim().isEmpty
            ? 'Guest Student'
            : _nicknameController.text.trim();

        _bio = _bioController.text.trim();
        _matric = _matricController.text.trim();

        _nicknameController.text = _nickname;
      });
    }

    setState(() {
      _editing = !_editing;
    });
  }

  void _resetProfile() {
    setState(() {
      _nickname = 'Guest Student';
      _bio =
          'Kuliyyah of ICT · Year 2 · Loves nasi ayam and clean code.';
      _matric = '2314323';

      _nicknameController.text = _nickname;
      _bioController.text = _bio;
      _matricController.text = _matric;

      _editing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _toggleEdit,
            icon: Icon(_editing ? Icons.check : Icons.edit),
            tooltip: _editing ? 'Save profile' : 'Edit profile',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            children: [
              const CircleAvatar(
                radius: 55,
                backgroundImage: AssetImage('assets/me.jpg'),
                ),
              

              const SizedBox(height: 24),

              if (_editing) ...[
                TextField(
                  controller: _nicknameController,
                  decoration: const InputDecoration(
                    labelText: 'Nickname',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: _bioController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Bio',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: _matricController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Matric Number',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: _toggleEdit,
                  child: const Text('Save Profile'),
                ),

                TextButton(
                  onPressed: _resetProfile,
                  child: const Text('Reset Profile'),
                ),
              ] else ...[
                Text(
                  _nickname,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  _bio,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),

                const SizedBox(height: 8),

                Text(
                  'Matric No: $_matric',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 20),

                OutlinedButton(
                  onPressed: _resetProfile,
                  child: const Text('Reset Profile'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

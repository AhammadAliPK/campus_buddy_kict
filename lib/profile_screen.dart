
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _nickname = 'Nor Nadhira';
  String _bio =
      'Computer Science student who enjoys learning, building apps, and exploring new ideas.';

  final _nicknameCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();

  bool _editing = false;

  @override
  void initState() {
    super.initState();
    _nicknameCtrl.text = _nickname;
    _bioCtrl.text = _bio;
  }

  @override
  void dispose() {
    _nicknameCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      if (_editing) {
        if (_nicknameCtrl.text.trim().isNotEmpty) {
          _nickname = _nicknameCtrl.text.trim();
        }

        _bio = _bioCtrl.text.trim();
      } else {
        _nicknameCtrl.text = _nickname;
        _bioCtrl.text = _bio;
      }

      _editing = !_editing;
    });
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: Color(0xFF007C80),
        ),
      ),
    );
  }

  Widget _infoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFDDF5F2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF007C80),
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            tooltip: _editing ? 'Save profile' : 'Edit profile',
            icon: Icon(_editing ? Icons.check : Icons.edit_outlined),
            onPressed: _toggleEdit,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF009FA3),
                    Color(0xFF007C80),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 43,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 39,
                      backgroundColor: const Color(0xFFDDF5F2),
                      child: Text(
                        _nickname.trim().isEmpty
                            ? 'S'
                            : _nickname.trim()[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF007C80),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_editing)
                    TextField(
                      controller: _nicknameCtrl,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        labelText: 'Display name',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    )
                  else
                    Text(
                      _nickname,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  const SizedBox(height: 8),
                  const Text(
                    'Computer Science Student',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'IIUM · KICT',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle('About Me'),
                    if (_editing)
                      TextField(
                        controller: _bioCtrl,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          labelText: 'Your bio',
                          alignLabelWithHint: true,
                        ),
                      )
                    else
                      Text(
                        _bio,
                        style: const TextStyle(
                          height: 1.6,
                          fontSize: 14,
                        ),
                      ),
                    if (_editing) ...[
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: _toggleEdit,
                          icon: const Icon(Icons.save_outlined),
                          label: const Text('Save Changes'),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle('Student Information'),
                    _infoTile(
                      icon: Icons.school_outlined,
                      title: 'University',
                      value: 'International Islamic University Malaysia',
                    ),
                    _infoTile(
                      icon: Icons.account_balance_outlined,
                      title: 'Kulliyyah',
                      value: 'Kulliyyah of Information and Communication Technology',
                    ),
                    _infoTile(
                      icon: Icons.computer_outlined,
                      title: 'Programme',
                      value: 'Bachelor of Computer Science (Software Engineering)',
                    ),
                    _infoTile(
                      icon: Icons.auto_stories_outlined,
                      title: 'Current Project',
                      value: 'Final Year Project II',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Made for IIUM students 🩵',
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

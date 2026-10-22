import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _nickname = 'Guest Student';
  String _bio = 'Kuliyyah of ICT · Year 2 · Loves nasi ayam and clean code.';
  String _matricNo = 'xxxxxxx';

  final _nicknameCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();
  final _matricNoCtrl = TextEditingController();
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    _nicknameCtrl.text = _nickname;
    _bioCtrl.text = _bio;
    _matricNoCtrl.text = _matricNo;
  }

  @override
  void dispose() {
    _nicknameCtrl.dispose();
    _bioCtrl.dispose();
    _matricNoCtrl.dispose();
    super.dispose();
  }

  void _toggleEditing() {
    setState(() {
      if (_editing) {
        _nickname = _nicknameCtrl.text.trim();
        _nickname = _nickname.isEmpty ? 'Guest Student' : _nickname; //keep default name if the user leave empty

        _bio = _bioCtrl.text.trim();
        _matricNo = _matricNoCtrl.text.trim();
        _matricNo = _matricNo.isEmpty ? 'xxxxxxx' : _matricNo; //keep default matric number if the user leave empty

      }
      _editing = !_editing;
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
            onPressed: _toggleEditing,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 48,
                    backgroundImage: AssetImage('assets/profile.jpeg'),
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
                      controller: _matricNoCtrl,
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        labelText: 'Matric Number',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 12),

                    ElevatedButton.icon(
                      onPressed: _toggleEditing,
                      icon: const Icon(Icons.save),
                      label: const Text('Save'),
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
                      _matricNo,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

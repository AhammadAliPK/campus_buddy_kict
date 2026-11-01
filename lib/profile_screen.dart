import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

// Default displayed info
  String _nickname = 'Guest Student';
  String _bio = 'Kuliyyah of ICT · Year 2 · Loves nasi ayam and clean code.';
  String _matric = '2023000000';

// Allow displayed info editing
  final _nicknameCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();
  final _matricCtrl =  TextEditingController();
  bool _editing = false;

  @override
  void initState() {
    // Pre-fill the page with current values
    super.initState();
    _nicknameCtrl.text = _nickname;
    _bioCtrl.text = _bio;
    _matricCtrl.text = _matric;
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

        // Empty nickname
        if(_nicknameCtrl.text.trim().isEmpty){
          _nickname = 'Guest Student';
        }
        // Filled nickname
        else{
          _nickname = _nicknameCtrl.text.trim();
        }

        // Save bio and matric number
        _bio = _bioCtrl.text.trim();
        _matric = _matricCtrl.text.trim();
      }

      // Change state to not editing
      _editing = !_editing;
    });
  }

  void reset() {
    // Restore original nickname and text
    _nickname = 'Guest Student';
    _bio = 'Kuliyyah of ICT · Year 2 · Loves nasi ayam and clean code.';
    _matric = '202300000';

    //Restore boxes
    _nicknameCtrl.text = _nickname;
    _bioCtrl.text = _bio;
    _matricCtrl.text = _matric;
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
            Center(
              child: ClipOval(
                child: Image.asset(
                  'assets/profile_pic.jpg',
                  width: 96,
                  height: 96,
                  fit: BoxFit.cover,
                ),
              )
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

              const SizedBox(height : 12),
              TextField(
                controller: _matricCtrl,
                maxLines : 1,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Matric No.',
                  border : OutlineInputBorder(),
                  prefixIcon: Icon(Icons.numbers)
                ),
              ),

              //Save button
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _toggleEdit,
                icon: const Icon(Icons.save),
                label: const Text('Save'),
              ),

              //Reset button
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: reset,
                icon: const Icon(Icons.restore),
                label: const Text('Reset'),
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
                style: const TextStyle(color: Colors.black54)
              )


            ],
          ],
        ),
      ),
    );
  }
}

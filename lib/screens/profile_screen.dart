import 'package:flutter/material.dart';

import '../app_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({required this.appState, super.key});

  final CampusBuddyState appState;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final TextEditingController _nicknameController;
  late final TextEditingController _bioController;
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    _nicknameController = TextEditingController(text: widget.appState.nickname);
    _bioController = TextEditingController(text: widget.appState.bio);
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _toggleEditing() {
    if (_editing) {
      widget.appState.updateProfile(
        nickname: _nicknameController.text,
        bio: _bioController.text,
      );
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Profile saved.')));
    }
    setState(() => _editing = !_editing);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            onPressed: _toggleEditing,
            icon: Icon(_editing ? Icons.check : Icons.edit),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          CircleAvatar(
            radius: 52,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            child: Text(
              widget.appState.nickname.substring(0, 1).toUpperCase(),
              style: TextStyle(
                fontSize: 42,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (_editing) ...[
            TextField(
              controller: _nicknameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _bioController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Bio',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _toggleEditing,
              icon: const Icon(Icons.save),
              label: const Text('Save profile'),
            ),
          ] else ...[
            Text(
              widget.appState.nickname,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(widget.appState.bio, textAlign: TextAlign.center),
          ],
          const SizedBox(height: 24),
          Card(
            child: Column(
              children: const [
                ListTile(
                  leading: Icon(Icons.badge_outlined),
                  title: Text('Matric number'),
                  subtitle: Text('2312887'),
                ),
                ListTile(
                  leading: Icon(Icons.groups_outlined),
                  title: Text('Section'),
                  subtitle: Text('Section 1'),
                ),
                ListTile(
                  leading: Icon(Icons.school_outlined),
                  title: Text('Programme'),
                  subtitle: Text('Kulliyyah of ICT'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

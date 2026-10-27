import 'package:flutter/material.dart';
class ProfileScreen extends StatefulWidget {
 const ProfileScreen({super.key});
 
 State<ProfileScreen> createState() => _ProfileScreenState();
}
class _ProfileScreenState extends State<ProfileScreen> {
 String _nickname = 'Guest Student';
 String _bio =
 'Kuliyyah of ICT · Year 2 · Loves nasi ayam and clean code.';
 final _nicknameCtrl = TextEditingController();
 final _bioCtrl = TextEditingController();
 bool _editing = false;
 @override
 void initState() {
 super.initState();
 _nicknameCtrl.text = _nickname; // pre-fill from current state
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
 // leaving edit mode: copy controller values into state
 _nickname = _nicknameCtrl.text.trim();
 _bio = _bioCtrl.text.trim();
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
 backgroundImage: NetworkImage('https://picsum.photos/200'),
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
 ElevatedButton.icon(
 onPressed: _toggleEdit,
 icon: const Icon(Icons.save),
 label: const Text('Save'),
 ),
 const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  setState(() {
                    // Reset profile text values
                    _nickname = 'Guest Student';
                    _bio =
                        'Kulliyyah of ICT · Year 2 · Loves nasi ayam and clean code.';

                    // Reset text field controller values so the input boxes clear too
                    _nicknameCtrl.text = 'Guest Student';
                    _bioCtrl.text =
                        'Kulliyyah of ICT · Year 2 · Loves nasi ayam and clean code.';
                  });
                },
                child: const Text('Reset'),
              ),
 ] else ...[
 Text(_nickname,
 style: Theme.of(context).textTheme.headlineSmall,
 textAlign: TextAlign.center),
 const SizedBox(height: 6),
 Text(_bio,
 textAlign: TextAlign.center,
 style: const TextStyle(color: Colors.black54)),
 ],
 ],
 ),
 ),
 );
 }
}
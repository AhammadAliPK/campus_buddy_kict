import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _nickname ='Dayah';
  String _bio = 
    'Kulliyyah of ICT . Year 4 . Loves coffee and sleeping.'; 

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

  void _toogleEdit(){
    setState((){
      if (_editing){
        _nickname = _nicknameCtrl.text.trim();
        _bio = _bioCtrl.text.trim();
      }
      else{
        _nicknameCtrl.text = _nickname;
        _bioCtrl.text = _bio;
      }

      _editing = !_editing;
    });
  }


 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyProfile'),
        actions: [
          IconButton(
            icon:Icon(_editing ? Icons.check : Icons.edit),
            onPressed: _toogleEdit,
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
              backgroundImage: NetworkImage('https://picsum.photos/200',),
                      ),
            const SizedBox(height: 12),
            if (_editing) ...[ 
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
                onPressed: _toogleEdit,
                icon: const Icon(Icons.save),
                label: const Text('Save'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    // Reset variables back to original values
                    _nickname = 'Dayah';
                    _bio = 'Kulliyyah of ICT . Year 2 . Loves nasi ayam and clean code.';
                    
                    // Reset controller text boxes so the next edit starts clean
                    _nicknameCtrl.text = _nickname;
                    _bioCtrl.text = _bio;

                    
                    _editing = false;
                  });
                },
                child: const Text('Reset'),
              ),
            ]else ...[
              Text(
                _nickname,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 6),
              Text( 
              _bio,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54),
              ),
            ],
          ],
            ),
          
        ),
      );
   
  }

}
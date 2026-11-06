import 'package:flutter/material.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Buddy KICT'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => Navigator.pushNamed(context, '/about'),
          )
        ]
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(child: ListTile(
            leading: Icon(Icons.wb_twilight),
            title: Text('Prayer times'),
            subtitle: Text('Arrives in Week 8'),
            trailing: Icon(Icons.chevron_right),
          )),
          Card(child: ListTile(
            leading: Icon(Icons.link),
            title: Text('Campus links'),
            subtitle: Text('Arrives in Week 7'),
            trailing: Icon(Icons.chevron_right),
          )),
          Card(child: ListTile(
            onTap: () => Navigator.pushNamed(context, '/about'),
            leading: Icon(Icons.info_outline),
            title: Text('About Campus Buddy KICT'),
            trailing: Icon(Icons.chevron_right),
          )),
        ],
      )
    );
  }
}

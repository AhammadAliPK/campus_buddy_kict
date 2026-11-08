import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/shell_screen.dart';
import 'package:campus_buddy_kict/screen/about_screen.dart';  

void main() => runApp(const CampusBuddyKictApp());
class CampusBuddyKictApp extends StatelessWidget{
  const CampusBuddyKictApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Campus Buddy KICT',

      routes:{ 
        '/about':(context) => const AboutScreen(),
      },

      home: const ShellScreen(),

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      
      
    );
  }
}

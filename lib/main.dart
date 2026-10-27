import 'package:flutter/cupertino.dart';
import 'package:campus_buddy_kict/courses_screen.dart';

void main() => runApp(const CampusBuddyKictApp());

class CampusBuddyKictApp extends StatelessWidget {
  const CampusBuddyKictApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'Campus Buddy KICT',
      theme: CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: CupertinoColors.activeBlue,
      ),
      home: PhoneFrameWrapper(child: CoursesScreen()),
    );
  }
}

/// Wraps any screen inside an iPhone device frame on web/desktop
class PhoneFrameWrapper extends StatelessWidget {
  final Widget child;
  const PhoneFrameWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1E1E1E), // Dark background behind phone
      child: Center(
        child: Container(
          width: 390,  // iPhone width
          height: 844, // iPhone height
          decoration: BoxDecoration(
            color: CupertinoColors.systemBackground,
            borderRadius: BorderRadius.circular(48), // Rounded phone corners
            border: Border.all(color: const Color(0xFF333333), width: 10), // Phone bezel
            boxShadow: [
              BoxShadow(
                color: CupertinoColors.black.withOpacity(0.5),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(38),
            child: Stack(
              children: [
                child,
                // iPhone Dynamic Island / Notch
                Positioned(
                  top: 8,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      width: 120,
                      height: 30,
                      decoration: BoxDecoration(
                        color: CupertinoColors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
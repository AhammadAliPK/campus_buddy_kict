import 'package:flutter/material.dart';

class ClearFavouritesScreen extends StatelessWidget {
  const ClearFavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clear Favourites')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Are you sure?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Yes and No buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, true); // this return true if yes
                  },
                  child: const Text('Yes'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, false); // return false if no
                  },
                  child: const Text('No'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// The favourite status of each course is stored in the Courses screen.
// The Home screen cannot clear all favourites because the course data is only
// accessible within the Courses screen. To solve this, I need to use state management
// which allows different screens to share and access the same data.
// This way, the Home screen can also update the favourite status of courses.

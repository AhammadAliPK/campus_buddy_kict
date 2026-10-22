import 'package:flutter/material.dart';
import 'package:campus_buddy_kict/data/courses.dart';
class CoursesScreen extends StatefulWidget {
	const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  bool _isGrid = false;
  String _selectedDay = 'All';
  final List<String> _days = [
    'All',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday'
  ];

  final Map<String, int> _dayOrder = {
    'Monday': 1,
    'Tuesday': 2,
    'Wednesday': 3,
    'Thursday': 4,
    'Friday': 5,
    'Saturday': 6,
    'Sunday': 7,
  };

	@override
	Widget build(BuildContext context) {
		num totalCh = 0;
		for (final c in sampleCourses) {
			totalCh += c.creditHours;
		}
  
    final filtered = _selectedDay == 'All'
        ? sampleCourses
        : sampleCourses.where((c) => c.day == _selectedDay).toList();

    final shown = List.of(filtered);
    shown.sort((a, b) {
      final dayA = _dayOrder[a.day] ?? 99;
      final dayB = _dayOrder[b.day] ?? 99;
      return dayA.compareTo(dayB);
    });
		return Scaffold(
			appBar: AppBar(
				title: Text('My Courses · $totalCh CH'),
				actions: [
					IconButton(
						icon: _isGrid ? const Icon(Icons.grid_on) : const Icon(Icons.list),
						tooltip: 'Grid view',
						onPressed: () => setState(() => _isGrid = !_isGrid),
					),
				],
			),
			body: Column(
				children: [
					Card(
						margin: const EdgeInsets.all(12),
						child: Padding(
							padding: const EdgeInsets.all(12),
							child: Text(
								'${sampleCourses.length} courses  .  $totalCh credit hours',
							),
						),
					),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: _days.map((day) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(day),
                    selected: _selectedDay == day,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedDay = day;
                        });
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
					Expanded(
            child: shown.isEmpty
                ? const Center(
                    child: Text(
                      'No classes! Alhamdulillah :)',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  )
						:_isGrid 
            ? GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // two cards per row
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: shown.length,
            itemBuilder: (context, index) {
              final course = shown[index];
              return Card(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(course.icon, size: 40),
                      const SizedBox(height: 8),
                      Text(course.code,
                      style: const TextStyle(
                      fontWeight: FontWeight.bold)),
                      Text(course.name,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              );
            },
              )
             
             :ListView.builder(
							padding: const EdgeInsets.symmetric(vertical: 8),
							itemCount: shown.length,
							itemBuilder: (context, index) {
								final course = shown[index];
                final dayAbbr = course.day.length >= 3
                    ? course.day.substring(0, 3)
                    : course.day;

								return ListTile(
                  tileColor: index.isOdd // ← NEW
                  ? Colors.black.withValues(alpha: 0.03)
                  : null,
									leading: CircleAvatar(
										backgroundColor: Theme.of(context).colorScheme.primaryContainer,
										child: Icon(
											course.icon,
											color: Theme.of(context).colorScheme.onPrimaryContainer,
										),
									),

									title: Text(course.code),
									subtitle: Text('$dayAbbr ${course.time} · ${course.venue}'),
									trailing: Text(course.instructor ?? 'TBA'),
									onTap: () => ScaffoldMessenger.of(context).showSnackBar(
										SnackBar(content: Text('${course.code} tapped')),
									),
								);
							},
						),
					),
				],
			),
		);
	}
}
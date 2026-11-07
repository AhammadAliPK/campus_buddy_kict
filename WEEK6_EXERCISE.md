# Week 6 exercise — why Home can't clear the favourites

The favourites live in the `_courses` list inside `_CoursesScreenState`, which is private to the Courses screen. Home and Courses are separate widgets in the shell's `IndexedStack`. Neither one has a reference to the other, so when the confirmation screen pops `true` on Home, there is no list Home can change and no `setState` it can call to rebuild Courses. Fixing this needs **state management**: move the course list out of the Courses screen into a shared place above both tabs (for example a `ChangeNotifier` with Provider), so that any screen can read it and change it, and every screen that shows it rebuilds.

When the same "clear all favourites" confirmation is opened from the Courses tab (the ☆ button in its AppBar), it works, because that code runs inside the State that owns `_courses`.

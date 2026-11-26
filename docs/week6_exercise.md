# Week 6 exercise: "A screen that answers, part 2"

The Home tab has a "Clear all favourites" card. It opens a full confirmation
screen (`ConfirmScreen`: a Scaffold with "Are you sure?" and Yes / No) that pops
`true` or `false`.

**Why Home can't clear anything.** The favourites are stored in the `_courses`
list inside `_CoursesScreenState`, which is private to the Courses screen.
`HomeScreen` and `CoursesScreen` are siblings under the shell's `IndexedStack`,
so Home has no reference to that State object and no way to change its list.
A screen can only change data it owns or data that is handed to it. To fix this,
the course list has to move out of the Courses screen into a place both screens
can reach. That concept is **state management** (lifting state up into the
shell, or a shared store such as Provider).

**Where it works.** The same confirmation flow runs from the ☆ button in the
Courses tab's app bar. There the list is in reach, so pressing Yes clears every
star.

import 'dart:io';

String calculateGrade(double average) {
  if (average >= 80) {
    return 'A';
  } else if (average >= 70) {
    return 'B';
  } else if (average >= 60) {
    return 'C';
  } else if (average >= 50) {
    return 'D';
  } else {
    return 'F';
  }
}

void main() {
  stdout.write("Student name: ");
  String name = stdin.readLineSync() ?? '';

  stdout.write("Student ID: ");
  String id = stdin.readLineSync() ?? '';

  stdout.write("Number of subjects: ");
  int numSubjects = int.tryParse(stdin.readLineSync() ?? '0') ?? 0;

  List<int> marks = [];
  int totalMarks = 0;
  int highestMark = -1;
  int lowestMark = 101;
  int passed = 0;
  int failed = 0;

  for (int i = 1; i <= numSubjects; i++) {
    stdout.write("Enter mark $i: ");
    int mark = int.tryParse(stdin.readLineSync() ?? '0') ?? 0;
    marks.add(mark);
    
    totalMarks += mark;

    if (i == 1) {
      highestMark = mark;
      lowestMark = mark;
    } else {
      if (mark > highestMark) highestMark = mark;
      if (mark < lowestMark) lowestMark = mark;
    }

    if (mark >= 50) {
      passed++;
    } else {
      failed++;
    }
  }

  double average = numSubjects > 0 ? totalMarks / numSubjects : 0.0;
  String grade = calculateGrade(average);
  String status = average >= 50 ? "PASS" : "FAIL";

  print("\n==================================================");
  print(" STUDENT GRADE REPORT");
  print("==================================================");
  print("Student Name : $name");
  print("Student ID : $id");
  print("Subjects : $numSubjects");
  print("\nMarks:");
  print(marks);
  print("\n--------------------------------------------------");
  print("Total Marks : $totalMarks");
  print("Average : ${average.toStringAsFixed(2)}");
  print("Highest Mark : $highestMark");
  print("Lowest Mark : $lowestMark");
  print("Subjects Passed : $passed");
  print("Subjects Failed : $failed");
  print("Grade : $grade");
  print("Status : $status");
  print("==================================================");
}
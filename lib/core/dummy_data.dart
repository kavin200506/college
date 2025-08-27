import 'dart:math';
import 'package:flutter/material.dart';
import 'models/models.dart';

class DummyData {
  static final Random _random = Random();

  static List<Subject> getSubjects() {
    return [
      Subject(
        id: '1',
        name: 'Java Programming',
        code: 'CS101',
        color: Colors.blue,
        description: 'Object-oriented programming fundamentals',
        progress: 0.75,
      ),
      Subject(
        id: '2',
        name: 'C++ Programming',
        code: 'CS102',
        color: Colors.green,
        description: 'Advanced programming concepts and data structures',
        progress: 0.60,
      ),
      Subject(
        id: '3',
        name: 'Operating Systems',
        code: 'CS201',
        color: Colors.orange,
        description: 'System calls, processes, and memory management',
        progress: 0.45,
      ),
      Subject(
        id: '4',
        name: 'Data Structures & Algorithms',
        code: 'CS301',
        color: Colors.red,
        description: 'Efficient algorithms and data organization',
        progress: 0.80,
      ),
      Subject(
        id: '5',
        name: 'Applied Science',
        code: 'AS101',
        color: Colors.purple,
        description: 'Mathematics and physics applications',
        progress: 0.55,
      ),
      Subject(
        id: '6',
        name: 'Environmental Science',
        code: 'ES101',
        color: Colors.teal,
        description: 'Sustainability and environmental awareness',
        progress: 0.70,
      ),
    ];
  }

  static List<Assignment> getAssignments() {
    return [
      Assignment(
        id: '1',
        title: 'Implement Binary Search Tree',
        subjectId: '4',
        subjectName: 'DSA',
        assignedDate: DateTime.now().subtract(const Duration(days: 5)),
        deadline: DateTime.now().add(const Duration(days: 2)),
        isCompleted: false,
        description: 'Create a complete BST implementation with insert, delete, and search operations',
        priority: Priority.high,
      ),
      Assignment(
        id: '2',
        title: 'Java Inheritance Lab',
        subjectId: '1',
        subjectName: 'Java Programming',
        assignedDate: DateTime.now().subtract(const Duration(days: 3)),
        deadline: DateTime.now().add(const Duration(days: 5)),
        isCompleted: false,
        description: 'Demonstrate inheritance concepts using real-world examples',
        priority: Priority.medium,
      ),
      Assignment(
        id: '3',
        title: 'OS Process Scheduling',
        subjectId: '3',
        subjectName: 'Operating Systems',
        assignedDate: DateTime.now().subtract(const Duration(days: 10)),
        deadline: DateTime.now().subtract(const Duration(days: 1)),
        isCompleted: false,
        description: 'Simulate different process scheduling algorithms',
        priority: Priority.high,
      ),
      Assignment(
        id: '4',
        title: 'C++ Pointers Exercise',
        subjectId: '2',
        subjectName: 'C++ Programming',
        assignedDate: DateTime.now().subtract(const Duration(days: 7)),
        deadline: null,
        isCompleted: true,
        description: 'Practice pointer arithmetic and memory management',
        priority: Priority.medium,
      ),
      Assignment(
        id: '5',
        title: 'Environmental Impact Report',
        subjectId: '6',
        subjectName: 'Environmental Science',
        assignedDate: DateTime.now().subtract(const Duration(days: 2)),
        deadline: DateTime.now().add(const Duration(days: 10)),
        isCompleted: false,
        description: 'Analyze environmental impact of technology',
        priority: Priority.low,
      ),
      Assignment(
        id: '6',
        title: 'Applied Mathematics Quiz',
        subjectId: '5',
        subjectName: 'Applied Science',
        assignedDate: DateTime.now().subtract(const Duration(days: 12)),
        deadline: null,
        isCompleted: true,
        description: 'Calculus and linear algebra problems',
        priority: Priority.medium,
      ),
    ];
  }

  static List<Student> getMatchedStudents() {
    final interests = ['Programming', 'Web Development', 'Mobile Apps', 'AI/ML', 'Game Development', 'Cybersecurity', 'Data Science'];
    final names = ['Alex Chen', 'Priya Sharma', 'Rahul Patel', 'Sarah Johnson', 'Kevin Wu', 'Ananya Gupta', 'Michael Brown', 'Riya Singh'];
    final courses = ['Computer Science', 'Information Technology', 'Software Engineering'];

    return List.generate(6, (index) {
      final name = names[index];
      return Student(
        id: 'student_$index',
        name: name,
        phone: '+91 ${9000000000 + _random.nextInt(99999999)}',
        email: '${name.toLowerCase().replaceAll(' ', '.')}@college.edu',
        course: courses[_random.nextInt(courses.length)],
        year: _random.nextInt(3) + 2, // Year 2-4
        interests: (interests..shuffle()).take(_random.nextInt(3) + 2).toList(),
        subjects: ['Java', 'C++', 'DSA'].where((s) => _random.nextBool()).toList(),
        avatarUrl: '',
      );
    });
  }

  static UserProfile getUserProfile() {
    return UserProfile(
      name: 'Kavin Kumar',
      course: 'Computer Science Engineering',
      year: 3,
      interests: ['Programming', 'Web Development', 'AI/ML', 'Mobile Apps'],
      skills: ['Java', 'C++', 'Python', 'Flutter', 'React', 'Node.js'],
    );
  }

  static List<Assignment> getUpcomingAssignments() {
    return getAssignments()
    .where((a) => !a.isCompleted && a.deadline != null)
    .toList()
    ..sort((a, b) => a.deadline!.compareTo(b.deadline!));
  }
}

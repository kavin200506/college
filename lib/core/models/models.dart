import 'package:flutter/material.dart';

class Subject {
  final String id;
  final String name;
  final String code;
  final Color color;
  final String description;
  final double progress; // 0.0 to 1.0

  Subject({
    required this.id,
    required this.name,
    required this.code,
    required this.color,
    required this.description,
    required this.progress,
  });
}

class Assignment {
  final String id;
  final String title;
  final String subjectId;
  final String subjectName;
  final DateTime assignedDate;
  final DateTime? deadline;
  final bool isCompleted;
  final String description;
  final Priority priority;

  Assignment({
    required this.id,
    required this.title,
    required this.subjectId,
    required this.subjectName,
    required this.assignedDate,
    this.deadline,
    required this.isCompleted,
    required this.description,
    required this.priority,
  });

  bool get isOverdue =>
  deadline != null &&
  !isCompleted &&
  DateTime.now().isAfter(deadline!);
}

enum Priority { low, medium, high }

class Student {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String course;
  final int year;
  final List<String> interests;
  final List<String> subjects;
  final String avatarUrl;

  Student({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.course,
    required this.year,
    required this.interests,
    required this.subjects,
    required this.avatarUrl,
  });
}

class UserProfile {
  final String name;
  final String course;
  final int year;
  final List<String> interests;
  final List<String> skills;

  UserProfile({
    required this.name,
    required this.course,
    required this.year,
    required this.interests,
    required this.skills,
  });
}

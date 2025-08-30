import 'package:flutter/material.dart';

enum StudentProgress { notStarted, inProgress, understood }
enum TopicFilter { all, completed, pending, inProgress }

class SubjectTopic {
  final String id;
  final String title;
  final String description;
  final double teacherProgress; // 0.0 to 1.0
  final StudentProgress studentProgress;
  final List<TopicNote> notes;
  final List<QuizResult> quizResults;
  final bool hasDiscussion;
  final int discussionCount;

  SubjectTopic({
    required this.id,
    required this.title,
    required this.description,
    required this.teacherProgress,
    required this.studentProgress,
    required this.notes,
    required this.quizResults,
    required this.hasDiscussion,
    required this.discussionCount,
  });

  bool get isTeacherCompleted => teacherProgress >= 1.0;
  double get averageQuizScore {
    if (quizResults.isEmpty) return 0.0;
    return quizResults.map((q) => q.score).reduce((a, b) => a + b) / quizResults.length;
  }
}

class TopicNote {
  final String id;
  final String title;
  final String content;
  final String author;
  final DateTime createdAt;
  final String? fileUrl;

  TopicNote({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.createdAt,
    this.fileUrl,
  });
}

class QuizResult {
  final String id;
  final String quizName;
  final double score; // 0.0 to 100.0
  final DateTime completedAt;
  final int totalQuestions;
  final int correctAnswers;

  QuizResult({
    required this.id,
    required this.quizName,
    required this.score,
    required this.completedAt,
    required this.totalQuestions,
    required this.correctAnswers,
  });
}

class SubjectRecommendation {
  final String topicId;
  final String topicTitle;
  final String reason;
  final RecommendationType type;

  SubjectRecommendation({
    required this.topicId,
    required this.topicTitle,
    required this.reason,
    required this.type,
  });
}

enum RecommendationType { review, practice, focus }

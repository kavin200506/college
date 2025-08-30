import 'dart:math';
import '../models/subject_models.dart';

class SubjectTopicsData {
  static final Random _random = Random();

  static List<SubjectTopic> getTopicsForSubject(String subjectId) {
    switch (subjectId) {
      case '1': // Java Programming
        return _generateJavaTopics();
      case '2': // C++ Programming
        return _generateCppTopics();
      case '3': // Operating Systems
        return _generateOSTopics();
      case '4': // Data Structures & Algorithms
        return _generateDSATopics();
      case '5': // Applied Science
        return _generateAppliedScienceTopics();
      case '6': // Environmental Science
        return _generateEnvironmentalScienceTopics();
      default:
        return [];
    }
  }

  static List<SubjectTopic> _generateJavaTopics() {
    final topics = [
      'Introduction to Java & JVM',
      'Variables, Data Types & Operators',
      'Control Structures & Loops',
      'Methods & Parameter Passing',
      'Object-Oriented Programming Concepts',
      'Classes and Objects',
      'Inheritance & Polymorphism',
      'Abstract Classes & Interfaces',
      'Exception Handling',
      'Collections Framework',
      'Generics in Java',
      'File I/O Operations',
      'Multithreading & Concurrency',
      'Lambda Expressions & Streams',
      'JDBC Database Connectivity',
      'GUI Development with Swing',
      'Unit Testing with JUnit',
    ];

    return topics.asMap().entries.map((entry) {
      return SubjectTopic(
        id: 'java_${entry.key}',
        title: entry.value,
        description: 'Learn ${entry.value.toLowerCase()} concepts and practical applications',
        teacherProgress: _random.nextDouble(),
        studentProgress: StudentProgress.values[_random.nextInt(3)],
        notes: _generateSampleNotes(entry.key),
        quizResults: _generateSampleQuizResults(entry.key),
        hasDiscussion: _random.nextBool(),
        discussionCount: _random.nextInt(25),
      );
    }).toList();
  }

  static List<SubjectTopic> _generateCppTopics() {
    final topics = [
      'Introduction to C++ & Compilation',
      'Variables, Constants & Data Types',
      'Operators & Expressions',
      'Control Flow Statements',
      'Functions & Function Overloading',
      'Arrays & Strings',
      'Pointers & References',
      'Dynamic Memory Allocation',
      'Classes & Objects',
      'Constructors & Destructors',
      'Inheritance & Access Specifiers',
      'Virtual Functions & Polymorphism',
      'Operator Overloading',
      'Templates & Generic Programming',
      'Standard Template Library (STL)',
      'File Handling in C++',
      'Exception Handling Mechanisms',
    ];

    return topics.asMap().entries.map((entry) {
      return SubjectTopic(
        id: 'cpp_${entry.key}',
        title: entry.value,
        description: 'Master ${entry.value.toLowerCase()} with hands-on practice',
        teacherProgress: _random.nextDouble(),
        studentProgress: StudentProgress.values[_random.nextInt(3)],
        notes: _generateSampleNotes(entry.key),
        quizResults: _generateSampleQuizResults(entry.key),
        hasDiscussion: _random.nextBool(),
        discussionCount: _random.nextInt(30),
      );
    }).toList();
  }

  static List<SubjectTopic> _generateOSTopics() {
    final topics = [
      'Introduction to Operating Systems',
      'System Calls & System Programs',
      'Process Management & PCB',
      'Process Synchronization',
      'Deadlocks & Prevention',
      'CPU Scheduling Algorithms',
      'Memory Management Techniques',
      'Virtual Memory & Paging',
      'File Systems & Directory Structure',
      'I/O Systems & Device Management',
      'Mass Storage Structure',
      'Distributed Systems Concepts',
      'Security & Protection',
      'Unix/Linux Commands',
      'Shell Scripting Basics',
      'System Performance Monitoring',
      'Virtualization Technologies',
    ];

    return topics.asMap().entries.map((entry) {
      return SubjectTopic(
        id: 'os_${entry.key}',
        title: entry.value,
        description: 'Understand ${entry.value.toLowerCase()} and system internals',
        teacherProgress: _random.nextDouble(),
        studentProgress: StudentProgress.values[_random.nextInt(3)],
        notes: _generateSampleNotes(entry.key),
        quizResults: _generateSampleQuizResults(entry.key),
        hasDiscussion: _random.nextBool(),
        discussionCount: _random.nextInt(20),
      );
    }).toList();
  }

  static List<SubjectTopic> _generateDSATopics() {
    final topics = [
      'Arrays & Array Operations',
      'Linked Lists & Variations',
      'Stacks & Stack Applications',
      'Queues & Circular Queues',
      'Trees & Binary Trees',
      'Binary Search Trees',
      'Heap Data Structure',
      'Hash Tables & Hashing',
      'Graphs & Graph Representations',
      'Sorting Algorithms',
      'Searching Algorithms',
      'Dynamic Programming',
      'Greedy Algorithms',
      'Divide & Conquer',
      'Backtracking Techniques',
      'Time & Space Complexity',
      'Advanced Tree Algorithms',
    ];

    return topics.asMap().entries.map((entry) {
      return SubjectTopic(
        id: 'dsa_${entry.key}',
        title: entry.value,
        description: 'Master ${entry.value.toLowerCase()} with problem-solving',
        teacherProgress: _random.nextDouble(),
        studentProgress: StudentProgress.values[_random.nextInt(3)],
        notes: _generateSampleNotes(entry.key),
        quizResults: _generateSampleQuizResults(entry.key),
        hasDiscussion: _random.nextBool(),
        discussionCount: _random.nextInt(35),
      );
    }).toList();
  }

  static List<SubjectTopic> _generateAppliedScienceTopics() {
    final topics = [
      'Calculus & Derivatives',
      'Integral Calculus',
      'Linear Algebra & Matrices',
      'Probability & Statistics',
      'Discrete Mathematics',
      'Set Theory & Relations',
      'Graph Theory Basics',
      'Number Theory',
      'Physics: Mechanics',
      'Electricity & Magnetism',
      'Wave Motion & Optics',
      'Thermodynamics Principles',
      'Modern Physics Concepts',
      'Engineering Mathematics',
      'Numerical Methods',
      'Scientific Computing',
      'Mathematical Modeling',
    ];

    return topics.asMap().entries.map((entry) {
      return SubjectTopic(
        id: 'science_${entry.key}',
        title: entry.value,
        description: 'Explore ${entry.value.toLowerCase()} and their applications',
        teacherProgress: _random.nextDouble(),
        studentProgress: StudentProgress.values[_random.nextInt(3)],
        notes: _generateSampleNotes(entry.key),
        quizResults: _generateSampleQuizResults(entry.key),
        hasDiscussion: _random.nextBool(),
        discussionCount: _random.nextInt(15),
      );
    }).toList();
  }

  static List<SubjectTopic> _generateEnvironmentalScienceTopics() {
    final topics = [
      'Ecosystem & Biodiversity',
      'Environmental Pollution',
      'Climate Change & Global Warming',
      'Natural Resource Management',
      'Water Conservation Techniques',
      'Air Quality & Monitoring',
      'Waste Management Systems',
      'Renewable Energy Sources',
      'Sustainable Development',
      'Environmental Impact Assessment',
      'Green Technology Solutions',
      'Carbon Footprint Reduction',
      'Wildlife Conservation',
      'Soil Conservation Methods',
      'Environmental Laws & Policies',
      'Urban Environmental Planning',
      'Environmental Health & Safety',
    ];

    return topics.asMap().entries.map((entry) {
      return SubjectTopic(
        id: 'env_${entry.key}',
        title: entry.value,
        description: 'Learn about ${entry.value.toLowerCase()} and environmental solutions',
        teacherProgress: _random.nextDouble(),
        studentProgress: StudentProgress.values[_random.nextInt(3)],
        notes: _generateSampleNotes(entry.key),
        quizResults: _generateSampleQuizResults(entry.key),
        hasDiscussion: _random.nextBool(),
        discussionCount: _random.nextInt(12),
      );
    }).toList();
  }

  static List<TopicNote> _generateSampleNotes(int topicIndex) {
    final noteCount = _random.nextInt(5) + 1;
    return List.generate(noteCount, (index) {
      return TopicNote(
        id: 'note_${topicIndex}_$index',
        title: 'Study Notes ${index + 1}',
        content: 'Important concepts and key points for better understanding...',
        author: ['Prof. Smith', 'Dr. Johnson', 'Sarah Chen', 'Mike Wilson'][_random.nextInt(4)],
        createdAt: DateTime.now().subtract(Duration(days: _random.nextInt(30))),
        fileUrl: _random.nextBool() ? 'sample_file.pdf' : null,
      );
    });
  }

  static List<QuizResult> _generateSampleQuizResults(int topicIndex) {
    final quizCount = _random.nextInt(3);
    return List.generate(quizCount, (index) {
      final totalQuestions = 10 + _random.nextInt(15);
      final correctAnswers = _random.nextInt(totalQuestions + 1);
      return QuizResult(
        id: 'quiz_${topicIndex}_$index',
        quizName: 'Practice Quiz ${index + 1}',
        score: (correctAnswers / totalQuestions) * 100,
        completedAt: DateTime.now().subtract(Duration(days: _random.nextInt(7))),
        totalQuestions: totalQuestions,
        correctAnswers: correctAnswers,
      );
    });
  }

  static List<SubjectRecommendation> generateRecommendations(List<SubjectTopic> topics) {
    final recommendations = <SubjectRecommendation>[];
    
    for (final topic in topics) {
      if (topic.studentProgress == StudentProgress.notStarted && topic.isTeacherCompleted) {
        recommendations.add(SubjectRecommendation(
          topicId: topic.id,
          topicTitle: topic.title,
          reason: 'Teacher has completed this topic. Start learning!',
          type: RecommendationType.focus,
        ));
      } else if (topic.averageQuizScore < 60 && topic.quizResults.isNotEmpty) {
        recommendations.add(SubjectRecommendation(
          topicId: topic.id,
          topicTitle: topic.title,
          reason: 'Low quiz scores. Consider revision.',
          type: RecommendationType.review,
        ));
      } else if (topic.studentProgress == StudentProgress.inProgress) {
        recommendations.add(SubjectRecommendation(
          topicId: topic.id,
          topicTitle: topic.title,
          reason: 'Continue practicing to master this topic.',
          type: RecommendationType.practice,
        ));
      }
    }
    
    return recommendations.take(5).toList();
  }
}

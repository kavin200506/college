import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

// ==================== DATA MODELS ====================

class Student {
  final String id;
  final String name;
  final String profileImageUrl;
  final List<String> skills;
  final Map<String, dynamic> performanceData;

  Student({
    required this.id,
    required this.name,
    required this.profileImageUrl,
    required this.skills,
    required this.performanceData,
  });
}

class PerformanceData {
  final List<ProjectResult> projects;
  final List<QuizResult> quizzes;

  PerformanceData({
    required this.projects,
    required this.quizzes,
  });
}

class ProjectResult {
  final String projectName;
  final String category;
  final int score; // 0-100

  ProjectResult({
    required this.projectName,
    required this.category,
    required this.score,
  });
}

class QuizResult {
  final String subject;
  final int score; // 0-100

  QuizResult({
    required this.subject,
    required this.score,
  });
}

// ==================== SKILL PROCESSOR ====================

class SkillProcessor {
  static List<String> generateSkillsFromPerformance(PerformanceData performance) {
    Set<String> skills = {};

    // Process project results
    for (var project in performance.projects) {
      if (project.score >= 75) {
        skills.add(_mapProjectToSkill(project.category, project.projectName));
      }
    }

    // Process quiz results
    for (var quiz in performance.quizzes) {
      if (quiz.score >= 80) {
        skills.add(_mapQuizToSkill(quiz.subject));
      }
    }

    return skills.toList();
  }

  static String _mapProjectToSkill(String category, String projectName) {
    Map<String, String> categoryToSkill = {
      'Mobile Development': 'Flutter Development',
      'Web Development': 'React Development',
      'Backend': 'Node.js',
      'Database': 'Database Design',
      'AI/ML': 'Machine Learning',
      'Game Development': 'Unity Development',
      'Desktop': 'Desktop Applications',
    };

    if (projectName.toLowerCase().contains('flutter') || 
        projectName.toLowerCase().contains('mobile')) {
      return 'Flutter Development';
    }
    if (projectName.toLowerCase().contains('react') || 
        projectName.toLowerCase().contains('web')) {
      return 'React Development';
    }
    if (projectName.toLowerCase().contains('ai') || 
        projectName.toLowerCase().contains('ml')) {
      return 'Machine Learning';
    }

    return categoryToSkill[category] ?? category;
  }

  static String _mapQuizToSkill(String subject) {
    Map<String, String> subjectToSkill = {
      'Data Structures': 'Data Structures & Algorithms',
      'Algorithms': 'Data Structures & Algorithms',
      'Java Programming': 'Java Development',
      'C++ Programming': 'C++ Development',
      'Python Programming': 'Python Development',
      'Operating Systems': 'System Programming',
      'Database Management': 'Database Design',
      'Computer Networks': 'Network Programming',
      'Software Engineering': 'Software Architecture',
      'Machine Learning': 'Machine Learning',
    };

    return subjectToSkill[subject] ?? subject;
  }
}

// ==================== DUMMY DATA ====================

class SkillMapData {
  static List<Student> generateStudents() {
    final rawData = _getRawPerformanceData();
    return rawData.map((data) {
      final performance = PerformanceData(
        projects: data['projects'] as List<ProjectResult>,
        quizzes: data['quizzes'] as List<QuizResult>,
      );
      
      final skills = SkillProcessor.generateSkillsFromPerformance(performance);
      
      return Student(
        id: data['id'],
        name: data['name'],
        profileImageUrl: data['profileImageUrl'],
        skills: skills,
        performanceData: {
          'projects': performance.projects,
          'quizzes': performance.quizzes,
        },
      );
    }).toList();
  }

  static List<Map<String, dynamic>> _getRawPerformanceData() {
    return [
      {
        'id': '1',
        'name': 'Alex Chen',
        'profileImageUrl': '',
        'projects': [
          ProjectResult(projectName: 'Flutter E-commerce App', category: 'Mobile Development', score: 92),
          ProjectResult(projectName: 'React Dashboard', category: 'Web Development', score: 88),
        ],
        'quizzes': [
          QuizResult(subject: 'Data Structures', score: 95),
          QuizResult(subject: 'Java Programming', score: 87),
        ],
      },
      {
        'id': '2',
        'name': 'Priya Sharma',
        'profileImageUrl': '',
        'projects': [
          ProjectResult(projectName: 'AI Chatbot', category: 'AI/ML', score: 94),
          ProjectResult(projectName: 'Database Optimization', category: 'Database', score: 89),
        ],
        'quizzes': [
          QuizResult(subject: 'Machine Learning', score: 92),
          QuizResult(subject: 'Python Programming', score: 90),
        ],
      },
      {
        'id': '3',
        'name': 'Rahul Patel',
        'profileImageUrl': '',
        'projects': [
          ProjectResult(projectName: 'Node.js API Server', category: 'Backend', score: 91),
          ProjectResult(projectName: 'Unity 3D Game', category: 'Game Development', score: 85),
        ],
        'quizzes': [
          QuizResult(subject: 'Algorithms', score: 88),
          QuizResult(subject: 'C++ Programming', score: 84),
        ],
      },
      {
        'id': '4',
        'name': 'Sarah Johnson',
        'profileImageUrl': '',
        'projects': [
          ProjectResult(projectName: 'React Native App', category: 'Mobile Development', score: 90),
          ProjectResult(projectName: 'Web Portfolio', category: 'Web Development', score: 93),
        ],
        'quizzes': [
          QuizResult(subject: 'Software Engineering', score: 91),
          QuizResult(subject: 'Database Management', score: 86),
        ],
      },
      {
        'id': '5',
        'name': 'Kevin Wu',
        'profileImageUrl': '',
        'projects': [
          ProjectResult(projectName: 'Desktop Calculator', category: 'Desktop', score: 82),
          ProjectResult(projectName: 'Network Monitor', category: 'Backend', score: 87),
        ],
        'quizzes': [
          QuizResult(subject: 'Operating Systems', score: 89),
          QuizResult(subject: 'Computer Networks', score: 85),
        ],
      },
      {
        'id': '6',
        'name': 'Ananya Gupta',
        'profileImageUrl': '',
        'projects': [
          ProjectResult(projectName: 'ML Prediction Model', category: 'AI/ML', score: 96),
          ProjectResult(projectName: 'Data Visualization Tool', category: 'Web Development', score: 88),
        ],
        'quizzes': [
          QuizResult(subject: 'Machine Learning', score: 94),
          QuizResult(subject: 'Python Programming', score: 92),
        ],
      },
      {
        'id': '7',
        'name': 'Michael Brown',
        'profileImageUrl': '',
        'projects': [
          ProjectResult(projectName: 'Flutter Weather App', category: 'Mobile Development', score: 89),
          ProjectResult(projectName: 'Java Spring Boot API', category: 'Backend', score: 91),
        ],
        'quizzes': [
          QuizResult(subject: 'Java Programming', score: 93),
          QuizResult(subject: 'Data Structures', score: 87),
        ],
      },
      {
        'id': '8',
        'name': 'Riya Singh',
        'profileImageUrl': '',
        'projects': [
          ProjectResult(projectName: 'React E-learning Platform', category: 'Web Development', score: 95),
          ProjectResult(projectName: 'MongoDB Integration', category: 'Database', score: 88),
        ],
        'quizzes': [
          QuizResult(subject: 'Database Management', score: 90),
          QuizResult(subject: 'Software Engineering', score: 89),
        ],
      },
    ];
  }
}

// ==================== STATE MANAGEMENT ====================

class SkillMapState {
  final List<Student> allStudents;
  final List<Student> filteredStudents;
  final String searchQuery;
  final String? selectedSkill;
  final bool isLoading;

  SkillMapState({
    required this.allStudents,
    required this.filteredStudents,
    required this.searchQuery,
    this.selectedSkill,
    required this.isLoading,
  });

  SkillMapState copyWith({
    List<Student>? allStudents,
    List<Student>? filteredStudents,
    String? searchQuery,
    String? selectedSkill,
    bool? isLoading,
  }) {
    return SkillMapState(
      allStudents: allStudents ?? this.allStudents,
      filteredStudents: filteredStudents ?? this.filteredStudents,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedSkill: selectedSkill,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class SkillMapNotifier extends StateNotifier<SkillMapState> {
  Timer? _debounceTimer;

  SkillMapNotifier() : super(SkillMapState(
    allStudents: [],
    filteredStudents: [],
    searchQuery: '',
    isLoading: true,
  )) {
    _loadInitialData();
  }

  void _loadInitialData() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate loading
    final students = SkillMapData.generateStudents();
    state = state.copyWith(
      allStudents: students,
      filteredStudents: students,
      isLoading: false,
    );
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query, isLoading: true);
    
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _performSearch(query);
    });
  }

  void _performSearch(String query) {
    List<Student> filtered = state.allStudents;

    if (query.isNotEmpty) {
      filtered = filtered.where((student) {
        final nameMatch = student.name.toLowerCase().contains(query.toLowerCase());
        final skillMatch = student.skills.any((skill) => 
          skill.toLowerCase().contains(query.toLowerCase()));
        return nameMatch || skillMatch;
      }).toList();
    }

    if (state.selectedSkill != null) {
      filtered = filtered.where((student) => 
        student.skills.contains(state.selectedSkill)).toList();
    }

    state = state.copyWith(
      filteredStudents: filtered,
      isLoading: false,
    );
  }

  void selectSkill(String skill) {
    if (state.selectedSkill == skill) {
      // Deselect if same skill is tapped
      state = state.copyWith(selectedSkill: null, isLoading: true);
    } else {
      state = state.copyWith(selectedSkill: skill, isLoading: true);
    }

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 200), () {
      _performSearch(state.searchQuery);
    });
  }

  void clearFilter() {
    state = state.copyWith(selectedSkill: null, isLoading: true);
    _performSearch(state.searchQuery);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}

final skillMapProvider = StateNotifierProvider<SkillMapNotifier, SkillMapState>((ref) {
  return SkillMapNotifier();
});

// ==================== UI COMPONENTS ====================

class SkillMapScreen extends ConsumerStatefulWidget {
  const SkillMapScreen({super.key});

  @override
  ConsumerState<SkillMapScreen> createState() => _SkillMapScreenState();
}

class _SkillMapScreenState extends ConsumerState<SkillMapScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(skillMapProvider);
    final notifier = ref.read(skillMapProvider.notifier);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFf5f7fa),
              Color(0xFFc3cfe2),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with Search
              Container(
                margin: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Title Header
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6A11CB).withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              return Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2 + _pulseController.value * 0.1),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: const Icon(
                                  Icons.explore_rounded,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Skill Explorer',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Discover student talents',
                                style: GoogleFonts.poppins(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Search Bar
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white,
                            Colors.white.withOpacity(0.9),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: notifier.updateSearchQuery,
                        decoration: InputDecoration(
                          hintText: 'Search for skills or names...',
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.grey.shade500,
                            fontSize: 16,
                          ),
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: Colors.grey.shade500,
                            size: 24,
                          ),
                          suffixIcon: state.searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: Icon(
                                    Icons.clear_rounded,
                                    color: Colors.grey.shade500,
                                  ),
                                  onPressed: () {
                                    _searchController.clear();
                                    notifier.updateSearchQuery('');
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                        ),
                        style: GoogleFonts.poppins(fontSize: 16),
                      ),
                    ),

                    // Selected Skill Filter
                    if (state.selectedSkill != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF6A11CB).withOpacity(0.2),
                              const Color(0xFF2575FC).withOpacity(0.2),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFF6A11CB).withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.filter_list_rounded,
                              color: const Color(0xFF6A11CB),
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Filtered by: ${state.selectedSkill}',
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF6A11CB),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: notifier.clearFilter,
                              child: Icon(
                                Icons.close_rounded,
                                color: const Color(0xFF6A11CB),
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Loading Indicator
              if (state.isLoading)
                Container(
                  padding: const EdgeInsets.all(20),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(
                      const Color(0xFF6A11CB).withOpacity(0.8),
                    ),
                    strokeWidth: 3,
                  ),
                ),

              // Student List
              Expanded(
                child: AnimatedOpacity(
                  opacity: state.isLoading ? 0.5 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: state.filteredStudents.isEmpty && !state.isLoading
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: state.filteredStudents.length,
                          itemBuilder: (context, index) {
                            final student = state.filteredStudents[index];
                            return _buildStudentCard(student, notifier);
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStudentCard(Student student, SkillMapNotifier notifier) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 500),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.white, Color(0xFFF8F9FA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Student Header
                Row(
                  children: [
                    // Profile Avatar
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: const Color(0xFF6A11CB).withOpacity(0.2),
                      child: Text(
                        student.name.substring(0, 2).toUpperCase(),
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF6A11CB),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Student Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            student.name,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${student.skills.length} skills',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Performance Score
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.green.withOpacity(0.2),
                            Colors.green.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: Colors.green.shade600,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${_calculateAverageScore(student)}%',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.green.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Skills Section
                Text(
                  'Top Skills:',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: student.skills.take(5).map((skill) {
                    final isSelected = ref.watch(skillMapProvider).selectedSkill == skill;
                    return GestureDetector(
                      onTap: () => notifier.selectSkill(skill),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? const LinearGradient(
                                  colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                                )
                              : LinearGradient(
                                  colors: [
                                    const Color(0xFF6A11CB).withOpacity(0.1),
                                    const Color(0xFF2575FC).withOpacity(0.1),
                                  ],
                                ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? Colors.transparent
                                : const Color(0xFF6A11CB).withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          skill,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: isSelected 
                                ? Colors.white 
                                : const Color(0xFF6A11CB),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search_off_rounded,
              size: 64,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No students found',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  int _calculateAverageScore(Student student) {
    final projects = student.performanceData['projects'] as List<ProjectResult>;
    final quizzes = student.performanceData['quizzes'] as List<QuizResult>;
    
    final projectScores = projects.map((p) => p.score).toList();
    final quizScores = quizzes.map((q) => q.score).toList();
    
    final allScores = [...projectScores, ...quizScores];
    if (allScores.isEmpty) return 0;
    
    return (allScores.reduce((a, b) => a + b) / allScores.length).round();
  }
}

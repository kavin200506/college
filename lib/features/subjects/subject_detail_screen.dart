import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/models/models.dart';
import '../../core/models/subject_models.dart';
import '../../core/data/subject_topics_data.dart';

class SubjectDetailScreen extends ConsumerStatefulWidget {
  final Subject subject;

  const SubjectDetailScreen({super.key, required this.subject});

  @override
  ConsumerState<SubjectDetailScreen> createState() => _SubjectDetailScreenState();
}

class _SubjectDetailScreenState extends ConsumerState<SubjectDetailScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;
  
  List<SubjectTopic> _allTopics = [];
  List<SubjectTopic> _filteredTopics = [];
  TopicFilter _currentFilter = TopicFilter.all;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _loadTopics();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _loadTopics() {
    _allTopics = SubjectTopicsData.getTopicsForSubject(widget.subject.id);
    _applyFilters();
  }

  void _applyFilters() {
    List<SubjectTopic> filtered = _allTopics;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((topic) =>
        topic.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        topic.description.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }

    // Apply status filter
    switch (_currentFilter) {
      case TopicFilter.completed:
        filtered = filtered.where((topic) => 
          topic.studentProgress == StudentProgress.understood
        ).toList();
        break;
      case TopicFilter.pending:
        filtered = filtered.where((topic) => 
          topic.studentProgress == StudentProgress.notStarted
        ).toList();
        break;
      case TopicFilter.inProgress:
        filtered = filtered.where((topic) => 
          topic.studentProgress == StudentProgress.inProgress
        ).toList();
        break;
      case TopicFilter.all:
        break;
    }

    setState(() {
      _filteredTopics = filtered;
    });
  }

  void _updateSearch(String query) {
    setState(() {
      _searchQuery = query;
    });
    _applyFilters();
  }

  void _updateFilter(TopicFilter filter) {
    setState(() {
      _currentFilter = filter;
    });
    _applyFilters();
  }

  double _calculateOverallProgress() {
    if (_allTopics.isEmpty) return 0.0;
    
    double teacherProgress = _allTopics
        .map((t) => t.teacherProgress)
        .reduce((a, b) => a + b) / _allTopics.length;
    
    double studentProgress = _allTopics
        .map((t) => t.studentProgress == StudentProgress.understood ? 1.0 :
                    t.studentProgress == StudentProgress.inProgress ? 0.5 : 0.0)
        .reduce((a, b) => a + b) / _allTopics.length;
    
    return (teacherProgress + studentProgress) / 2;
  }

  @override
  Widget build(BuildContext context) {
    final overallProgress = _calculateOverallProgress();
    final recommendations = SubjectTopicsData.generateRecommendations(_allTopics);

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
          child: CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                expandedHeight: 200,
                floating: false,
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [widget.subject.color, widget.subject.color.withOpacity(0.7)],
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.book,
                                  color: Colors.white,
                                  size: 32,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.subject.name,
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        widget.subject.code,
                                        style: GoogleFonts.poppins(
                                          color: Colors.white70,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Overall Progress
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Overall Progress',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      '${(overallProgress * 100).toInt()}%',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: LinearProgressIndicator(
                                    value: overallProgress,
                                    backgroundColor: Colors.white.withOpacity(0.3),
                                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                                    minHeight: 6,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              // Search and Filter Section
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Search Bar
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: _updateSearch,
                          decoration: InputDecoration(
                            hintText: 'Search topics...',
                            hintStyle: GoogleFonts.poppins(color: Colors.grey.shade500),
                            prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: Icon(Icons.clear, color: Colors.grey.shade500),
                                    onPressed: () {
                                      _searchController.clear();
                                      _updateSearch('');
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Filter Chips
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: TopicFilter.values.map((filter) {
                            final isSelected = _currentFilter == filter;
                            return Container(
                              margin: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                selected: isSelected,
                                label: Text(_getFilterLabel(filter)),
                                onSelected: (_) => _updateFilter(filter),
                                selectedColor: widget.subject.color.withOpacity(0.2),
                                backgroundColor: Colors.white,
                                labelStyle: GoogleFonts.poppins(
                                  color: isSelected ? widget.subject.color : Colors.grey.shade600,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                ),
                                side: BorderSide(
                                  color: isSelected ? widget.subject.color : Colors.grey.shade300,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Topics List
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index < _filteredTopics.length) {
                      return AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.3),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                              parent: _animationController,
                              curve: Interval(
                                (index * 0.1).clamp(0.0, 1.0),
                                ((index * 0.1) + 0.3).clamp(0.0, 1.0),
                                curve: Curves.easeOutBack,
                              ),
                            )),
                            child: FadeTransition(
                              opacity: CurvedAnimation(
                                parent: _animationController,
                                curve: Interval(
                                  (index * 0.1).clamp(0.0, 1.0),
                                  ((index * 0.1) + 0.3).clamp(0.0, 1.0),
                                ),
                              ),
                              child: _TopicCard(
                                topic: _filteredTopics[index],
                                subjectColor: widget.subject.color,
                              ),
                            ),
                          );
                        },
                      );
                    } else if (index == _filteredTopics.length && recommendations.isNotEmpty) {
                      // Recommendations Section
                      return _RecommendationsSection(
                        recommendations: recommendations,
                        subjectColor: widget.subject.color,
                      );
                    }
                    return null;
                  },
                  childCount: _filteredTopics.length + (recommendations.isNotEmpty ? 1 : 0),
                ),
              ),

              // Bottom padding
              const SliverToBoxAdapter(
                child: SizedBox(height: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getFilterLabel(TopicFilter filter) {
    switch (filter) {
      case TopicFilter.all:
        return 'All';
      case TopicFilter.completed:
        return 'Completed';
      case TopicFilter.pending:
        return 'Pending';
      case TopicFilter.inProgress:
        return 'In Progress';
    }
  }
}

// Topic Card Widget
class _TopicCard extends StatelessWidget {
  final SubjectTopic topic;
  final Color subjectColor;

  const _TopicCard({
    required this.topic,
    required this.subjectColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: _getStudentProgressColor().withOpacity(0.2),
          child: Icon(
            _getStudentProgressIcon(),
            color: _getStudentProgressColor(),
            size: 20,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                topic.title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
            ),
            if (topic.isTeacherCompleted)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.green,
                  size: 16,
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              topic.description,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            // Teacher Progress
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Teacher Progress',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  '${(topic.teacherProgress * 100).toInt()}%',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: subjectColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: topic.teacherProgress,
              backgroundColor: subjectColor.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation(subjectColor),
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Student Progress Section
                _buildStudentProgressSection(),
                const SizedBox(height: 16),
                
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Navigate to notes
                        },
                        icon: const Icon(Icons.note, size: 16),
                        label: Text('Notes (${topic.notes.length})'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: subjectColor.withOpacity(0.1),
                          foregroundColor: subjectColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Navigate to quiz
                        },
                        icon: const Icon(Icons.quiz, size: 16),
                        label: Text('Quiz'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange.withOpacity(0.1),
                          foregroundColor: Colors.orange.shade700,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Navigate to discussion
                        },
                        icon: const Icon(Icons.chat_bubble_outline, size: 16),
                        label: Text('Discussion (${topic.discussionCount})'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.withOpacity(0.1),
                          foregroundColor: Colors.blue.shade700,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Show quiz results
                        },
                        icon: const Icon(Icons.analytics, size: 16),
                        label: Text('Stats'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.withOpacity(0.1),
                          foregroundColor: Colors.green.shade700,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                // Quiz Results (if any)
                if (topic.quizResults.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Recent Quiz Results',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...topic.quizResults.map((quiz) => Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                quiz.quizName,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '${quiz.correctAnswers}/${quiz.totalQuestions} correct',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getScoreColor(quiz.score).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${quiz.score.toInt()}%',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _getScoreColor(quiz.score),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )).toList(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentProgressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Understanding',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: StudentProgress.values.map((progress) {
            final isSelected = topic.studentProgress == progress;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  // Update student progress
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? _getProgressColor(progress).withOpacity(0.2)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected 
                          ? _getProgressColor(progress)
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        _getProgressIcon(progress),
                        color: isSelected 
                            ? _getProgressColor(progress)
                            : Colors.grey.shade500,
                        size: 20,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getProgressLabel(progress),
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: isSelected 
                              ? _getProgressColor(progress)
                              : Colors.grey.shade600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Color _getStudentProgressColor() {
    switch (topic.studentProgress) {
      case StudentProgress.notStarted:
        return Colors.grey;
      case StudentProgress.inProgress:
        return Colors.orange;
      case StudentProgress.understood:
        return Colors.green;
    }
  }

  IconData _getStudentProgressIcon() {
    switch (topic.studentProgress) {
      case StudentProgress.notStarted:
        return Icons.radio_button_unchecked;
      case StudentProgress.inProgress:
        return Icons.hourglass_empty;
      case StudentProgress.understood:
        return Icons.check_circle;
    }
  }

  Color _getProgressColor(StudentProgress progress) {
    switch (progress) {
      case StudentProgress.notStarted:
        return Colors.grey;
      case StudentProgress.inProgress:
        return Colors.orange;
      case StudentProgress.understood:
        return Colors.green;
    }
  }

  IconData _getProgressIcon(StudentProgress progress) {
    switch (progress) {
      case StudentProgress.notStarted:
        return Icons.schedule;
      case StudentProgress.inProgress:
        return Icons.hourglass_empty;
      case StudentProgress.understood:
        return Icons.check_circle;
    }
  }

  String _getProgressLabel(StudentProgress progress) {
    switch (progress) {
      case StudentProgress.notStarted:
        return 'Not Started';
      case StudentProgress.inProgress:
        return 'In Progress';
      case StudentProgress.understood:
        return 'Understood';
    }
  }

  Color _getScoreColor(double score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }
}

// Recommendations Section
class _RecommendationsSection extends StatelessWidget {
  final List<SubjectRecommendation> recommendations;
  final Color subjectColor;

  const _RecommendationsSection({
    required this.recommendations,
    required this.subjectColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            subjectColor.withOpacity(0.1),
            Colors.white,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: subjectColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb, color: subjectColor, size: 24),
              const SizedBox(width: 8),
              Text(
                'Recommendations',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...recommendations.map((rec) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Icon(
                  _getRecommendationIcon(rec.type),
                  color: _getRecommendationColor(rec.type),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rec.topicTitle,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      Text(
                        rec.reason,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  IconData _getRecommendationIcon(RecommendationType type) {
    switch (type) {
      case RecommendationType.review:
        return Icons.refresh;
      case RecommendationType.practice:
        return Icons.fitness_center;
      case RecommendationType.focus:
        return Icons.center_focus_strong;
    }
  }

  Color _getRecommendationColor(RecommendationType type) {
    switch (type) {
      case RecommendationType.review:
        return Colors.orange;
      case RecommendationType.practice:
        return Colors.blue;
      case RecommendationType.focus:
        return Colors.red;
    }
  }
}

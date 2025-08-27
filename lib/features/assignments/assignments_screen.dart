import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/dummy_data.dart';
import '../../core/models/models.dart';

class AssignmentsScreen extends StatelessWidget {
  const AssignmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final assignments = DummyData.getAssignments();
    final pending = assignments.where((a) => !a.isCompleted).toList();
    final completed = assignments.where((a) => a.isCompleted).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
                // Header
                Container(
                  margin: const EdgeInsets.all(20),
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
                      const Icon(Icons.assignment_rounded, color: Colors.white, size: 30),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Assignments',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${pending.length} pending, ${completed.length} completed',
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

                // Tab Bar
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TabBar(
                    indicator: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey.shade600,
                    labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    tabs: [
                      Tab(text: 'Pending (${pending.length})'),
                      Tab(text: 'Completed (${completed.length})'),
                    ],
                  ),
                ),

                // Tab Views
                Expanded(
                  child: TabBarView(
                    children: [
                      _AssignmentsList(assignments: pending),
                      _AssignmentsList(assignments: completed),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AssignmentsList extends StatelessWidget {
  final List<Assignment> assignments;

  const _AssignmentsList({required this.assignments});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: assignments.length,
      itemBuilder: (context, index) {
        final assignment = assignments[index];
        return _AssignmentCard(assignment: assignment);
      },
    );
  }
}

class _AssignmentCard extends StatelessWidget {
  final Assignment assignment;

  const _AssignmentCard({required this.assignment});

  @override
  Widget build(BuildContext context) {
    final isOverdue = assignment.isOverdue;
    final daysLeft = assignment.deadline?.difference(DateTime.now()).inDays;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: assignment.isCompleted
          ? [Colors.green.shade50, Colors.white]
          : isOverdue
          ? [Colors.red.shade50, Colors.white]
          : [Colors.white, Colors.blue.shade50],
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: assignment.isCompleted
          ? Colors.green.withOpacity(0.3)
          : isOverdue
          ? Colors.red.withOpacity(0.3)
          : Colors.blue.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getPriorityColor(assignment.priority).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  assignment.subjectName,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: _getPriorityColor(assignment.priority),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              Icon(
                assignment.isCompleted
                ? Icons.check_circle
                : isOverdue
                ? Icons.warning
                : Icons.access_time,
                color: assignment.isCompleted
                ? Colors.green
                : isOverdue
                ? Colors.red
                : Colors.blue,
                size: 20,
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Title
          Text(
            assignment.title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),

          const SizedBox(height: 8),

          // Description
          Text(
            assignment.description,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 12),

          // Footer
          Row(
            children: [
              Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade500),
              const SizedBox(width: 4),
              Text(
                'Assigned: ${_formatDate(assignment.assignedDate)}',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              if (assignment.deadline != null) ...[
                const Spacer(),
                Icon(
                  Icons.schedule,
                  size: 16,
                  color: isOverdue ? Colors.red : Colors.grey.shade500,
                ),
              const SizedBox(width: 4),
              Text(
                isOverdue
                ? 'Overdue!'
              : daysLeft! > 0
              ? '${daysLeft}d left'
              : 'Due today',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: isOverdue ? Colors.red : Colors.grey.shade600,
                fontWeight: isOverdue ? FontWeight.w600 : FontWeight.normal,
              ),
              ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.high:
        return Colors.red;
      case Priority.medium:
        return Colors.orange;
      case Priority.low:
        return Colors.green;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

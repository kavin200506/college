import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/dummy_data.dart';
import '../../core/models/models.dart';

class SubjectsScreen extends StatelessWidget {
  const SubjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final subjects = DummyData.getSubjects();

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
                    const Icon(Icons.book_rounded, color: Colors.white, size: 30),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'My Subjects',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${subjects.length} subjects enrolled',
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

              // Subjects Grid
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75, // ← Changed from 0.85 to 0.75 (taller cards)
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                    ),
                    itemCount: subjects.length,
                    itemBuilder: (context, index) {
                      final subject = subjects[index];
                      return _SubjectCard(subject: subject);
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
}

class _SubjectCard extends StatelessWidget {
  final Subject subject;

  const _SubjectCard({required this.subject});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            subject.color.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: subject.color.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: subject.color.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14), // ← Reduced padding from 16 to 14
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subject Icon & Code
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8), // ← Reduced from 10 to 8
                  decoration: BoxDecoration(
                    color: subject.color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10), // ← Reduced from 12 to 10
                  ),
                  child: Icon(
                    Icons.book,
                    color: subject.color,
                    size: 20, // ← Reduced from 24 to 20
                  ),
                ),
                Text(
                  subject.code,
                  style: GoogleFonts.poppins(
                    color: subject.color,
                    fontSize: 11, // ← Reduced from 12 to 11
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10), // ← Reduced from 12 to 10

            // Subject Name
            Text(
              subject.name,
              style: GoogleFonts.poppins(
                fontSize: 15, // ← Reduced from 16 to 15
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 6), // ← Reduced from 8 to 6

            // Description
            Expanded( // ← Wrap description in Expanded
              child: Text(
                subject.description,
                style: GoogleFonts.poppins(
                  fontSize: 11, // ← Reduced from 12 to 11
                  color: Colors.grey.shade600,
                ),
                maxLines: 3, // ← Increased from 2 to 3 lines
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(height: 8), // ← Fixed spacing instead of Spacer()

            // Progress Bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Progress',
                      style: GoogleFonts.poppins(
                        fontSize: 11, // ← Reduced from 12 to 11
                        color: Colors.grey.shade600,
                      ),
                    ),
                    Text(
                      '${(subject.progress * 100).toInt()}%',
                      style: GoogleFonts.poppins(
                        fontSize: 11, // ← Reduced from 12 to 11
                        fontWeight: FontWeight.w600,
                        color: subject.color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value: subject.progress,
                  backgroundColor: subject.color.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation(subject.color),
                  borderRadius: BorderRadius.circular(8),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

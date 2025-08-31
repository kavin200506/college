import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'features/ai_mentor/ai_mentor_screen.dart';
import 'features/subjects/subjects_screen.dart';
import 'features/assignments/assignments_screen.dart';
import 'features/study_partners/study_partners_screen.dart';
import 'features/skill_map/skill_map_screen.dart';
import 'features/profile/profile_screen.dart';
import 'features/ai_mentor/providers/chat_provider.dart';
import 'features/ai_mentor/data/ai_client.dart';
import 'features/ai_mentor/data/ollama_client.dart';

void main() {
  runApp(
    ProviderScope(
      overrides: [
        aiClientProvider.overrideWithValue(
          OllamaClient(
            baseUrl: 'http://192.168.1.12:11434',
            model: 'llama3.2:1b',  
          ),
        ),
      ],
      child: const CollegeMateApp(),
    ),
  );
}

class CollegeMateApp extends StatelessWidget {
  const CollegeMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CollegeMate - Your Study Companion',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF6A11CB),
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const AIMentorScreen(),
    const SubjectsScreen(),
    const AssignmentsScreen(),
    const StudyPartnersScreen(),
    const SkillMapScreen(),
    const ProfileScreen(),
  ];

  Widget _buildNavItem(IconData icon, int index, String label) {
    final isSelected = _currentIndex == index;

    return Consumer(
      builder: (context, ref, _) {
        bool showBadge = false;
        
        if (index == 0) { // AI Mentor tab
          final chatState = ref.watch(chatProvider);
          final hasUserMessages = chatState.messages.length > 1;
          showBadge = hasUserMessages && !isSelected;
        }

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(icon),
            if (showBadge)
              Positioned(
                right: -6,
                top: -2,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white60,
            selectedLabelStyle: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w400,
            ),
            items: [
              BottomNavigationBarItem(
                icon: _buildNavItem(Icons.psychology_rounded, 0, 'AI Mentor'),
                label: 'AI Mentor',
              ),
              BottomNavigationBarItem(
                icon: _buildNavItem(Icons.book_rounded, 1, 'Subjects'),
                label: 'Subjects',
              ),
              BottomNavigationBarItem(
                icon: _buildNavItem(Icons.assignment_rounded, 2, 'Assignments'),
                label: 'Assignments',
              ),
              BottomNavigationBarItem(
                icon: _buildNavItem(Icons.people_rounded, 3, 'Partners'),
                label: 'Partners',
              ),
              BottomNavigationBarItem(
                icon: _buildNavItem(Icons.explore_rounded, 4, 'Skills'),
                label: 'Skills',
              ),
              BottomNavigationBarItem(
                icon: _buildNavItem(Icons.person_rounded, 5, 'Profile'),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

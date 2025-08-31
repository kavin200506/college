import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/models/study_partner.dart';
import 'data/study_partners_data.dart';

class StudyPartnersScreen extends ConsumerStatefulWidget {
  const StudyPartnersScreen({super.key});

  @override
  ConsumerState<StudyPartnersScreen> createState() => _StudyPartnersScreenState();
}

class _StudyPartnersScreenState extends ConsumerState<StudyPartnersScreen>
    with TickerProviderStateMixin {
  
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  late AnimationController _filterController;
  late AnimationController _requestController;
  
  List<StudyPartner> _filteredPartners = [];
  List<StudyPartner> _allPartners = [];
  Map<String, RequestStatus> _requestStatuses = {};
  
  String _selectedSubjectFilter = 'All Subjects';
  AvailabilityStatus? _selectedAvailabilityFilter;
  bool _showFilters = false;

  final List<String> _subjects = [
    'All Subjects',
    'Computer Science',
    'Mathematics',
    'Physics',
    'Chemistry',
    'Biology',
    'Engineering',
    'Business',
    'Literature',
    'History',
  ];

  @override
  void initState() {
    super.initState();
    
    _filterController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _requestController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _loadStudyPartners();
    _searchController.addListener(_filterPartners);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _filterController.dispose();
    _requestController.dispose();
    super.dispose();
  }

  void _loadStudyPartners() {
    _allPartners = StudyPartnersData.getStudyPartners();
    _filteredPartners = List.from(_allPartners);
  }

  void _filterPartners() {
    final query = _searchController.text.toLowerCase();
    
    setState(() {
      _filteredPartners = _allPartners.where((partner) {
        final matchesSearch = partner.name.toLowerCase().contains(query) ||
                             partner.subject.toLowerCase().contains(query) ||
                             partner.university.toLowerCase().contains(query);
        
        final matchesSubject = _selectedSubjectFilter == 'All Subjects' ||
                              partner.subject == _selectedSubjectFilter;
        
        final matchesAvailability = _selectedAvailabilityFilter == null ||
                                   partner.availability == _selectedAvailabilityFilter;
        
        return matchesSearch && matchesSubject && matchesAvailability;
      }).toList();
    });
  }

  void _toggleFilters() {
    setState(() {
      _showFilters = !_showFilters;
    });
    
    if (_showFilters) {
      _filterController.forward();
    } else {
      _filterController.reverse();
    }
  }

  Future<void> _sendEmail(StudyPartner partner) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: partner.email,
      query: 'subject=Study Partnership Request&body=Hi ${partner.name},\n\nI would like to connect with you for studying ${partner.subject}. Let me know if you\'re interested!\n\nBest regards',
    );
    
    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        _showErrorSnackBar('Could not open email app');
      }
    } catch (e) {
      _showErrorSnackBar('Error opening email: $e');
    }
  }

  Future<void> _makePhoneCall(StudyPartner partner) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: partner.phone);
    
    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        _showErrorSnackBar('Could not open phone app');
      }
    } catch (e) {
      _showErrorSnackBar('Error making call: $e');
    }
  }

  void _sendStudyRequest(StudyPartner partner) async {
    setState(() {
      _requestStatuses[partner.id] = RequestStatus.pending;
    });

    // Add haptic feedback
    HapticFeedback.mediumImpact();
    
    // Animate the request button
    _requestController.forward().then((_) {
      _requestController.reverse();
    });

    // Simulate network request
    await Future.delayed(const Duration(milliseconds: 800));
    
    if (mounted) {
      setState(() {
        _requestStatuses[partner.id] = RequestStatus.sent;
      });
      
      _showSuccessSnackBar('Study request sent to ${partner.name}!');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFf5f7fa), Color(0xFFc3cfe2)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildSearchAndFilter(),
              if (_showFilters) _buildFilterOptions(),
              _buildPartnersList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667eea).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(Icons.people_rounded, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Study Partners',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${_filteredPartners.length} partners available',
                  style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: _toggleFilters,
              icon: AnimatedRotation(
                turns: _showFilters ? 0.5 : 0,
                duration: const Duration(milliseconds: 300),
                child: const Icon(Icons.tune, color: Colors.white, size: 24),
              ),
              tooltip: 'Filters',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search partners by name, subject, or university...',
          hintStyle: GoogleFonts.poppins(
            color: Colors.grey.shade500,
            fontSize: 14,
          ),
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
        style: GoogleFonts.poppins(fontSize: 14),
      ),
    );
  }

  Widget _buildFilterOptions() {
    return AnimatedBuilder(
      animation: _filterController,
      builder: (context, child) {
        return Container(
          height: _filterController.value * 120,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Subject Filter
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.school, color: Colors.grey.shade600, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedSubjectFilter,
                            hint: Text('Select Subject', style: GoogleFonts.poppins()),
                            items: _subjects.map((subject) {
                              return DropdownMenuItem(
                                value: subject,
                                child: Text(
                                  subject,
                                  style: GoogleFonts.poppins(fontSize: 14),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedSubjectFilter = value!;
                              });
                              _filterPartners();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // Availability Filter
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.grey.shade600, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<AvailabilityStatus?>(
                            value: _selectedAvailabilityFilter,
                            hint: Text('Select Availability', style: GoogleFonts.poppins()),
                            items: [
                              DropdownMenuItem<AvailabilityStatus?>(
                                value: null,
                                child: Text(
                                  'All Availability',
                                  style: GoogleFonts.poppins(fontSize: 14),
                                ),
                              ),
                              ...AvailabilityStatus.values.map((status) {
                                return DropdownMenuItem(
                                  value: status,
                                  child: Row(
                                    children: [
                                      Text(status.indicator),
                                      const SizedBox(width: 8),
                                      Text(
                                        status.label,
                                        style: GoogleFonts.poppins(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedAvailabilityFilter = value;
                              });
                              _filterPartners();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPartnersList() {
    return Expanded(
      child: _filteredPartners.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              itemCount: _filteredPartners.length,
              itemBuilder: (context, index) {
                final partner = _filteredPartners[index];
                return _buildPartnerCard(partner, index);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 20),
          Text(
            'No study partners found',
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

  Widget _buildPartnerCard(StudyPartner partner, int index) {
    final requestStatus = _requestStatuses[partner.id] ?? RequestStatus.none;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF667eea),
                      Color(0xFF764ba2),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    partner.name.substring(0, 1).toUpperCase(),
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      partner.name,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(partner.availability.indicator),
                        const SizedBox(width: 6),
                        Text(
                          partner.availability.label,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Rating
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      partner.rating.toString(),
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.amber.shade800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Subject and University Info
          Row(
            children: [
              Expanded(
                child: _buildInfoChip(
                  Icons.school,
                  partner.subject,
                  Colors.blue.shade50,
                  Colors.blue.shade700,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoChip(
                  Icons.location_city,
                  partner.university,
                  Colors.purple.shade50,
                  Colors.purple.shade700,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Bio
          Text(
            partner.bio,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          
          const SizedBox(height: 20),
          
          // Action Buttons
          Row(
            children: [
              // Email Button
              Expanded(
                child: _buildActionButton(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  color: Colors.blue,
                  onPressed: () => _sendEmail(partner),
                ),
              ),
              const SizedBox(width: 12),
              // Call Button
              Expanded(
                child: _buildActionButton(
                  icon: Icons.phone_outlined,
                  label: 'Call',
                  color: Colors.green,
                  onPressed: () => _makePhoneCall(partner),
                ),
              ),
              const SizedBox(width: 12),
              // Study Together Button
              Expanded(
                flex: 2,
                child: _buildStudyRequestButton(partner, requestStatus),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(
      duration: Duration(milliseconds: 400 + (index * 100)),
    ).slideY(
      begin: 0.3,
      duration: Duration(milliseconds: 400 + (index * 100)),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: textColor),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onPressed,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: color, size: 18),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStudyRequestButton(StudyPartner partner, RequestStatus status) {
    Widget buttonContent;
    Color backgroundColor;
    Color textColor;
    
    switch (status) {
      case RequestStatus.none:
        buttonContent = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.people_outline, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              'Study Together',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        );
        backgroundColor = const Color(0xFF667eea);
        textColor = Colors.white;
        break;
        
      case RequestStatus.pending:
        buttonContent = SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        );
        backgroundColor = Colors.grey.shade600;
        textColor = Colors.white;
        break;
        
      case RequestStatus.sent:
        buttonContent = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              'Request Sent',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        );
        backgroundColor = Colors.green.shade600;
        textColor = Colors.white;
        break;
        
      default:
        buttonContent = Container();
        backgroundColor = Colors.grey;
        textColor = Colors.white;
    }
    
    return AnimatedBuilder(
      animation: _requestController,
      builder: (context, child) {
        return Container(
          height: 45,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: status == RequestStatus.sent 
                  ? [Colors.green.shade600, Colors.green.shade700]
                  : [backgroundColor, backgroundColor.withOpacity(0.8)],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: _requestController.value > 0
                ? [
                    BoxShadow(
                      color: backgroundColor.withOpacity(0.4),
                      blurRadius: 8 + (_requestController.value * 4),
                      offset: Offset(0, 2 + (_requestController.value * 2)),
                    ),
                  ]
                : [],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: status == RequestStatus.none 
                  ? () => _sendStudyRequest(partner)
                  : null,
              child: Center(
                child: Transform.scale(
                  scale: 1.0 + (_requestController.value * 0.1),
                  child: buttonContent,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

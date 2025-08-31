class StudyPartner {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String subject;
  final String university;
  final String year;
  final AvailabilityStatus availability;
  final String bio;
  final String profileImage;
  final List<String> interests;
  final double rating;
  final int studyHours;

  StudyPartner({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.subject,
    required this.university,
    required this.year,
    required this.availability,
    required this.bio,
    required this.profileImage,
    required this.interests,
    required this.rating,
    required this.studyHours,
  });
}

enum AvailabilityStatus {
  online('Online', '🟢'),
  busy('Busy', '🔴'),
  availableAfter6PM('Available after 6 PM', '🟡'),
  availableWeekends('Available on Weekends', '🟠'),
  offline('Offline', '⚫');

  const AvailabilityStatus(this.label, this.indicator);
  final String label;
  final String indicator;
}

enum RequestStatus { none, pending, sent, accepted, declined }

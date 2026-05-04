class DoctorModel {
  final String name;
  final String title;
  final String specialty;
  final String bio;
  final double rating;
  final int reviews;
  final String imageUrl; // Placeholder 

  const DoctorModel({
    required this.name,
    required this.title,
    required this.specialty,
    required this.bio,
    required this.rating,
    required this.reviews,
    required this.imageUrl,
  });
}

class PatientModel {
  final String firstName;
  final String email;
  final int activeExercises;
  final int todayMinutes;
  
  // Health Details
  final String bloodType;
  final String height;
  final String weight;
  final String primaryDiagnosis;
  final String emergencyContact;

  const PatientModel({
    required this.firstName,
    required this.email,
    required this.activeExercises,
    required this.todayMinutes,
    this.bloodType = 'A+',
    this.height = '165 cm',
    this.weight = '62 kg',
    this.primaryDiagnosis = 'Right Shoulder Rotator Cuff Tear',
    this.emergencyContact = 'Ahmed (Brother) - 01012345678',
  });

  PatientModel copyWith({
    String? firstName,
    String? email,
    String? bloodType,
    String? height,
    String? weight,
    String? primaryDiagnosis,
    String? emergencyContact,
  }) {
    return PatientModel(
      firstName: firstName ?? this.firstName,
      email: email ?? this.email,
      activeExercises: activeExercises,
      todayMinutes: todayMinutes,
      bloodType: bloodType ?? this.bloodType,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      primaryDiagnosis: primaryDiagnosis ?? this.primaryDiagnosis,
      emergencyContact: emergencyContact ?? this.emergencyContact,
    );
  }
}

class ExerciseModel {
  final String title;
  final int durationMinutes;
  final String difficulty;
  final bool isCompleted;

  const ExerciseModel({
    required this.title,
    required this.durationMinutes,
    required this.difficulty,
    this.isCompleted = false,
  });
}

class HistorySessionModel {
  final int daysAgo;
  final int exercisesCompleted;
  final int durationMinutes;
  final String? aiDoctorNote;

  const HistorySessionModel({
    required this.daysAgo,
    required this.exercisesCompleted,
    required this.durationMinutes,
    this.aiDoctorNote,
  });
}

class MedicalReportModel {
  final String title;
  final int daysAgo;
  final String size;

  const MedicalReportModel({
    required this.title,
    required this.daysAgo,
    required this.size,
  });
}

class ChatMessageModel {
  final String text;
  final bool isMe;

  const ChatMessageModel({
    required this.text,
    required this.isMe,
  });
}

class AppointmentModel {
  final String id;
  final DoctorModel doctor;
  final String dateString;

  const AppointmentModel({
    required this.id,
    required this.doctor,
    required this.dateString,
  });
}

class TimelineEventModel {
  final String title;
  final String description;
  final String dateString;
  final String timeString;
  final bool isCompleted;

  const TimelineEventModel({
    required this.title,
    required this.description,
    required this.dateString,
    required this.timeString,
    this.isCompleted = false,
  });
}

class HomeVisitModel {
  final String providerName;
  final String providerType; // 'Doctor' or 'Nurse'
  final String dateString;
  final String timeString;
  final String reason;
  final String status;

  const HomeVisitModel({
    required this.providerName,
    required this.providerType,
    required this.dateString,
    required this.timeString,
    required this.reason,
    this.status = 'Scheduled',
  });
}


class MockData {
  static PatientModel currentPatient = const PatientModel(
    firstName: 'Mai',
    email: 'mai@gmail.com',
    activeExercises: 5,
    todayMinutes: 18,
  );

  static const primaryDoctor = DoctorModel(
    name: 'Dr. Sara Medhat',
    title: 'Lead Physiotherapist',
    specialty: 'Sports rehabilitation and orthopedic therapy',
    bio: 'With over 10 years of clinical experience in sports rehabilitation and orthopedic physical therapy, Dr. Medhat specializes in helping patients recover optimally using tailored, progressive treatment plans.',
    rating: 4.9,
    reviews: 124,
    imageUrl: '', 
  );

  static List<AppointmentModel> upcomingAppointments = [
    const AppointmentModel(
      id: 'apt_1',
      doctor: primaryDoctor,
      dateString: 'Today @ 2:30 PM',
    ),
  ];

  static List<Map<String, dynamic>> aiGeneratedDoctorDates = [
    {'day': 'Mon', 'date': '13', 'monthYear': 'April 2026', 'times': ['09:00 AM', '12:00 PM', '03:00 PM', '06:00 PM']},
    {'day': 'Tue', 'date': '14', 'monthYear': 'April 2026', 'times': ['12:00 PM', '06:00 PM']},
    {'day': 'Wed', 'date': '15', 'monthYear': 'April 2026', 'times': <String>[]},
    {'day': 'Thu', 'date': '16', 'monthYear': 'April 2026', 'times': ['09:00 AM', '10:30 AM', '12:00 PM', '02:00 PM', '03:30 PM', '06:00 PM']},
    {'day': 'Fri', 'date': '17', 'monthYear': 'April 2026', 'times': ['03:00 PM', '05:00 PM']},
  ];

  static const List<ExerciseModel> exercisesList = [
    ExerciseModel(title: 'Shoulder Rotation', durationMinutes: 5, difficulty: 'Beginner'),
    ExerciseModel(title: 'Resistance Band Pull', durationMinutes: 10, difficulty: 'Intermediate'),
    ExerciseModel(title: 'Overhead Press', durationMinutes: 5, difficulty: 'Advanced'),
  ];

  static List<HistorySessionModel> historyList = [
    const HistorySessionModel(
      daysAgo: 0, 
      exercisesCompleted: 3, 
      durationMinutes: 15,
      aiDoctorNote: "Great job completing your routines today! Your resistance band pull motion has improved significantly since yesterday. Next time, try to hold the tension for an extra 2 seconds at the peak to build additional endurance.",
    ),
    const HistorySessionModel(
      daysAgo: 1, 
      exercisesCompleted: 4, 
      durationMinutes: 30,
      aiDoctorNote: "Solid session. The range of motion on your overhead press is widening. If you feel any sharp pinching, remember to drop the weight down immediately. We'll review your joint stability at your next appointment.",
    ),
    const HistorySessionModel(
      daysAgo: 2, 
      exercisesCompleted: 5, 
      durationMinutes: 45,
      aiDoctorNote: "Excellent foundational work. Pushing through 5 distinct exercises demonstrates excellent adherence to the program. Keep leaning on ice therapy if your rotator cuff feels inflamed tonight.",
    ),
  ];

  static List<HistorySessionModel> upcomingWorkouts = [
    const HistorySessionModel(
      daysAgo: -1, // representing tomorrow
      exercisesCompleted: 4, // meaning '4 planned'
      durationMinutes: 20, // meaning '20 mins expected'
    ),
    const HistorySessionModel(
      daysAgo: -3, // meaning 3 days from now
      exercisesCompleted: 5, 
      durationMinutes: 30,
    ),
  ];

  static List<MedicalReportModel> reportsList = [
    const MedicalReportModel(title: 'Post-Op Shoulder MRI', daysAgo: 3, size: '2.4 MB'),
    const MedicalReportModel(title: 'Therapy Routine (Phase 1)', daysAgo: 10, size: '1.1 MB'),
    const MedicalReportModel(title: 'Discharge Summary', daysAgo: 30, size: '3.5 MB'),
  ];

  static List<ChatMessageModel> chatMessages = [];

  static List<ChatMessageModel> doctorChatMessages = [];

  static List<TimelineEventModel> medicalRecords = [
    const TimelineEventModel(title: "Post-Op Physical Examination", description: "Dr. Sara Medhat checked joint mobility.", dateString: "10 Jun 2025", timeString: "10:00 AM", isCompleted: true), 
    const TimelineEventModel(title: "Initial Consultation", description: "Assessment of shoulder pain and mobility.", dateString: "01 Jun 2025", timeString: "11:30 AM", isCompleted: true),
  ];

  static List<TimelineEventModel> upcomingReminders = [
    const TimelineEventModel(title: "Follow-up Examination", description: "Routine check to assess progress.", dateString: "15 Jul 2025", timeString: "02:00 PM", isCompleted: false),
    const TimelineEventModel(title: "MRI Scan", description: "Radiology department appointment.", dateString: "28 Jul 2025", timeString: "09:00 AM", isCompleted: false),
  ];

  static List<HomeVisitModel> upcomingHomeVisits = [
    const HomeVisitModel(
      providerName: 'Nurse Menna Ibrahim',
      providerType: 'Nurse',
      dateString: 'Tomorrow',
      timeString: '04:00 PM',
      reason: 'Post-op dressing change and mobility check',
    ),
  ];
}

// ─── Doctor-side Models ───────────────────────────────────────────────

class DoctorPatientModel {
  final String id;
  String name;
  final int age;
  final String gender;
  String diagnosis;
  double adherencePercent; // 0.0 – 1.0
  final String lastVisit;
  String nextAppointment;
  String status; // 'Active', 'Discharged', 'Needs Attention'
  final String bloodType;
  final String height;
  final String weight;
  final String emergencyContact;
  final String phone;
  int totalSessions;
  int completedSessions;

  DoctorPatientModel({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.diagnosis,
    required this.adherencePercent,
    required this.lastVisit,
    required this.nextAppointment,
    required this.status,
    this.bloodType = 'A+',
    this.height = '170 cm',
    this.weight = '70 kg',
    this.emergencyContact = 'N/A',
    this.phone = '01012345678',
    this.totalSessions = 12,
    this.completedSessions = 4,
  });
}

class DoctorScheduleSlotModel {
  final String time;
  final String patientName;
  final String sessionType; // 'In-Person', 'Video Call', 'Home Visit'
  final String status; // 'Confirmed', 'Pending', 'Completed', 'Cancelled'
  final String? patientId;

  const DoctorScheduleSlotModel({
    required this.time,
    required this.patientName,
    required this.sessionType,
    required this.status,
    this.patientId,
  });
}

class DoctorNoteModel {
  final String date;
  final String patientName;
  final String content;
  final String type; // 'Progress', 'Assessment', 'Discharge'

  DoctorNoteModel({
    required this.date,
    required this.patientName,
    required this.content,
    required this.type,
  });
}

// ─── Doctor Mock Data ─────────────────────────────────────────────────

class DoctorMockData {
  static const currentDoctor = DoctorModel(
    name: 'Dr. Sara Medhat',
    title: 'Lead Physiotherapist',
    specialty: 'Sports rehabilitation and orthopedic therapy',
    bio: 'With over 10 years of clinical experience in sports rehabilitation and orthopedic physical therapy, Dr. Medhat specializes in helping patients recover optimally using tailored, progressive treatment plans.',
    rating: 4.9,
    reviews: 124,
    imageUrl: '',
  );

  static List<DoctorPatientModel> patientList = [
    DoctorPatientModel(
      id: 'p1',
      name: 'Mai El-Sayed',
      age: 28,
      gender: 'Female',
      diagnosis: 'Right Shoulder Rotator Cuff Tear',
      adherencePercent: 0.87,
      lastVisit: 'Today',
      nextAppointment: 'May 3, 2026',
      status: 'Active',
      bloodType: 'A+',
      height: '165 cm',
      weight: '62 kg',
      emergencyContact: 'Ahmed (Brother) - 01012345678',
      phone: '01098765432',
      totalSessions: 12,
      completedSessions: 7,
    ),
    DoctorPatientModel(
      id: 'p2',
      name: 'Omar Hassan',
      age: 34,
      gender: 'Male',
      diagnosis: 'ACL Reconstruction Recovery',
      adherencePercent: 0.92,
      lastVisit: 'Yesterday',
      nextAppointment: 'May 1, 2026',
      status: 'Active',
      bloodType: 'O+',
      height: '178 cm',
      weight: '82 kg',
      emergencyContact: 'Fatma (Wife) - 01234567890',
      phone: '01112233445',
      totalSessions: 16,
      completedSessions: 11,
    ),
    DoctorPatientModel(
      id: 'p3',
      name: 'Nour Abdallah',
      age: 45,
      gender: 'Female',
      diagnosis: 'Chronic Lower Back Pain',
      adherencePercent: 0.54,
      lastVisit: '3 days ago',
      nextAppointment: 'May 2, 2026',
      status: 'Needs Attention',
      bloodType: 'B+',
      height: '160 cm',
      weight: '75 kg',
      emergencyContact: 'Khaled (Husband) - 01555667788',
      phone: '01066778899',
      totalSessions: 10,
      completedSessions: 3,
    ),
    DoctorPatientModel(
      id: 'p4',
      name: 'Youssef Tarek',
      age: 22,
      gender: 'Male',
      diagnosis: 'Sports Ankle Sprain (Grade II)',
      adherencePercent: 0.78,
      lastVisit: '1 week ago',
      nextAppointment: 'May 5, 2026',
      status: 'Active',
      bloodType: 'AB+',
      height: '182 cm',
      weight: '77 kg',
      emergencyContact: 'Tarek (Father) - 01099887766',
      phone: '01200112233',
      totalSessions: 8,
      completedSessions: 5,
    ),
    DoctorPatientModel(
      id: 'p5',
      name: 'Layla Mostafa',
      age: 60,
      gender: 'Female',
      diagnosis: 'Post Hip Replacement Rehab',
      adherencePercent: 0.95,
      lastVisit: '2 days ago',
      nextAppointment: 'May 4, 2026',
      status: 'Active',
      bloodType: 'A-',
      height: '155 cm',
      weight: '68 kg',
      emergencyContact: 'Sara (Daughter) - 01144556677',
      phone: '01033445566',
      totalSessions: 20,
      completedSessions: 18,
    ),
  ];

  static const List<DoctorScheduleSlotModel> todaySchedule = [
    DoctorScheduleSlotModel(
      time: '09:00 AM',
      patientName: 'Omar Hassan',
      sessionType: 'In-Person',
      status: 'Completed',
      patientId: 'p2',
    ),
    DoctorScheduleSlotModel(
      time: '10:30 AM',
      patientName: 'Layla Mostafa',
      sessionType: 'Video Call',
      status: 'Completed',
      patientId: 'p5',
    ),
    DoctorScheduleSlotModel(
      time: '12:00 PM',
      patientName: 'Nour Abdallah',
      sessionType: 'In-Person',
      status: 'Confirmed',
      patientId: 'p3',
    ),
    DoctorScheduleSlotModel(
      time: '02:00 PM',
      patientName: 'Mai El-Sayed',
      sessionType: 'In-Person',
      status: 'Confirmed',
      patientId: 'p1',
    ),
    DoctorScheduleSlotModel(
      time: '03:30 PM',
      patientName: 'Youssef Tarek',
      sessionType: 'Video Call',
      status: 'Pending',
      patientId: 'p4',
    ),
    DoctorScheduleSlotModel(
      time: '05:00 PM',
      patientName: 'Omar Hassan',
      sessionType: 'Home Visit',
      status: 'Confirmed',
      patientId: 'p2',
    ),
  ];

  static List<DoctorNoteModel> recentNotes = [
    DoctorNoteModel(
      date: 'Today',
      patientName: 'Mai El-Sayed',
      content: 'Range of motion improved to 140° abduction. Resistance band exercises progressing well. Recommended increasing intensity next session.',
      type: 'Progress',
    ),
    DoctorNoteModel(
      date: 'Yesterday',
      patientName: 'Omar Hassan',
      content: 'Knee flexion at 120°. Gait pattern normalizing. Cleared for light jogging protocol starting next week.',
      type: 'Progress',
    ),
    DoctorNoteModel(
      date: '2 days ago',
      patientName: 'Nour Abdallah',
      content: 'Patient reports increased pain after prolonged sitting. Adherence to home exercises has dropped. Discussed importance of consistent exercise routine. Adjusted treatment plan to include more manageable exercises.',
      type: 'Assessment',
    ),
    DoctorNoteModel(
      date: '3 days ago',
      patientName: 'Layla Mostafa',
      content: 'Excellent progress post-hip replacement. Walking independently with minimal support. Planning discharge within 2 sessions.',
      type: 'Progress',
    ),
  ];
}


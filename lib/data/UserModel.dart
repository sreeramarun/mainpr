
class UserModel {
  List<String> attendedEvents;
  String department;
  String dob;
  String email;
  String mentorName;
  String mentorPhone;
  String userName;
  String userPhone;
  String role;
  String vtuNo;
  String year;

  UserModel({
    required this.attendedEvents,
    required this.department,
    required this.dob,
    required this.email,
    required this.mentorName,
    required this.mentorPhone,
    required this.userName,
    required this.userPhone,
    required this.role,
    required this.vtuNo,
    required this.year,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      attendedEvents: List<String>.from(data['attendedEvents'] ?? []),
      department: data['department'] ?? '',
      dob: data['dob'] ?? '',
      email: data['email'] ?? '',
      mentorName: data['mentor_name'] ?? '',
      mentorPhone: data['mentor_phone'] ?? '',
      userName: data['user_name'] ?? '',
      userPhone: data['user_phone'] ?? '',
      role: data['role'] ?? 'USER',
      vtuNo: data['vtu_no'] ?? '',
      year: data['year'] ?? "1",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'attendedEvents': attendedEvents,
      'department': department,
      'dob': dob,
      'email': email,
      'mentor_name': mentorName,
      'mentor_phone': mentorPhone,
      'user_name': userName,
      'user_phone': userPhone,
      'role': role,
      'vtu_no': vtuNo,
      'year': year,
    };
  }
}

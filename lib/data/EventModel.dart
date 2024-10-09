class EventModel {
  final String id;
  String eventName;
  String startDate;
  String endDate;
  String startTime;
  String endTime;
  bool isLimitedStudent;
  int studentLimit;
  String resourcePerson;
  String venue;
  List<String> registered;
  String coordinator;
  String bannerImage;
  String logoImage;

  EventModel({
    required this.id,
    required this.eventName,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.isLimitedStudent,
    required this.studentLimit,
    required this.resourcePerson,
    required this.venue,
    required this.registered,
    required this.coordinator,
    required this.bannerImage,
    required this.logoImage,
  });

  factory EventModel.fromMap(Map<String, dynamic> data, String id) {
    return EventModel(
      id: data['id'],
      eventName: data['eventName'] ?? '',
      startDate: data['startDate'] ?? '',
      endDate: data['endDate'] ?? '',
      startTime: data['startTime'] ?? '',
      endTime: data['endTime'] ?? '',
      isLimitedStudent: data['isLimitedStudent'] ?? false,
      studentLimit: data['studentLimit'] ?? 0,
      resourcePerson: data['resourcePerson'] ?? '',
      venue: data['venue'] ?? '',
      registered: List<String>.from(data['registered'] ?? []),
      coordinator: data['coordinator'] ?? '',
      bannerImage: data['bannerImage'] ?? '',
      logoImage: data['logoImage'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'eventName': eventName,
      'startDate': startDate,
      'endDate': endDate,
      'startTime': startTime,
      'endTime': endTime,
      'isLimitedStudent': isLimitedStudent,
      'studentLimit': studentLimit,
      'resourcePerson': resourcePerson,
      'venue': venue,
      'registered': registered,
      'coordinator': coordinator,
      'bannerImage': bannerImage,
      'logoImage': logoImage,
    };
  }
}

/*

event name
startdate
enddate
starttime
endtime
isLimitedStudent:true
studentLimit:50
Resource Person
Venue
Register[studentVtuNumber]
cordinater



 */
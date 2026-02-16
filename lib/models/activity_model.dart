class ActivityModel {
  final String id;
  final String title;
  final String description;
  final String speakerName;
  final String speakerBio;
  final String location;
  final DateTime startTime;
  final DateTime endTime;
  final String type;

  ActivityModel({
    required this.id,
    required this.title,
    required this.description,
    required this.speakerName,
    required this.speakerBio,
    required this.location,
    required this.startTime,
    required this.endTime,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'speakerName': speakerName,
      'speakerBio': speakerBio,
      'location': location,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'type': type,
    };
  }

  factory ActivityModel.fromMap(Map<String, dynamic> map) {
    return ActivityModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      speakerName: map['speakerName'] ?? '',
      speakerBio: map['speakerBio'] ?? '',
      location: map['location'] ?? '',
      startTime: DateTime.parse(map['startTime']),
      endTime: DateTime.parse(map['endTime']),
      type: map['type'] ?? '',
    );
  }
}
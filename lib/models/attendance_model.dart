class AttendanceModel {
  final String userId;
  final DateTime time;
  final double latitude;
  final double longitude;
  final bool isAccepted;

  AttendanceModel({
    required this.userId,
    required this.time,
    required this.latitude,
    required this.longitude,
    required this.isAccepted,
  });
}
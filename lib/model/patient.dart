class Appointment {
  final String id;
  final String patientId;
  final String doctorId;
  final String doctorName;
  final String patientName;
  final String phoneNumber;
  final String dateTime; // Keep for backward compatibility
  final String status;
  final String description;

  Appointment({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.doctorName,
    required this.patientName,
    required this.phoneNumber,
    required this.dateTime,
    required this.status,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'patientId': patientId,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'patientName': patientName,
      'phoneNumber': phoneNumber,
      'dateTime': dateTime,
      'status': status,
      'description': description,
    };
  }

  factory Appointment.fromMap(Map<String, dynamic> map, String id) {
    return Appointment(
      id: id,
      patientId: map['patientId'] ?? '',
      doctorId: map['doctorId'] ?? '',
      doctorName: map['doctorName'] ?? '',
      patientName: map['patientName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      dateTime: map['dateTime'] ?? '',
      status: map['status'] ?? 'pending',
      description: map['description'] ?? '',
    );
  }
}
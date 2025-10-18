import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/patient.dart';

class AppointmentsRepository {
  final CollectionReference _appointmentsCollection =
  FirebaseFirestore.instance.collection('appointments');

  Future<void> addAppointment(Appointment appointment) async {
    await _appointmentsCollection.doc(appointment.id).set(appointment.toMap());
  }

  Future<void> updateAppointment(Appointment appointment) async {
    await _appointmentsCollection.doc(appointment.id).update(appointment.toMap());
  }

  Future<void> deleteAppointment(String id) async {
    await _appointmentsCollection.doc(id).delete();
  }

  Stream<QuerySnapshot> getAppointmentsForPatient(String patientId) {
    return _appointmentsCollection
        .where('patientId', isEqualTo: patientId)
        .snapshots();
  }

  Stream<QuerySnapshot> getAppointmentsForDoctor(String doctorId) {
    return _appointmentsCollection
        .where('doctorId', isEqualTo: doctorId)
        .snapshots();
  }
}
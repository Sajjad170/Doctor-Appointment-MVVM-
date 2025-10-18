import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/Doctor.dart';

class DoctorsRepository {
  final CollectionReference _doctorsCollection =
  FirebaseFirestore.instance.collection('doctors');

  Future<DocumentReference<Map<String, dynamic>>> addDoctor(Doctor doctor) async {
    final docRef = await _doctorsCollection.add(doctor.toMap()) as DocumentReference<Map<String, dynamic>>;
    await docRef.update({'id': docRef.id});
    return docRef;
  }

  Future<void> updateDoctor(Doctor doctor) async {
    await _doctorsCollection.doc(doctor.id).update(doctor.toMap());
  }

  Future<void> deleteDoctor(String id) async {
    await _doctorsCollection.doc(id).delete();
  }

  Stream<QuerySnapshot> getDoctors() {
    return _doctorsCollection.snapshots();
  }

  Future<Doctor?> getDoctorById(String id) async {
    final doc = await _doctorsCollection.doc(id).get();
    if (doc.exists) {
      return Doctor.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }
}
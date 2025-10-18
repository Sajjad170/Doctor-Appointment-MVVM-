import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../../data/AuthRepository.dart';
import '../../../data/appointments_repository.dart';
import '../../../model/patient.dart'; // Your existing Appointment model

class DoctorAppointmentsViewModel extends GetxController {
  final AuthRepository _authRepository = Get.find();
  final AppointmentsRepository _appointmentsRepository = Get.find();

  RxString doctorId = ''.obs;
  Rx<List<Appointment>> appointments = Rx<List<Appointment>>([]);
  RxBool isLoading = true.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchDoctorIdAndAppointments();
  }

  void _fetchDoctorIdAndAppointments() {
    final currentDoctorId = _authRepository.getLoggedInUser()?.uid ?? '';
    if (currentDoctorId.isEmpty) {
      errorMessage.value = "Please log in to view appointments.";
      isLoading.value = false;
      return;
    }
    doctorId.value = currentDoctorId;
    _listenToAppointments();
  }

  void _listenToAppointments() {
    isLoading.value = true;
    _appointmentsRepository.getAppointmentsForDoctor(doctorId.value).listen(
          (snapshot) {
        // Errors are handled in the onError callback, not on the snapshot directly.
        final fetchedAppointments = <Appointment>[];
        for (var doc in snapshot.docs) {
          final appointmentData = doc.data() as Map<String, dynamic>;
          final appointment = Appointment.fromMap(appointmentData, doc.id);
          fetchedAppointments.add(appointment);
        }
        appointments.value = fetchedAppointments;
        isLoading.value = false;
        errorMessage.value = ''; // Clear any previous errors
      },
      onError: (e) {
        errorMessage.value = "Error streaming appointments: $e";
        isLoading.value = false;
      },
    );
  }

  Future<String?> getDoctorImageUrl(String docId) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance.collection('doctors').doc(docId).get();
      final doctorData = docSnapshot.data();
      return doctorData?['image'] as String?;
    } catch (e) {
      print("Error fetching doctor image: $e");
      return null;
    }
  }

  // Since your Appointment model doesn't have copyWith, we'll manually create new instances
  // for updates.
  Future<void> confirmAppointment(Appointment appointment) async {
    try {
      final updatedAppointment = Appointment(
        id: appointment.id,
        patientId: appointment.patientId,
        doctorId: appointment.doctorId,
        doctorName: appointment.doctorName,
        patientName: appointment.patientName,
        phoneNumber: appointment.phoneNumber,
        dateTime: appointment.dateTime,
        status: "confirmed", // Update the status
        description: appointment.description,
      );
      await _appointmentsRepository.updateAppointment(updatedAppointment);
      Get.snackbar("Success", "Appointment confirmed successfully!");
    } catch (e) {
      Get.snackbar("Error", "Failed to confirm appointment: $e");
    }
  }

  Future<void> updateAppointmentStatus(Appointment appointment, String newStatus) async {
    try {
      final updatedAppointment = Appointment(
        id: appointment.id,
        patientId: appointment.patientId,
        doctorId: appointment.doctorId,
        doctorName: appointment.doctorName,
        patientName: appointment.patientName,
        phoneNumber: appointment.phoneNumber,
        dateTime: appointment.dateTime,
        status: newStatus, // Update with the new status
        description: appointment.description,
      );
      await _appointmentsRepository.updateAppointment(updatedAppointment);
      Get.snackbar("Success", "Appointment updated successfully!");
    } catch (e) {
      Get.snackbar("Error", "Failed to update appointment: $e");
    }
  }

  Future<void> deleteAppointment(String id) async {
    try {
      await _appointmentsRepository.deleteAppointment(id);
      Get.snackbar("Success", "Appointment deleted successfully!");
    } catch (e) {
      Get.snackbar("Error", "Failed to delete appointment: $e");
    }
  }
}
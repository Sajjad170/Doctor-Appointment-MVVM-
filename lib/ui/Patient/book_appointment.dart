import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next/ui/Patient/patient_appointments_page.dart';
import '../../data/AuthRepository.dart';
import '../../data/appointments_repository.dart';
import '../../model/Doctor.dart';
import '../../model/patient.dart';

class BookAppointmentPage extends StatefulWidget {
  final Doctor doctor;

  const BookAppointmentPage({super.key, required this.doctor});

  @override
  _BookAppointmentPageState createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  final TextEditingController patientNameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final AuthRepository authRepository = Get.find();
  final AppointmentsRepository appointmentsRepository = Get.find();

  @override
  void dispose() {
    patientNameController.dispose();
    mobileController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Appointment Booking"),
        backgroundColor: const Color(0xFF2A7A6A),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Enter Patient Details",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: patientNameController,
                decoration: InputDecoration(
                  labelText: "Patient Name *",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: mobileController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Mobile *",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Dr. ${widget.doctor.name}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (patientNameController.text.trim().isEmpty) {
                      Get.snackbar("Error", "Please enter patient name");
                      return;
                    }
                    if (mobileController.text.trim().isEmpty) {
                      Get.snackbar("Error", "Please enter mobile number");
                      return;
                    }

                    final patientId = authRepository.getLoggedInUser()?.uid;
                    if (patientId == null) {
                      Get.snackbar("Error", "Please log in to book an appointment");
                      return;
                    }

                    final appointment = Appointment(
                      id: FirebaseFirestore.instance.collection('appointments').doc().id,
                      patientId: patientId,
                      doctorId: widget.doctor.userId, // Use userId instead of Firestore document ID
                      doctorName: widget.doctor.name,
                      patientName: patientNameController.text,
                      phoneNumber: mobileController.text,
                      dateTime: "", // Set to empty string since we don't need dateTime
                      status: "pending",
                      description: descriptionController.text,
                    );

                    try {
                      await appointmentsRepository.addAppointment(appointment);
                      Get.snackbar("Success", "Appointment booked successfully");
                      Get.off(() => PatientAppointmentsPage());
                    } catch (e) {
                      Get.snackbar("Error", "Failed to book appointment: $e");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2A7A6A),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Book Appointment",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
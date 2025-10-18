import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/AuthRepository.dart';
import '../../data/appointments_repository.dart';
import '../../model/patient.dart';
import 'patient.dart';

class PatientAppointmentsPage extends StatelessWidget {
  final AuthRepository authRepository = Get.find();
  final AppointmentsRepository appointmentsRepository = Get.find();

  PatientAppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final patientId = authRepository.getLoggedInUser()?.uid ?? '';
    if (patientId.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("My Appointments"),
          backgroundColor: const Color(0xFF2A7A6A),
        ),
        body: const Center(child: Text("Please log in to view appointments")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Appointments"),
        backgroundColor: const Color(0xFF2A7A6A),
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: appointmentsRepository.getAppointmentsForPatient(patientId),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final appointments = snapshot.data!.docs;
            if (appointments.isEmpty) {
              return const Center(child: Text("No appointments found"));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final doc = appointments[index];
                final appointmentData = doc.data() as Map<String, dynamic>;
                final appointment = Appointment.fromMap(appointmentData, doc.id);
                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('doctors')
                      .doc(appointment.doctorId)
                      .get(),
                  builder: (context, doctorSnapshot) {
                    if (doctorSnapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox.shrink();
                    }
                    if (doctorSnapshot.hasError || !doctorSnapshot.hasData) {
                      return const Card(
                        child: ListTile(title: Text("Error loading doctor")),
                      );
                    }
                    final doctorData = doctorSnapshot.data!.data() as Map<String, dynamic>?;
                    final imageUrl = doctorData?['image'] as String?;

                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: imageUrl != null && imageUrl.isNotEmpty
                                  ? Image.network(
                                imageUrl,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    _buildImagePlaceholder(),
                              )
                                  : _buildImagePlaceholder(),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Dr. ${appointment.doctorName}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Patient: ${appointment.patientName}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Phone: ${appointment.phoneNumber}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Description: ${appointment.description}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Status: ${appointment.status}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteAppointment(appointment.id),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF2A7A6A),
        unselectedItemColor: Colors.grey,
        currentIndex: 1,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "Appointments",
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Get.off(() => PatientPage());
          }
        },
      ),
    );
  }

  Future<void> _deleteAppointment(String id) async {
    try {
      await appointmentsRepository.deleteAppointment(id);
      Get.snackbar("Success", "Appointment deleted successfully");
    } catch (e) {
      Get.snackbar("Error", "Failed to delete appointment: $e");
    }
  }

  Widget _buildImagePlaceholder() {
    return Container(
      width: 60,
      height: 60,
      color: Colors.grey[200],
      child: const Icon(
        Icons.person_outline,
        color: Colors.grey,
        size: 40,
      ),
    );
  }
}
// lib/ui/Doctor/doctor_appointments_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Make sure this path is correct for your ViewModel
import 'package:next/ui/Doctor/view_models/doctor_appointment_vm.dart';
import '../../model/patient.dart';
import 'DoctorPage.dart'; // Assuming this is the correct path for navigation

// --- Define the Binding for DoctorAppointmentsPage ---
// This binding will put the ViewModel into GetX's dependency manager
class DoctorAppointmentsPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<DoctorAppointmentsViewModel>(DoctorAppointmentsViewModel());
  }
}

// --- DoctorAppointmentsPage StatelessWidget ---
class DoctorAppointmentsPage extends StatelessWidget {
  // Get.find() the ViewModel, as it will be put by the binding when navigating
  final DoctorAppointmentsViewModel viewModel = Get.find<DoctorAppointmentsViewModel>();

  DoctorAppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Appointments"),
        backgroundColor: const Color(0xFF2A7A6A),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (viewModel.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (viewModel.errorMessage.isNotEmpty) {
          return Center(child: Text(viewModel.errorMessage.value));
        }

        if (viewModel.appointments.value.isEmpty) {
          return const Center(child: Text("No appointments found"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: viewModel.appointments.value.length,
          itemBuilder: (context, index) {
            final appointment = viewModel.appointments.value[index];
            return FutureBuilder<String?>(
              future: viewModel.getDoctorImageUrl(appointment.doctorId),
              builder: (context, doctorImageSnapshot) {
                final imageUrl = doctorImageSnapshot.data;

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
                          // --- CORRECTED BRACKET PLACEMENT ---
                          child: imageUrl != null && imageUrl.isNotEmpty
                              ? Image.network(
                            imageUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildImagePlaceholder(),
                          )
                              : _buildImagePlaceholder(), // This is the alternative for ClipRRect's child
                          // --- END CORRECTION ---
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Patient: ${appointment.patientName}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
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
                                style: TextStyle(
                                  fontSize: 16,
                                  color: _getStatusColor(appointment.status),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            if (appointment.status == "pending")
                              IconButton(
                                icon: const Icon(Icons.check_circle,
                                    color: Color(0xFF2A7A6A)),
                                onPressed: () => viewModel.confirmAppointment(appointment),
                              ),
                            IconButton(
                              icon: const Icon(Icons.edit, color: Color(0xFF2A7A6A)),
                              onPressed: () => _showUpdateDialog(context, appointment),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => viewModel.deleteAppointment(appointment.id),
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
      }),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF2A7A6A),
        unselectedItemColor: Colors.grey,
        currentIndex: 1, // Assuming "Appointment" is the current tab
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Doctors",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "Appointment",
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            // Navigate to DoctorPage using named route if defined, or direct if not.
            // If DoctorPage is part of GetPages, prefer named route.
            // If it's a simple widget, direct Get.off() is fine.
            Get.off(() => DoctorPage()); // Assuming DoctorPage doesn't have complex arguments
          }
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "confirmed":
        return Colors.green;
      case "pending":
        return Colors.orange;
      case "cancelled":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showUpdateDialog(BuildContext context, Appointment appointment) {
    String currentStatus = appointment.status;

    Get.dialog(
      AlertDialog(
        title: const Text("Update Appointment"),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButton<String>(
                  value: currentStatus,
                  items: ['pending', 'confirmed', 'cancelled']
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        currentStatus = value;
                      });
                    }
                  },
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              viewModel.updateAppointmentStatus(appointment, currentStatus);
              Get.back();
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
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
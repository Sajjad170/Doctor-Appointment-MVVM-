// lib/ui/Doctor/DoctorPage.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:next/ui/Doctor/view_models/add_doctor_vm.dart';
import 'package:next/ui/Doctor/view_models/doctorpage_vm.dart';
import '../../data/media_repo.dart'; // Ensure this import is correct
import '../../model/Doctor.dart';
import 'add_doctor.dart';
import 'doctor_appointments_page.dart';
class DoctorPageBinding extends Bindings {
  @override
  void dependencies() {
    // IMPORTANT: Register MediaRepository FIRST
    Get.put(MediaRepository());

    // Now register AddDoctorViewModel, which depends on MediaRepository
    Get.put(AddDoctorViewModel());

    // Finally, register DoctorPageViewModel
    Get.put(DoctorPageViewModel());
  }
}

class DoctorPage extends StatelessWidget {
  DoctorPage({super.key});

  final DoctorPageViewModel viewModel = Get.find<DoctorPageViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Doctors"),
        backgroundColor: const Color(0xFF2A7A6A),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.offNamed('/login'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => viewModel.navigateToAddDoctor(),
        backgroundColor: const Color(0xFF2A7A6A),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Obx(() {
        if (viewModel.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (viewModel.errorMessage.isNotEmpty) {
          return Center(child: Text("Error: ${viewModel.errorMessage.value}"));
        }

        if (viewModel.doctors.value.isEmpty) {
          return const Center(child: Text("No doctors found"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: viewModel.doctors.value.length,
          itemBuilder: (context, index) {
            final doctor = viewModel.doctors.value[index];
            return GestureDetector(
              onLongPress: () => viewModel.showDoctorOptions(context, doctor),
              child: Card(
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
                        child: doctor.image != null && doctor.image!.isNotEmpty
                            ? Image.network(
                          doctor.image!,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => _buildImagePlaceholder(),
                        )
                            : _buildImagePlaceholder(),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.person,
                                  color: Color(0xFF2A7A6A),
                                  size: 28,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    doctor.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.category_outlined,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  doctor.category,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF2A7A6A),
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Doctors",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "Appointments",
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            // Stay on DoctorPage
          } else if (index == 1) {
            viewModel.navigateToDoctorAppointments();
          }
        },
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
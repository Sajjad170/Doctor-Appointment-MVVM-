import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next/ui/Patient/viewmodel/patient_page_view_model.dart'; // Import your ViewModel
import 'doctor_details.dart'; // Ensure this import is correct
import 'patient_appointments_page.dart'; // Ensure this import is correct

class PatientPage extends StatelessWidget {
  PatientPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize ViewModel using Get.put to create and register it
    final viewModel = Get.put(PatientPageViewModel());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome"),
        backgroundColor: const Color(0xFF2A7A6A),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: viewModel.updateSearchQuery, // Use ViewModel method
                decoration: InputDecoration(
                  hintText: "Search Doctor",
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF2A7A6A)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Specialists",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              // Use Obx to react to changes in isLoading, errorMessage, and doctors list
              child: Obx(() {
                if (viewModel.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (viewModel.errorMessage.value.isNotEmpty) {
                  return Center(child: Text(viewModel.errorMessage.value));
                }
                if (viewModel.doctors.isEmpty) {
                  return const Center(child: Text("No doctors found."));
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: viewModel.doctors.length, // Use ViewModel's doctors list
                  itemBuilder: (context, index) {
                    final doctor = viewModel.doctors[index];
                    return GestureDetector(
                      onTap: () => viewModel.navigateToDoctorDetails(doctor), // Use ViewModel method
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
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF2A7A6A),
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
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
            // Stay on PatientPage
          } else if (index == 1) {
            viewModel.navigateToAppointments(); // Use ViewModel method
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
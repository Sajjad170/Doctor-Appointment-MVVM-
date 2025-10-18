import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next/ui/Doctor/DoctorPage.dart';
import 'package:next/ui/Doctor/add_doctor.dart';
import 'package:next/ui/Doctor/doctor_appointments_page.dart';
import 'package:next/ui/Patient/book_appointment.dart';
import 'package:next/ui/Patient/doctor_details.dart';
import 'package:next/ui/Patient/patient.dart';
import 'package:next/ui/Patient/patient_appointments_page.dart';
import 'package:next/ui/auth/login.dart';
import 'package:next/ui/auth/signup.dart';
import 'package:next/ui/welcome_screen/welcome_screen.dart';
import 'data/AuthRepository.dart';
import 'data/doctors_repository.dart';
import 'data/appointments_repository.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Get.put(AuthRepository());
  Get.put(DoctorsRepository());
  Get.put(AppointmentsRepository());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2A7A6A)),
        useMaterial3: true,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2A7A6A),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          prefixIconColor: const Color(0xFF2A7A6A),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
      getPages: [
        GetPage(name: "/login", page: () => LoginPage(), binding: LoginBinding()),
        GetPage(name: "/signup", page: () => SignUpPage(), binding: SignUpBinding()),
        GetPage(name: "/patient", page: () => PatientPage()),
        GetPage(name: '/doctor', page: () => DoctorPage(), binding: DoctorPageBinding()),
        GetPage(name: '/addDoctor', page: () => AddDoctor(), binding: AddDoctorBinding()),
        GetPage(
          name: '/doctorAppointments',
          page: () => DoctorAppointmentsPage(),
          binding: DoctorAppointmentsPageBinding(), // Ensure ViewModel is initialized
        ),
        GetPage(name: '/patientAppointments', page: () => PatientAppointmentsPage()),
        GetPage(name: '/doctorDetails', page: () => DoctorDetailsPage(doctor: Get.arguments)),
        GetPage(name: '/bookAppointment', page: () => BookAppointmentPage(doctor: Get.arguments)),
      ],
      debugShowCheckedModeBanner: false,
      home: const OnboardingScreen(),
    );
  }
}
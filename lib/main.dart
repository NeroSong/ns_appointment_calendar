import 'package:flutter/material.dart';
import 'package:ns_appointment_calendar/calendar.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NS Appointment Calendar',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6B4EFF),
          primary: const Color(0xFF6B4EFF),
          secondary: const Color(0xFF00D1FF),
          surface: Colors.white,
          background: const Color(0xFFF8F9FE),
        ),
        useMaterial3: true,
        cardTheme: CardTheme(
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: Scaffold(
        backgroundColor: const Color(0xFFF8F9FE),
        body: const Center(
          child: SingleChildScrollView(
            child: AppointmentCalendar(),
          ),
        ),
      ),
    );
  }
}

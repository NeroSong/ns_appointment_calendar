import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ns_appointment_calendar/calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('zh', 'CN'),
      ],
      title: 'NS Appointment Calendar',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF111111),
          primary: const Color(0xFF111111),
          surface: const Color(0xFFFAFAFA),
          surfaceTint: Colors.transparent,
          background: const Color(0xFFFFFFFF),
          onBackground: const Color(0xFF111111),
          onSurface: const Color(0xFF111111),
          secondary: const Color(0xFF666666),
          outline: const Color(0xFFE5E5E5),
        ),
        useMaterial3: true,
        cardTheme: CardTheme(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(
              color: Color(0xFFE5E5E5),
              width: 1,
            ),
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 40, bottom: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_month,
                        color: Color(0xFF6B4EFF), size: 28),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      '预订与 Sarah 的会议时间',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              AppointmentCalendar(
                name: 'Sarah Johnson',
                title: 'Senior Product Manager',
                avatarImg: const NetworkImage(
                  'https://picsum.photos/200/200',
                  scale: 1,
                ),
                description: '10年产品经验，专注于AI与数据产品。擅长产品战略规划与团队管理。'
                    '超过30分钟的会不要拉我，谢谢。',
                disabledDays: {
                  DateTime(2024, 12, 25),
                  DateTime(2025, 1, 1),
                },
                timeSlots: const [
                  '10:00 - 11:00',
                  '11:00 - 12:00',
                  '14:00 - 15:00',
                  '15:00 - 16:00',
                ],
                onSubmit: (date, timeSlot, note) {
                  print('Date: $date, Time Slot: $timeSlot, Note: $note');
                },
              ),
              const SizedBox(height: 20),
              Text(
                'Made by Nero Song with Flutter',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

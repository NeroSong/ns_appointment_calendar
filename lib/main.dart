import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ns_appointment_calendar/calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('zh', 'CN');
  bool _isDarkMode = false;

  void _changeLanguage(String? languageCode) {
    if (languageCode == null) return;
    setState(() {
      _locale = Locale(
        languageCode.split('_')[0],
        languageCode.split('_')[1],
      );
    });
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

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
      locale: _locale,
      title: 'NS Appointment Calendar',
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
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
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: const Color(0xFF111111),
          primary: Colors.white,
          surface: const Color(0xFF1A1A1A),
          surfaceTint: Colors.transparent,
          background: const Color(0xFF111111),
          onBackground: Colors.white,
          onSurface: Colors.white,
          secondary: const Color(0xFF999999),
          outline: const Color(0xFF333333),
        ),
        useMaterial3: true,
        cardTheme: CardTheme(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(
              color: Color(0xFF333333),
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
              Padding(
                padding: EdgeInsets.only(top: 40, bottom: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_month, size: 28),
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      _locale.languageCode == 'zh'
                          ? '预订与 Sarah 的会议时间'
                          : 'Book a meeting with Sarah',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 12),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: '${_locale.languageCode}_${_locale.countryCode}',
                        onChanged: _changeLanguage,
                        items: <String>['en_US', 'zh_CN']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value == 'en_US' ? 'English' : '中文',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          );
                        }).toList(),
                        icon: Icon(
                          Icons.expand_more,
                          size: 18,
                        ),
                        isDense: true,
                        borderRadius: BorderRadius.circular(6),
                        elevation: 4,
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      onPressed: _toggleTheme,
                      icon: Icon(
                        _isDarkMode ? Icons.light_mode : Icons.dark_mode,
                        size: 16,
                      ),
                      style: IconButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.outline,
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              AppointmentCalendar(
                name: _locale.languageCode == 'zh'
                    ? 'Sarah Johnson'
                    : 'Sarah Johnson',
                title: _locale.languageCode == 'zh'
                    ? '高级产品经理'
                    : 'Senior Product Manager',
                avatarImg: const NetworkImage(
                  'https://picsum.photos/200/200',
                  scale: 1,
                ),
                description: _locale.languageCode == 'zh'
                    ? '10年产品经验，专注于AI与数据产品。擅长产品战略规划与团队管理。超过30分钟的会不要拉我，谢谢。'
                    : '10 years of product experience, focusing on AI and data products. Good at product strategy planning and team management. Please do not pull me for more than 30 minutes.',
                disabledDays: {
                  DateTime(2024, 12, 25), // 圣诞节
                  DateTime(2025, 1, 1), // 元旦
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

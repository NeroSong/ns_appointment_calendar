import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ns_appointment_calendar/calendar.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en', 'US');
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
      debugShowCheckedModeBanner: false,
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
          onSurface: const Color(0xFF111111),
          secondary: const Color(0xFF666666),
          outline: const Color(0xFFE5E5E5),
        ),
        useMaterial3: true,
        cardTheme: CardTheme(
          elevation: 0,
          color: Colors.white,
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
          onSurface: Colors.white,
          secondary: const Color(0xFF999999),
          outline: const Color(0xFF333333),
        ),
        useMaterial3: true,
        cardTheme: CardTheme(
          elevation: 0,
          color: const Color(0xFF2c2c2c),
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
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 40, bottom: 24),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      runSpacing: 12,
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
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value:
                                    '${_locale.languageCode}_${_locale.countryCode}',
                                onChanged: _changeLanguage,
                                items: <String>[
                                  'en_US',
                                  'zh_CN'
                                ].map<DropdownMenuItem<String>>((String value) {
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
                                _isDarkMode
                                    ? Icons.light_mode
                                    : Icons.dark_mode,
                                size: 16,
                              ),
                              style: IconButton.styleFrom(
                                fixedSize: const Size(32, 32),
                                minimumSize: const Size(32, 32),
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  side: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.outline,
                                    width: 1,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Builder(builder: (_) {
                    return AppointmentCalendar(
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
                        ScaffoldMessenger.of(_).showSnackBar(
                          SnackBar(
                            showCloseIcon: true,
                            duration: const Duration(seconds: 2),
                            content: Text(
                              'Date: ${date.year}-${date.month}-${date.day}, Time Slot: $timeSlot, Note: $note',
                            ),
                          ),
                        );
                      },
                    );
                  }),
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
            Positioned(
              top: 20,
              right: -35,
              child: Transform.rotate(
                angle: 45 * 3.14 / 180,
                child: InkWell(
                  onTap: () async {
                    final url = Uri.parse(
                        'https://github.com/NeroSong/ns_appointment_calendar');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    }
                  },
                  child: Container(
                    width: 150,
                    height: 30,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: const [
                          Color(0xFF4A4A4A),
                          Color(0xFF2C2C2C),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'GitHub',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

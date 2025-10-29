import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_fonts/google_fonts.dart';
import 'today_sunnah_page.dart';
import 'edit_profile_page.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  // Tanggal yang dipilih, default ke 12 (untuk menyoroti Maulid Nabi)
  int selectedHijriDay = 12;

  // List untuk menyimpan semua event dari events.json
  List<Map<String, dynamic>> allEvents = [];

  // Mapping Hari Hijriah ke Tanggal Masehi (sementara/hardcoded)
  final Map<int, String> masehiDates = {
    1: '25',
    2: '26',
    3: '27',
    4: '28',
    5: '29',
    6: '30',
    7: '31',
    8: '1',
    9: '2',
    10: '3',
    11: '4',
    12: '5',
    13: '6',
    14: '7',
    15: '8',
    16: '9',
    17: '10',
    18: '11',
    19: '12',
    20: '13',
    21: '14',
    22: '15',
    23: '16',
    24: '17',
    25: '18',
    26: '19',
    27: '20',
    28: '21',
    29: '22',
  };

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  /// Fungsi untuk memuat data event dari assets/events.json
  Future<void> _loadEvents() async {
    try {
      // Path sudah disesuaikan ke 'lib/assets/data/events.json'
      final String jsonString = await rootBundle.loadString(
        'lib/assets/data/events.json',
      );
      final Map<String, dynamic> jsonData = jsonDecode(jsonString);
      setState(() {
        allEvents = List<Map<String, dynamic>>.from(jsonData['events']);
      });
    } catch (e) {
      debugPrint('Error loading events: $e');
      setState(() {
        allEvents = [];
      });
    }
  }

  /// Fungsi helper untuk mendapatkan event berdasarkan hari Hijriah yang dipilih
  List<Map<String, dynamic>> _getEventsForSelectedDay() {
    return allEvents.where((e) {
      final int eventDay = (e['hijri_day'] is int
          ? e['hijri_day']
          : int.tryParse(e['hijri_day'].toString()) ?? -1);
      return eventDay == selectedHijriDay;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBDEDE),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox(
              height: constraints.maxHeight,
              child: Stack(
                children: [
                  // Scroll utama
                  SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 160),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        Text(
                          'Rabiul Awal 1447 H',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Agustus – September 2025',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children:
                                [
                                      'MON',
                                      'TUE',
                                      'WED',
                                      'THU',
                                      'FRI',
                                      'SAT',
                                      'SUN',
                                    ]
                                    .map(
                                      (day) => Text(
                                        day,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    )
                                    .toList(),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Kalender
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 35,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 7,
                                  mainAxisSpacing: 8,
                                  crossAxisSpacing: 8,
                                ),
                            itemBuilder: (context, index) {
                              final hijriDay = index + 1;
                              if (hijriDay > 29) return const SizedBox();

                              final masehiDate = masehiDates[hijriDay] ?? '-';
                              final bool isSelected =
                                  hijriDay == selectedHijriDay;

                              final bool hasEvent = allEvents.any((event) {
                                final int eventDay = (event['hijri_day'] is int
                                    ? event['hijri_day']
                                    : int.tryParse(
                                            event['hijri_day'].toString(),
                                          ) ??
                                          -1);
                                return eventDay == hijriDay;
                              });

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedHijriDay = hijriDay;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.pink.shade100
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '$hijriDay',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: hasEvent
                                              ? Colors.pink
                                              : Colors.black87,
                                        ),
                                      ),

                                      Text(
                                        masehiDate,
                                        style: GoogleFonts.poppins(
                                          fontSize: 10,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Bottom sheet
                  DraggableScrollableSheet(
                    initialChildSize: 0.25,
                    minChildSize: 0.25,
                    maxChildSize: 0.8,
                    builder: (context, scrollController) {
                      final events = _getEventsForSelectedDay();
                      return Container(
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 216, 178, 178),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                        ),
                        child: ListView(
                          controller: scrollController,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 16.0,
                          ),
                          children: [
                            Center(
                              child: Container(
                                width: 40,
                                height: 4,
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white70,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                            Text(
                              'Event pada $selectedHijriDay Rabiul Awal 1447 H',
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 20),
                            if (events.isEmpty)
                              Text(
                                'Tidak ada acara pada hari ini.',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              )
                            else
                              ...events.map(
                                (e) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                  ),
                                  child: _buildEventCard(
                                    title: e['title'] ?? 'No Title',
                                    date: e['date'] ?? 'No Date',
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),

      // Floating Action Button

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.pinkAccent,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) return;

          if (index == 1) {
            final masehiDay = int.parse(masehiDates[selectedHijriDay]!);
            final masehiMonth = masehiDay >= 25
                ? 8
                : 9; // Agustus–September 2025
            final masehiYear = 2025;

            final hijriDate = {
              "day": selectedHijriDay,
              "month": "Rabiul Awal",
              "year": 1447,
            };

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TodaysSunnahPage(
                  today: DateTime(masehiYear, masehiMonth, masehiDay),
                  hijriDate: hijriDate,
                ),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EditProfilePage()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }

  /// Widget untuk menampilkan Event Card
  Widget _buildEventCard({required String title, required String date}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.event, color: Colors.pink, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

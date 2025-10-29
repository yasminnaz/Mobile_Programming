import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'calendar_page.dart';
import 'edit_profile_page.dart';

class TodaysSunnahPage extends StatefulWidget {
  final DateTime today;
  final Map<String, dynamic> hijriDate;

  const TodaysSunnahPage({
    super.key,
    required this.today,
    required this.hijriDate,
  });

  @override
  State<TodaysSunnahPage> createState() => _TodaysSunnahPageState();
}

class _TodaysSunnahPageState extends State<TodaysSunnahPage> {
  List<Map<String, dynamic>> sunnahHarian = [];
  List<Map<String, dynamic>> sunnahBulanan = [];

  @override
  void initState() {
    super.initState();
    _loadSunnahData();
  }

  Future<void> _loadSunnahData() async {
    try {
      final harianData = await rootBundle.loadString(
        'lib/assets/data/sunnah_harian.json',
      );
      final bulananData = await rootBundle.loadString(
        'lib/assets/data/sunnah_bulanan.json',
      );

      final harianJson = jsonDecode(harianData);
      final bulananJson = jsonDecode(bulananData);

      setState(() {
        sunnahHarian = List<Map<String, dynamic>>.from(
          harianJson['sunnah_harian'],
        );
        sunnahBulanan = List<Map<String, dynamic>>.from(
          bulananJson['sunnah_bulanan'],
        );
      });
    } catch (e) {
      debugPrint('Error loading sunnah data: $e');
    }
  }

  List<Map<String, dynamic>> getTodaySunnah() {
    final dayName = toBeginningOfSentenceCase(
      DateFormat('EEEE', 'id_ID').format(widget.today),
    );
    final hijriDay = widget.hijriDate['day'];

    final daily = sunnahHarian
        .where(
          (s) => s['day'].toString().toLowerCase() == dayName!.toLowerCase(),
        )
        .toList();

    final monthly = sunnahBulanan
        .where((s) => s['hijri_day'] == hijriDay)
        .toList();

    return [...daily, ...monthly];
  }

  @override
  Widget build(BuildContext context) {
    final masehi = DateFormat(
      'EEEE, dd MMMM yyyy',
      'id_ID',
    ).format(widget.today);
    final todaySunnah = getTodaySunnah();

    return Scaffold(
      backgroundColor: const Color(0xFFFBDEDE),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            Text(
              "Today's Sunnah",
              style: GoogleFonts.playfairDisplay(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

            Text(
              "${widget.hijriDate['day']} ${widget.hijriDate['month']} ${widget.hijriDate['year']} H",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.pinkAccent,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              masehi,
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
            ),
            const SizedBox(height: 30),

            Expanded(
              child: todaySunnah.isEmpty
                  ? Center(
                      child: Text(
                        "Tidak ada sunnah khusus hari ini.",
                        style: GoogleFonts.poppins(color: Colors.grey[700]),
                      ),
                    )
                  : ListView.builder(
                      itemCount: todaySunnah.length,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemBuilder: (context, index) {
                        final sunnah = todaySunnah[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildSunnahCard(
                            title: sunnah['title'],
                            icon: _getIconFor(sunnah['icon']),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.pinkAccent,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const CalendarPage()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
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

  Widget _buildSunnahCard({required String title, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.pinkAccent),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconFor(String? name) {
    switch (name) {
      case 'fasting':
        return Icons.water_drop_rounded;
      case 'book':
        return Icons.menu_book_rounded;
      case 'pray':
        return Icons.self_improvement_rounded;
      case 'charity':
        return Icons.volunteer_activism_rounded;
      case 'dua':
        return Icons.favorite_rounded;
      default:
        return Icons.star_border_rounded;
    }
  }
}

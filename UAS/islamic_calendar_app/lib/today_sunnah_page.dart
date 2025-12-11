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
  final List<String> events;

  const TodaysSunnahPage({
    super.key,
    required this.today,
    required this.hijriDate,
    required this.events,
  });

  @override
  State<TodaysSunnahPage> createState() => _TodaysSunnahPageState();
}

class _TodaysSunnahPageState extends State<TodaysSunnahPage> {
  List<Map<String, dynamic>> sunnahHarian = [];
  List<Map<String, dynamic>> sunnahBulanan = [];
  bool isLoadingData = true;

  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    Intl.defaultLocale = 'id_ID';
    _loadSunnahData();
  }

  // MENGEMBALIKAN FUNGSI PEMUATAN JSON LOKAL
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
        isLoadingData = false;
      });
    } catch (e) {
      debugPrint('Error loading sunnah data: $e');
      setState(() => isLoadingData = false);
    }
  }

  /// Fungsi untuk mendapatkan sunnah berdasarkan hari dan tanggal Hijriah (dari JSON)
  List<Map<String, dynamic>> getJsonSunnah() {
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

  /// Fungsi untuk menggabungkan Event API + JSON Sunnah + Filter Pencarian
  List<Map<String, dynamic>> getFilteredSunnah() {
    // 1. Ambil Sunnah dari JSON Lokal
    final jsonSunnah = getJsonSunnah();

    // 2. Ambil Event dari API (Liburan/Hari Besar)
    final apiEvents = widget.events;

    // 3. Konversi API Events menjadi format Map untuk digabungkan
    final apiSunnah = apiEvents
        .map((eventTitle) => {'title': eventTitle, 'icon': 'star'})
        .toList();

    // 4. Gabungkan semua daftar
    final allSunnah = [...apiSunnah, ...jsonSunnah];

    // 5. Lakukan Filter berdasarkan Query
    if (_searchQuery.isEmpty) {
      return allSunnah;
    }

    final query = _searchQuery.toLowerCase();

    return allSunnah.where((sunnah) {
      final title = sunnah['title']?.toLowerCase() ?? '';
      return title.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final masehi = DateFormat(
      'EEEE, dd MMMM yyyy',
      'id_ID',
    ).format(widget.today);

    final allSunnah = getFilteredSunnah();

    return Scaffold(
      backgroundColor: const Color(0xFFFBDEDE),
      body: isLoadingData
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
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
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // FITUR PENCARIAN
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 10,
                    ),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: "Cari Sunnah atau Hari Penting...",
                        labelStyle: GoogleFonts.poppins(fontSize: 14),
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.pink.shade100),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Colors.pinkAccent,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // ------------------------------------
                  Expanded(
                    child: allSunnah.isEmpty
                        ? Center(
                            child: Text(
                              _searchQuery.isEmpty
                                  ? "Tidak ada sunnah atau hari penting tercatat hari ini."
                                  : "Tidak ada hasil ditemukan untuk '${_searchQuery}'.",
                              style: GoogleFonts.poppins(
                                color: Colors.grey[700],
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: allSunnah.length,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 10,
                            ),
                            itemBuilder: (context, index) {
                              final sunnah = allSunnah[index];
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
      case 'star': // Untuk event dari API
        return Icons.star_border_rounded;
      default:
        return Icons.star_border_rounded;
    }
  }
}

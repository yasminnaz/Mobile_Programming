import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'today_sunnah_page.dart';
import 'edit_profile_page.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  int selectedHijriDay = 1;
  int startDayOffset = 0;

  String hijriMonthName = "";
  int hijriMonth = 1;
  int hijriYear = 1447;

  List<Map<String, dynamic>> hijriMonthDays = [];
  bool isLoading = true;

  final Map<String, int> monthNameToInt = {
    "Muharram": 1,
    "Safar": 2,
    "Rabi al-Awwal": 3,
    "Rabi al-Thani": 4,
    "Jumada al-Awwal": 5,
    "Jumada al-Thani": 6,
    "Rajab": 7,
    "Sha‘ban": 8,
    "Ramadan": 9,
    "Shawwal": 10,
    "Dhu al-Qi'dah": 11,
    "Dhu al-Hijjah": 12,
  };

  @override
  void initState() {
    super.initState();
    _loadInitialHijri();
  }

  Future<void> _changeMonth(int change) async {
    setState(() {
      isLoading = true;
    });

    int newMonth = hijriMonth + change;
    int newYear = hijriYear;

    if (newMonth > 12) {
      newMonth = 1;
      newYear++;
    } else if (newMonth < 1) {
      newMonth = 12;
      newYear--;
    }

    String newMonthName = monthNameToInt.entries
        .firstWhere(
          (entry) => entry.value == newMonth,
          orElse: () => const MapEntry("", 6),
        )
        .key;

    hijriMonth = newMonth;
    hijriYear = newYear;
    hijriMonthName = newMonthName;
    selectedHijriDay = 1;

    await _loadHijriCalendar();
  }

  /// 1. Mengambil tanggal Hijriah hari ini (gToH)
  Future<void> _loadInitialHijri() async {
    setState(() => isLoading = true);

    try {
      final now = DateTime.now();
      final dateString =
          "${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}";

      final urlToday = Uri.parse(
        "https://api.aladhan.com/v1/gToH?date=$dateString",
      );
      final resToday = await http.get(urlToday);

      if (resToday.statusCode == 200) {
        final String rawBody = utf8.decode(resToday.bodyBytes);
        final String cleanedBody = rawBody.trim();

        if (cleanedBody.isEmpty) {
          throw Exception("GToH response body is empty.");
        }

        final data = jsonDecode(cleanedBody);
        final hijri = data["data"]["hijri"];

        String enMonthName = hijri["month"]["en"].toString();

        hijriMonth =
            monthNameToInt[enMonthName] ??
            int.tryParse(hijri["month"]["number"].toString().trim()) ??
            6;

        hijriYear = int.tryParse(hijri["year"].toString().trim()) ?? 1447;
        hijriMonthName = enMonthName;
        selectedHijriDay = int.tryParse(hijri["day"].toString().trim()) ?? 11;

        await _loadHijriCalendar();
      } else {
        await _loadFallbackCalendar();
      }
    } catch (e) {
      await _loadFallbackCalendar();
    }
  }

  Future<void> _loadFallbackCalendar() async {
    hijriMonth = 6;
    hijriYear = 1447;
    hijriMonthName = "Jumada al-Thani";
    selectedHijriDay = 20;

    await _loadHijriCalendar();
  }

  /// 2. Memuat seluruh tanggal untuk bulan Hijriah yang sudah didapat (hToGCalendar)
  Future<void> _loadHijriCalendar() async {
    try {
      final url = Uri.parse(
        "https://api.aladhan.com/v1/hToGCalendar/$hijriMonth/$hijriYear",
      );
      final res = await http.get(url);

      if (res.statusCode == 200) {
        final String rawBody = utf8.decode(res.bodyBytes);
        final String cleanedBody = rawBody.trim();

        if (cleanedBody.isEmpty) {
          throw Exception("HToG response body is empty.");
        }

        final arr = jsonDecode(cleanedBody)["data"] as List;

        final newDays = arr.map((item) {
          final hijriDayStr = item["hijri"]["day"].toString().trim();

          final List<dynamic> holidays =
              item["hijri"]["holidays"] as List<dynamic>? ?? [];
          final List<String> events = holidays
              .map((h) => h.toString())
              .toList();

          final gregDateRaw = item["gregorian"]["date"].toString().trim();
          final gregDate = _parseGregorianDateSafe(gregDateRaw);

          final gregIso =
              "${gregDate.year.toString().padLeft(4, '0')}-${gregDate.month.toString().padLeft(2, '0')}-${gregDate.day.toString().padLeft(2, '0')}";

          return {
            "hijri_day": int.tryParse(hijriDayStr) ?? 0,
            "masehi": gregIso,
            "events": events,
            "masehi_raw": gregDateRaw,
          };
        }).toList();

        final firstDayIso = newDays.first["masehi"] as String;
        final firstDayDate = DateTime.parse(firstDayIso);
        final calculatedOffset = firstDayDate.weekday - 1;

        final List<Map<String, dynamic>> finalDays = newDays
            .map((item) => item as Map<String, dynamic>)
            .toList();

        setState(() {
          hijriMonthDays = finalDays;
          startDayOffset = calculatedOffset;
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  /// Parse tanggal gregorian yang mungkin format "DD-MM-YYYY" atau "YYYY-MM-DD"
  DateTime _parseGregorianDateSafe(String s) {
    final str = s.trim();
    final parts = str.split(RegExp(r'[-\/\s]'));

    try {
      if (parts.length == 3) {
        if (parts[0].length == 4 &&
            parts[1].length <= 2 &&
            parts[2].length <= 2) {
          final y = int.parse(parts[0]);
          final m = int.parse(parts[1]);
          final d = int.parse(parts[2]);
          return DateTime(y, m, d);
        } else if (parts[2].length == 4) {
          final d = int.parse(parts[0]);
          final m = int.parse(parts[1]);
          final y = int.parse(parts[2]);
          return DateTime(y, m, d);
        }
      }
      return DateTime.parse(str);
    } catch (e) {
      return DateTime.now();
    }
  }

  /// Menerjemahkan nama bulan Hijriah
  String _translateHijriMonth(String enMonthName) {
    const Map<String, String> translation = {
      "Muharram": "Muharram",
      "Safar": "Safar",
      "Rabi al-Awwal": "Rabiul Awal",
      "Rabi al-Thani": "Rabiul Akhir",
      "Jumada al-Awwal": "Jumadil Awal",
      "Jumada al-Thani": "Jumadil Akhir",
      "Rajab": "Rajab",
      "Sha‘ban": "Sya'ban",
      "Ramadan": "Ramadhan",
      "Shawwal": "Syawal",
      "Dhu al-Qi'dah": "Dzulqa'dah",
      "Dhu al-Hijjah": "Dzulhijjah",
    };

    final String cleanedName;
    if (enMonthName.toLowerCase().contains("sha")) {
      cleanedName = "Sha‘ban";
    } else if (enMonthName.toLowerCase().contains("dhul-qi")) {
      cleanedName = "Dhu al-Qi'dah";
    } else if (enMonthName.toLowerCase().contains("dhul-hi")) {
      cleanedName = "Dhu al-Hijjah";
    } else {
      cleanedName = enMonthName.trim();
    }
    return translation[cleanedName] ?? enMonthName;
  }

  void _showEventBottomSheet(Map<String, dynamic> selectedDayData) {
    final List<String> events = selectedDayData["events"] as List<String>;
    final int hDay = selectedDayData["hijri_day"] as int;
    final String masehiIso = selectedDayData["masehi"] as String;
    final DateTime masehiDate = DateTime.parse(masehiIso);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.25,
          maxChildSize: 0.85,
          expand: false,
          builder: (BuildContext context, ScrollController scrollController) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: ListView(
                controller: scrollController,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    "📅 Tanggal Terpilih",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "$hDay ${_translateHijriMonth(hijriMonthName)} $hijriYear H",
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${_monthName(masehiDate.month)} ${masehiDate.day}, ${masehiDate.year} M",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const Divider(height: 30),

                  Text(
                    "⭐ Event/Hari Penting",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),

                  if (events.isEmpty)
                    Text("Tidak ada event penting tercatat untuk tanggal ini."),

                  ...events
                      .map(
                        (event) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.check_circle_outline,
                                size: 18,
                                color: Colors.pinkAccent,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  event,
                                  style: GoogleFonts.poppins(fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),

                  const SizedBox(height: 30),

                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _goToTodaySunnah(context, selectedDayData);
                    },
                    icon: const Icon(Icons.notifications_active),
                    label: const Text("Lihat Detail Sunnah Harian"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink.shade300,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _goToTodaySunnah(BuildContext context, Map<String, dynamic> selected) {
    final String masehiIso =
        selected["masehi"]?.toString() ?? DateTime.now().toIso8601String();
    final DateTime masehiDate = DateTime.tryParse(masehiIso) ?? DateTime.now();

    final dynamic rawEvents = selected["events"];
    final List<String> todayEvents = (rawEvents is List)
        ? rawEvents.map((e) => e.toString()).toList()
        : <String>[];

    final int hDay = selected["hijri_day"] as int? ?? 1;
    final int hYear = hijriYear;
    final String hMonth = _translateHijriMonth(hijriMonthName);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TodaysSunnahPage(
          today: masehiDate,
          hijriDate: {"day": hDay, "month": hMonth, "year": hYear},
          events: todayEvents,
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              size: 50,
              color: Colors.redAccent,
            ),
            const SizedBox(height: 16),
            Text(
              "Gagal memuat data kalender Hijriah.",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Text(
              "Periksa koneksi internet atau coba muat ulang.",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              key: const ValueKey('reloadButton'),
              onPressed: _loadInitialHijri,
              icon: const Icon(Icons.refresh),
              label: const Text("Coba Muat Ulang"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink.shade200,
                foregroundColor: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent;

    if (isLoading) {
      mainContent = const Center(child: CircularProgressIndicator());
    } else if (hijriMonthDays.isEmpty) {
      mainContent = _buildErrorState();
    } else {
      final totalItemCount = hijriMonthDays.length + startDayOffset;

      mainContent = SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, size: 18),
                  onPressed: () => _changeMonth(-1),
                ),

                Column(
                  children: [
                    Text(
                      "${_translateHijriMonth(hijriMonthName)} $hijriYear H",
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                ),

                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, size: 18),
                  onPressed: () => _changeMonth(1),
                ),
              ],
            ),

            Text(
              _getGregorianRange(),
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54),
            ),

            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]
                    .map(
                      (d) => Text(
                        d,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),

                itemCount: totalItemCount,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.9,
                ),
                itemBuilder: (_, i) {
                  if (i < startDayOffset) {
                    return const SizedBox.shrink();
                  }

                  final dataIndex = i - startDayOffset;
                  final item = hijriMonthDays[dataIndex];

                  final hDay = item["hijri_day"] as int;
                  final masehiIso = item["masehi"] as String;

                  final isSelected = hDay == selectedHijriDay;

                  final hasEvent =
                      (item["events"] as List<String>?)?.isNotEmpty ?? false;

                  return GestureDetector(
                    onTap: () {
                      setState(() => selectedHijriDay = hDay);
                      _showEventBottomSheet(item);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.pink.shade200
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "$hDay",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "${_safeGetDayFromIso(masehiIso)}",
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: Colors.grey[700],
                            ),
                          ),

                          if (hasEvent)
                            Container(
                              margin: const EdgeInsets.only(top: 2),
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.pinkAccent,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFBDEDE),
      body: SafeArea(child: mainContent),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.pinkAccent,
        unselectedItemColor: Colors.grey,
        onTap: (i) {
          if (i == 1) {
            if (hijriMonthDays.isEmpty) return;
            final selectedDayData = hijriMonthDays.firstWhere(
              (x) => x["hijri_day"] == selectedHijriDay,
              orElse: () {
                return <String, dynamic>{
                  "hijri_day": 1,
                  "masehi": DateTime.now().toIso8601String(),
                  "events": <String>[],
                  "masehi_raw": "",
                };
              },
            );
            _goToTodaySunnah(context, selectedDayData);
          }
          if (i == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EditProfilePage()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
        ],
      ),
    );
  }

  String _getGregorianRange() {
    if (hijriMonthDays.isEmpty) return "-";
    final firstIso = hijriMonthDays.first["masehi"] as String;
    final lastIso = hijriMonthDays.last["masehi"] as String;

    final f = DateTime.parse(firstIso);
    final l = DateTime.parse(lastIso);

    return "${_monthName(f.month)} ${f.year} – ${_monthName(l.month)} ${l.year}";
  }

  String _monthName(int m) {
    const names = [
      "",
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return names[m];
  }

  int _safeGetDayFromIso(String iso) {
    try {
      final dt = DateTime.parse(iso);
      return dt.day;
    } catch (e) {
      final parts = iso.split("-");
      if (parts.length >= 3) {
        return int.tryParse(parts.last) ?? 1;
      }
      return 1;
    }
  }
}

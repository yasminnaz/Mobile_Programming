import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo ListView',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Demo ListView'),
          backgroundColor: Colors.amber,
        ),
        body: ListView(
          padding: const EdgeInsets.all(8),
          children: [
            listTile(
              Colors.blueAccent.shade400,
              Colors.greenAccent.shade400,
              'Kehadiran',
              'Presensi Kehadiran Kuliah',
              'assets/icon/boy.png',
            ),
            listTile(
              Colors.greenAccent.shade400,
              Colors.blueAccent.shade400,
              'Jadwal',
              'Jadwal Perkuliahan',
              'assets/icon/timetable.png',
            ),
            listTile(
              Colors.yellowAccent.shade400,
              Colors.redAccent.shade400,
              'Tugas',
              'Tugas Perkuliahan di luar kelas',
              'assets/icon/homeschooling.png',
            ),
            listTile(
              Colors.redAccent.shade400,
              Colors.amberAccent.shade400,
              'Pengumuman',
              'Informasi terkait Perkuliahan',
              'assets/icon/clipboard.png',
            ),
            listTile(
              Colors.purpleAccent.shade400,
              Colors.tealAccent.shade400,
              'Nilai',
              'Nilai ujian dan tugas',
              'assets/icon/marks.png',
            ),
            listTile(
              Colors.tealAccent.shade400,
              Colors.purpleAccent.shade400,
              'Catatan',
              'Pengingat Kegiatan Perkuliahan',
              'assets/icon/pencil.png',
            ),
          ],
        ),
      ),
    );
  }
}

Container listTile(
  Color warna,
  Color warnaAvatar,
  String judul,
  String subjudul,
  String gambar,
) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: ListTile(
      tileColor: warna,
      title: Text(
        judul,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(subjudul, style: const TextStyle(fontSize: 16)),
      leading: CircleAvatar(
        backgroundColor: warnaAvatar,
        radius: 30,
        child: Image.asset(gambar, width: 35, height: 35),
      ),
      trailing: Icon(Icons.star, color: Colors.orangeAccent.shade400),
    ),
  );
}

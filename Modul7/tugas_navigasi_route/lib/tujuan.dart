import 'package:flutter/material.dart';

class Tujuan extends StatelessWidget {
  const Tujuan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrangeAccent, // biru
      body: Padding(
        padding: const EdgeInsets.all(20), // biar ada jarak dari tepi layar
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // rata kiri
          children: [
            const SizedBox(height: 40), // jarak dari atas layar
            const Text(
              "Ini Halaman Tujuan",
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              "Untuk berpindah ke halaman baru, gunakan metode Navigator.push(). Metode push() akan menambahkan Route ke dalam tumpukan Route yang dikelola oleh Navigator. Route ini dapat dibuat secara kustom atau menggunakan MaterialPageRoute, yang memiliki animasi transisi sesuai dengan platform yang digunakan.",
              style: TextStyle(fontSize: 14, color: Colors.white),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 35),
            Center(
              child: Column(
                children: [
                  Card(
                    color: Colors.white,
                    elevation: 7,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Image.asset("assets/icon/tujuan.png", width: 120),
                    ),
                  ),
                  const SizedBox(height: 35),
                  const Text(
                    "Untuk menutup halaman kedua dan kembali ke halaman pertama, gunakan metode Navigator.pop(). Metode pop() akan menghapus Route saat ini dari tumpukan route yang dikelola oleh Navigator.",
                    style: TextStyle(fontSize: 14, color: Colors.white),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "< Kembali ke Home",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

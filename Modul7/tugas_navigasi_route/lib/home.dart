import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0081c9), // biru
      body: Padding(
        padding: const EdgeInsets.all(20), // biar ada jarak dari tepi layar
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // rata kiri
          children: [
            const SizedBox(height: 40), // jarak dari atas layar
            const Text(
              "Ini Halaman Home",
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              "Banyak aplikasi memiliki beberapa layar untuk menampilkan informasi yang berbeda. Contohnya, ada layar produk, dan ketika pengguna mengklik produk, akan muncul layar dengan detail produk tersebut.",
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
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Image.asset("assets/icon/home.png", width: 120),
                    ),
                  ),
                  const SizedBox(height: 35),
                  const Text(
                    "Pertama, kita perlu membuat dua halaman atau 'route' yang ingin kita tampilkan. Selanjutnya, kita gunakan perintah Navigator.push() untuk berpindah dari halaman pertama ke halaman kedua. Ini seperti kita membuka halaman baru. Terakhir, kita bisa kembali dari halaman kedua ke halaman pertama menggunakan Navigator.pop(). Seperti menutup halaman kedua dan kembali ke halaman pertama.",
                    style: TextStyle(fontSize: 14, color: Colors.white),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrangeAccent,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/tujuan');
                    },
                    child: const Text(
                      "Ke halaman tujuan >",
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

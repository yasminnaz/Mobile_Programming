# Aplikasi Kalender Hijriah dan Pengingat Ibadah Sunnah
##### Yasmin Nur Azizah - 230605110008


Aplikasi mobile yang membantu umat Islam mengetahui tanggal Hijriyah secara akurat serta memberikan pengingat ibadah sunnah harian seperti puasa Senin-Kamis dan Ayyamul Bidh. Dikembangkan menggunakan Flutter, aplikasi ini memiliki antarmuka yang sederhana, lembut, dan mudah digunakan.

Aplikasi ini dibuat untuk memenuhi kebutuhan umat Muslim akan kalender islami yang praktis, tidak hanya menampilkan tanggal Hijriyah, tetapi juga memberikan informasi hari besar Islam dan pengingat amalan sunnah.

#### Teknologi yang Digunakan
- Framework: Flutter
- Bahasa Pemrograman: Dart
- Desain Antarmuka: Figma
#### Dependency Tambahan:
- google_fonts – untuk gaya huruf modern
- intl – format tanggal dan lokal Indonesia
- shared_preferences – penyimpanan lokal data sederhana
- http – untuk melakukan permintaan HTTP (GET Request) ke API eksternal.
#### Sumber Data:
- sunnah_harian.json
- sunnah_bulanan.json
- API AlAdhan: Digunakan untuk mengambil data kalender Hijriah, konversi tanggal, dan Hari Besar/Libur Islam.
##### Endpoint yang digunakan: 
Kalender Bulanan Hijriah ke Masehi: https://api.aladhan.com/v1/hToGCalendar/{bulan}/{tahun}


### Fitur Utama
#### Islamic Calendar App:

-**Calendar Page:** menampilkan tanggal Hijriyah dan Masehi serta hari-hari penting Islam.

-**Todays Sunnah Page:** memberikan pengingat otomatis untuk puasa dan amalan sunnah harian.

-**Profile Page:** untuk mengubah data profil pengguna.


.
### Langkah menjalankan aplikasi
- Buka folder islamic_calendar_app.
Jalankan:
*flutter pub get
flutter run*
- Setelah aplikasi berjalan, halaman utama akan menampilkan kalender Hijriyah bulan Jumadil Akhir 1447 H.
- Tekan salah satu tanggal untuk melihat event Islam pada hari tersebut.
- Gunakan navigasi bawah (BottomNavigationBar) untuk berpindah halaman:

**📅 Kalender** → menampilkan tanggal Hijriyah dan event.
  
**🔔 Sunnah Harian**→ menampilkan amalan seperti puasa Senin–Kamis atau Ayyamul Bidh.

**👤 Profil** → menampilkan form Edit Profil Pengguna.




.
##### Catatan Pengembangan
Aplikasi telah berhasil mengintegrasikan API dan menghilangkan ketergantungan pada data statis JSON:

- **Integrasi API:** Data kalender, hari besar, dan konversi tanggal sepenuhnya diambil dari **API AlAdhan**, didukung oleh penanganan *error* yang ketat (termasuk *encoding* dan *type safety*).
- **Penyimpanan Profil:** Fitur profil menggunakan *shared_preferences* untuk menyimpan perubahan data pengguna secara lokal dan persisten.
- **Pengembangan Lanjut:** Fitur yang direncanakan untuk tahap berikutnya adalah implementasi fitur CRUD (Create, Read, Update, Delete) untuk catatan ibadah pengguna.

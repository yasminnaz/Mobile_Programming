### Aplikasi Kalender Hijriah dan Pengingat Ibadah Sunnah
###### Yasmin Nur Azizah - 230605110008



Aplikasi mobile yang membantu umat Islam mengetahui tanggal Hijriyah secara akurat serta memberikan pengingat ibadah sunnah harian seperti puasa Senin-Kamis dan Ayyamul Bidh. Dikembangkan menggunakan Flutter, aplikasi ini memiliki antarmuka yang sederhana, lembut, dan mudah digunakan.

Aplikasi ini dibuat untuk memenuhi kebutuhan umat Muslim akan kalender islami yang praktis, tidak hanya menampilkan tanggal Hijriyah, tetapi juga memberikan informasi hari besar Islam dan pengingat amalan sunnah.



#### Teknologi yang Digunakan
1. Framework: Flutter
2. Bahasa Pemrograman: Dart
3. Desain Antarmuka: Figma
4. Dependency Tambahan: 
- google_fonts – untuk gaya huruf modern
- intl – format tanggal dan lokal Indonesia
- shared_preferences – penyimpanan lokal data sederhana
5. Asset Data:
- events.json
- sunnah_harian.json
- sunnah_bulanan.json



#### Fitur Utama
Project ini terbagi menjadi dua bagian:
1. Login Page: halaman awal untuk autentikasi pengguna.
2. Islamic Calendar App:
- Calendar Page: menampilkan tanggal Hijriyah dan Masehi serta hari-hari penting Islam.
- Todays Sunnah Page: memberikan pengingat otomatis untuk puasa dan amalan sunnah harian.
- Profile Page: untuk mengubah data profil pengguna.




#### Langkah menjalankan aplikasi 
##### A. Menjalankan Halaman Login
1. Buka folder login_page di Visual Studio Code.
2. Jalankan perintah:
- flutter pub get
- flutter run
3. Aplikasi akan menampilkan halaman login dengan form email dan password.
4. Masukkan data contoh:
- Email: user@example.com
- Password: 123456
5. Tekan tombol Login, maka akan muncul pesan “Login berhasil!” di bagian bawah layar.

##### B. Menjalankan Aplikasi Kalender Hijriah
1. Buka folder islamic_calendar_app.
2. Jalankan:
- flutter pub get
- flutter run
3. Setelah aplikasi berjalan, halaman utama akan menampilkan kalender Hijriyah bulan Rabiul Awal 1447 H.
4. Tekan salah satu tanggal untuk melihat event Islam pada hari tersebut.
5. Gunakan navigasi bawah (BottomNavigationBar) untuk berpindah halaman:
- 📅 Kalender → menampilkan tanggal Hijriyah dan event.
- 🔔 Sunnah Harian → menampilkan amalan seperti puasa Senin–Kamis atau Ayyamul Bidh.
- 👤 Profil → menampilkan form Edit Profil Pengguna.




#### Catatan Pengembangan

Saat ini aplikasi masih terdiri dari dua modul terpisah:
1. Modul Login belum terhubung dengan aplikasi Kalender Hijriyah.
2. Integrasi API untuk data tanggal Hijriyah dan ibadah sunnah belum diterapkan (masih menggunakan data dummy dan JSON).
3. Fitur CRUD untuk catatan ibadah dan pengingat otomatis direncanakan pada tahap pengembangan berikutnya.


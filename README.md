# 🕌 Kajian Scheduler

Aplikasi Manajemen Jadwal Kajian Islam dengan Flutter

---

## 📱 Tema dan Tujuan Aplikasi

### Tema
**Kajian Scheduler** adalah aplikasi mobile berbasis Flutter yang dirancang untuk membantu umat Muslim dalam mengelola jadwal kajian Islam, mengakses informasi waktu sholat, dan membaca Al-Quran digital dengan pendekatan modern dan user-friendly.

### Tujuan
1. Membantu pengguna membuat dan mengelola jadwal kajian Islam (Tafsir, Hadits, Fiqih, Akhlaq, Sejarah)
2. Menyediakan informasi jadwal sholat lengkap dengan tanggal Hijriah
3. Memfasilitasi akses Al-Quran digital dengan teks Arab (RTL), transliterasi, dan terjemahan Indonesia
4. Memberikan pengalaman user yang optimal dengan dark mode dan multi-language support
5. Memudahkan pencatatan detail kajian termasuk ustadz, tema, lokasi, dan catatan penting

---

## 📋 Daftar Halaman dan Fungsinya

| No | Nama Halaman | Route | Fungsi |
|----|--------------|-------|--------|
| 1 | Splash Screen | / | Menampilkan loading screen dengan animasi logo dan auto-routing berdasarkan status login |
| 2 | Login | /login | Autentikasi user dengan email dan password, validasi form, dan persistent session |
| 3 | Register | /register | Pendaftaran akun baru dengan validasi nama, email, password, dan confirm password |
| 4 | Dashboard | /dashboard | Menampilkan greeting user, daftar kajian dengan expandable card, filter status, dan statistik |
| 5 | Add Kajian | /add_kajian | Form untuk menambah kajian baru: judul, ustadz, tema, tanggal, waktu (manual/ba'da sholat), lokasi, kategori, catatan |
| 6 | Edit Kajian | /edit_kajian | Form untuk mengedit detail kajian yang sudah ada dengan pre-filled data dan opsi delete |
| 7 | Prayer Times | /prayer_times | Menampilkan jadwal sholat 7 waktu (Subuh-Isya) dengan highlight next prayer, countdown, dan tanggal Hijriah |
| 8 | Quran List | /quran_list | Menampilkan daftar 114 surat Al-Quran dengan search, filter Makkiyyah/Madaniyyah, dan info jumlah ayat |
| 9 | Quran Detail | /quran_detail | Menampilkan ayat-ayat dalam surat dengan teks Arab (RTL), transliterasi (toggleable), dan terjemahan Indonesia |
| 10 | Profile | /profile | Menampilkan informasi user, statistik kajian, menu edit profil, ganti password, about app, dan logout |
| 11 | Settings | /settings | Pengaturan aplikasi: toggle dark/light mode, pilihan bahasa (ID/EN), dan pilihan kota untuk jadwal sholat |

---

## 🚀 Langkah-langkah Menjalankan Aplikasi

### 1. Persiapan Environment

**Install Flutter SDK:**
```bash
# Download Flutter SDK dari https://flutter.dev
# Extract dan tambahkan ke PATH

# Verify instalasi
flutter doctor
```

**Clone Repository:**
```bash
git clone https://github.com/briannur/kajian-scheduler.git
cd kajian-scheduler
```

**Install Dependencies:**
```bash
flutter pub get
```

### 2. Buka Aplikasi

**Run di Emulator/Device:**
```bash
# Jalankan aplikasi
flutter run

# Atau untuk specific device
flutter run -d 
```

Aplikasi akan menampilkan splash screen dengan animasi selama ±3 detik, kemudian auto-routing:
- Jika sudah login → Dashboard
- Jika belum login → Login Screen

### 3. Login atau Daftar Akun

**Jika Belum Punya Akun:**
- Tap **"Daftar Akun Baru"** di halaman login
- Isi form registrasi: Nama Lengkap, Email, Password, Konfirmasi Password
- Tap tombol **"Daftar"**
- Setelah berhasil, Anda akan otomatis login dan masuk ke Dashboard

**Jika Sudah Punya Akun:**
- Masukkan Email dan Password Anda
- Tap tombol **"Masuk"**

**Akun Demo untuk Testing:**
- Email: `briannur2102@gmail.com`
- Password: `brian123`

Atau:
- Email: `nirma147@gmail.com`
- Password: `nirma123`

### 4. Navigasi Dashboard (Home)

Setelah login, Anda akan masuk ke halaman Dashboard:
- **Header**: Greeting berdasarkan waktu (Pagi/Siang/Sore/Malam), avatar user, dan tanggal hari ini
- **Filter Chips**: "Semua", "Akan Datang", "Sudah Lewat" untuk filter kajian
- **Daftar Kajian**: Tap card untuk expand/collapse detail lengkap
- **FAB Button**: Tap tombol **"+ Tambah Kajian"** untuk menambah kajian baru

### 5. Kelola Kajian

**Melihat Detail Kajian:**
- Tap **Kajian Card** (collapsed state) untuk expand
- Lihat detail lengkap: tanggal, lokasi, tema, catatan, kategori
- Toggle switch **"Tandai Selesai"** untuk ubah status
- Tap lagi untuk collapse card

**Menambah Kajian Baru:**
- Tap tombol **+** (FAB) di Dashboard
- Isi **Judul Kajian** (contoh: "Kajian Tafsir Al-Baqarah")
- Isi **Nama Ustadz** (contoh: "Ustadz Ahmad Saputra")
- Isi **Tema Kajian** (contoh: "Tafsir Al-Quran Juz 1-2")
- **Pilih Tanggal**: Tap kalender → Pilih tanggal dari TableCalendar
- **Pilih Waktu**: 
  - Toggle **"Manual"** → Pilih jam:menit dari time picker
  - Toggle **"Ba'da Sholat"** → Pilih dari list (Ba'da Subuh, Dzuhur, Ashar, Maghrib, Isya) dengan waktu otomatis
- Isi **Lokasi** (contoh: "Masjid Agung Malang")
- **Pilih Kategori**: Tap salah satu chip (Tafsir 📖, Hadits 📚, Fiqih ⚖️, Akhlaq 💚, Sejarah 🕌, Lainnya 📋)
- Tambahkan **Catatan** (optional)
- Tap tombol **"Simpan Kajian"**

**Mengedit Kajian:**
- Tap card untuk expand
- Tap tombol **"Edit"** di bagian bawah card
- Atau dari Dashboard tap icon **edit** jika ada
- Ubah data yang diperlukan
- Tap tombol **"Simpan Perubahan"**

**Menghapus Kajian:**
- Buka **Edit Kajian Screen**
- Tap icon **delete** (🗑️) di AppBar kanan atas
- Konfirmasi penghapusan pada dialog
- Tap **"Hapus"** untuk konfirmasi

### 6. Fitur Jadwal Sholat

**Melihat Jadwal Sholat:**
- Tap menu **"Sholat"** (🕌) di bottom navigation
- Lihat jadwal 7 waktu: Subuh, Terbit, Dhuha, Dzuhur, Ashar, Maghrib, Isya
- **Next Prayer** ditandai dengan:
  - Background pink terang
  - Border pink
  - Text bold pink
  - Countdown: "dalam 7 jam 35 menit"
- Lihat **Tanggal Hijriah** di card bagian bawah
- **Pull to refresh** untuk update data

**Fitur Ba'da Sholat (Unique!):**
- Saat add kajian, pilih mode **"Ba'da Sholat"**
- Waktu akan otomatis di-mapping dari `prayer_times.json`
- Contoh: Pilih "Ba'da Maghrib" → Otomatis isi waktu "18:00"

### 7. Fitur Al-Quran Digital

**Browse Daftar Surat:**
- Tap menu **"Al-Quran"** (📖) di bottom navigation
- Lihat list 114 surat dengan info:
  - Nomor surat (badge hijau)
  - Nama surat + Nama Arab (right-aligned)
  - Terjemahan + jumlah ayat
  - Badge revelation type (Makkiyyah 🟡 / Madaniyyah 🟣)

**Search Surat:**
- Gunakan **search bar** di atas
- Ketik nama surat (contoh: "fatihah")
- Tap **X** untuk clear search

**Filter Surat:**
- Tap chip **"Makkiyyah"** → Show 86 surat Makkiyyah
- Tap chip **"Madaniyyah"** → Show 28 surat Madaniyyah
- Tap chip **"Semua"** → Show all 114 surat

**Baca Detail Ayat:**
- Tap **Surat Card** untuk masuk detail
- Jika surat tersedia (Al-Fatihah, Al-Ikhlas, Al-Falaq, An-Nas):
  - Lihat **Bismillah** di bagian atas (kecuali At-Taubah)
  - Scroll untuk baca ayat per ayat dengan struktur:
    - **Nomor ayat** (badge hijau)
    - **Teks Arab** (RTL, bold, font size 28px default)
    - **Transliterasi** (italic, dapat di-hide via settings)
    - **Terjemahan Indonesia** (border left hijau)
- Jika surat belum tersedia:
  - Tampil message: "Surat belum tersedia untuk UTS"
  - Info: "Di UAS akan menggunakan API lengkap"

**Customize Tampilan Quran:**
- Tap **FAB Settings** (⚙️) di pojok kanan bawah
- **Toggle Transliterasi**: Show/Hide transliterasi
- **Slider Font Arab**: Adjust ukuran 20-40px
- **Slider Font Terjemahan**: Adjust ukuran 12-24px
- Tap **"Tutup"** untuk save

### 8. Profile & Statistik

**Melihat Profile:**
- Tap menu **"Profil"** (👤) di bottom navigation
- Lihat informasi:
  - Avatar dengan initial nama
  - Nama lengkap
  - Email (chip)
  - **Statistik Cards**: Total Kajian (12) | Bulan Ini (5)

**Menu Profile:**
- **Edit Profil**: Ubah nama dan email (Fitur akan tersedia di UAS)
- **Ganti Password**: Ubah password akun (Fitur akan tersedia di UAS)
- **Tentang Aplikasi**: Info aplikasi, versi 1.0.0, copyright
- **Logout**: Keluar dari akun dengan konfirmasi dialog

### 9. Pengaturan Aplikasi

**Akses Settings:**
- Tap menu **"Pengaturan"** (⚙️) di bottom navigation

**Tampilan:**
- **Tema Gelap**: Toggle switch untuk dark/light mode
  - Perubahan instant tanpa flicker
  - Persistent setelah app restart

**Bahasa:**
- Tap **"Bahasa"** → Dialog dengan pilihan:
  - 🇮🇩 Indonesia
  - 🇬🇧 English
- Pilih bahasa → Seluruh label UI berubah
- SnackBar konfirmasi: "Bahasa diubah ke ..."

**Lokasi:**
- Tap **"Kota"** → Dialog dengan list 13 kota:
  - Jakarta, Surabaya, Bandung, Medan, Semarang, Makassar, Palembang, Tangerang, Malang, Depok, Yogyakarta, Bogor, Bekasi
- Pilih kota untuk jadwal sholat (akan terintegrasi API di UAS)
- SnackBar konfirmasi: "Kota diubah ke ..."

### 10. Logout

**Cara Logout:**
- Buka halaman **Profile**
- Scroll ke bawah
- Tap tombol **"Logout"** (warna merah)
- Dialog konfirmasi muncul: "Apakah Anda yakin ingin keluar?"
- Tap **"Logout"** untuk konfirmasi
- Session cleared dari SharedPreferences
- Navigate to Login screen dengan `pushAndRemoveUntil`
- Tidak bisa back ke Dashboard setelah logout ✅

---

*Dikembangkan oleh*: Nur Muhammad Anang Febriananto - 230605110103 
*Mata Kuliah*: Mobile Programming (Teori-Praktikum)

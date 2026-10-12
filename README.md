# NusaBookstore 📚

Aplikasi katalog dan keranjang buku Flutter dengan **Provider state management**, terinspirasi dari desain Google Stitch yang disertakan.

## Fitur
- Katalog enam buku dengan kategori dan pencarian judul/penulis.
- Model `Book` dengan id, title, author, price, imageUrl opsional, kategori, rating, dan warna cover placeholder.
- `CartProvider` menggunakan `ChangeNotifier`: tambah item, tambah/kurangi kuantitas, hapus buku, kosongkan keranjang, total item, dan total harga.
- Badge keranjang reaktif.
- `ThemeProvider` untuk Light Mode dan Dark Mode seluruh aplikasi.
- Ringkasan pembayaran dengan format Rupiah.
- Checkout menampilkan SnackBar sukses dan mengosongkan keranjang.
- Desain maroon-pink dengan cover buku placeholder sehingga tetap tampil tanpa koneksi internet.

## Struktur
```text
lib/
├── models/
│   └── book.dart
├── providers/
│   ├── cart_provider.dart
│   └── theme_provider.dart
├── screens/
│   ├── catalog_screen.dart
│   └── cart_screen.dart
└── main.dart
```

## Menjalankan
Pastikan Flutter SDK sudah terpasang, lalu dari direktori proyek jalankan:

```bash
flutter pub get
flutter run
```

Untuk menjalankan di Chrome (pastikan target web tersedia):
```bash
flutter run -d chrome
```

Untuk mengecek analisis statis:
```bash
flutter analyze
```

## Screenshot referensi Google Stitch

Desain awal dari Google Stitch tersedia di folder `design_reference/`. Gambar ini adalah **referensi desain**, bukan screenshot hasil runtime Flutter. Setelah aplikasi dijalankan, ambil screenshot katalog, keranjang, Light Mode, Dark Mode, dan SnackBar checkout lalu tambahkan ke README ini untuk pengumpulan tugas.

- `design_reference/cart_light.png` — referensi keranjang Light Mode.
- `design_reference/checkout_success.png` — referensi status checkout.

## Catatan
- Project ini berisi kode sumber Flutter; folder platform seperti `android/`, `ios/`, dan `web/` dapat dibuat oleh Flutter CLI dengan `flutter create .` jika dibutuhkan.
- Tidak ada gambar eksternal wajib sehingga UI katalog dapat dibuka offline.

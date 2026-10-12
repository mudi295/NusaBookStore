import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../models/book.dart';
import '../providers/cart_provider.dart';
import '../providers/theme_provider.dart';
import 'cart_screen.dart';

const List<Book> catalogBooks = [
  Book(id: 'b1', title: 'Atomic Habits', author: 'James Clear', price: 95000, category: 'Pengembangan Diri', rating: 4.9, coverColor: 0xFF274C43),
  Book(id: 'b2', title: 'Filosofi Teras', author: 'Henry Manampiring', price: 78000, category: 'Pengembangan Diri', rating: 4.8, coverColor: 0xFFB85C38),
  Book(id: 'b3', title: 'Laskar Pelangi', author: 'Andrea Hirata', price: 85000, category: 'Novel', rating: 4.9, coverColor: 0xFF236B83),
  Book(id: 'b4', title: 'Negeri 5 Menara', author: 'Ahmad Fuadi', price: 82000, category: 'Novel', rating: 4.7, coverColor: 0xFF6D355B),
  Book(id: 'b5', title: 'Laut Bercerita', author: 'Leila S. Chudori', price: 99000, category: 'Novel', rating: 4.8, coverColor: 0xFF25465B),
  Book(id: 'b6', title: 'Deep Work', author: 'Cal Newport', price: 89000, category: 'Teknologi', rating: 4.6, coverColor: 0xFF3F4268),
];

String rupiah(int value) {
  final digits = value.toString();
  final buffer = StringBuffer();
  for (int i = 0; i < digits.length; i++) {
    buffer.write(digits[i]);
    final remaining = digits.length - i - 1;
    if (remaining > 0 && remaining % 3 == 0) buffer.write('.');
  }
  return 'Rp ${buffer.toString()}';
}

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});
  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  String category = 'Semua';
  String query = '';
  final categories = const ['Semua', 'Novel', 'Pengembangan Diri', 'Teknologi'];

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final cart = context.watch<CartProvider>();
    final visibleBooks = catalogBooks.where((book) {
      final matchesCategory = category == 'Semua' || book.category == category;
      final matchesQuery = book.title.toLowerCase().contains(query.toLowerCase()) ||
          book.author.toLowerCase().contains(query.toLowerCase());
      return matchesCategory && matchesQuery;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(color: maroon, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.auto_stories_rounded, color: Colors.white),
          ),
          const SizedBox(width: 10),
          const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('NusaBookstore', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 19)),
            Text('Setiap buku punya cerita.', style: TextStyle(fontSize: 11, fontWeight: FontWeight.normal)),
          ]),
        ]),
        actions: [
          IconButton(
            tooltip: isDark ? 'Aktifkan Light Mode' : 'Aktifkan Dark Mode',
            onPressed: () => context.read<ThemeProvider>().toggleTheme(),
            icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Stack(clipBehavior: Clip.none, children: [
              IconButton(
                tooltip: 'Keranjang belanja',
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
                icon: const Icon(Icons.shopping_bag_outlined, size: 27),
              ),
              if (cart.totalItems > 0)
                Positioned(right: 0, top: 0, child: Container(
                  padding: const EdgeInsets.all(5),
                  constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                  decoration: const BoxDecoration(color: rosePink, shape: BoxShape.circle),
                  child: Text('${cart.totalItems}', textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                )),
            ]),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(colors: [deepMaroon, maroon], begin: Alignment.topLeft, end: Alignment.bottomRight),
            ),
            child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(.14), borderRadius: BorderRadius.circular(30)),
                  child: const Text('RUANG BACA PILIHAN', style: TextStyle(color: Color(0xFFFFCCD5), fontSize: 9, letterSpacing: 1.1, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 14),
                const Text('Dunia Baru\ndi Setiap Halaman', style: TextStyle(color: Colors.white, fontSize: 25, height: 1.12, fontWeight: FontWeight.w800)),
                const SizedBox(height: 9),
                const Text('Temukan buku yang menginspirasi harimu.', style: TextStyle(color: Color(0xFFFFDDE5), fontSize: 12, height: 1.4)),
                const SizedBox(height: 16),
                const Row(children: [
                  Text('Jelajahi buku', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                  SizedBox(width: 7), Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 16),
                ]),
              ])),
              const SizedBox(width: 8),
              const Icon(Icons.menu_book_rounded, color: Color(0xFFFFCCD5), size: 92),
            ]),
          ),
          const SizedBox(height: 22),
          TextField(
            onChanged: (value) => setState(() => query = value),
            decoration: const InputDecoration(
              hintText: 'Cari judul atau penulis...',
              prefixIcon: Icon(Icons.search_rounded),
              suffixIcon: Icon(Icons.tune_rounded),
            ),
          ),
          const SizedBox(height: 22),
          const Text('Temukan bacaanmu', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 5),
          Text('Pilihan cerita untuk menemani harimu.', style: TextStyle(color: Theme.of(context).hintColor, fontSize: 13)),
          const SizedBox(height: 16),
          SizedBox(height: 38, child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final item = categories[index];
              final selected = item == category;
              return ChoiceChip(
                label: Text(item),
                selected: selected,
                onSelected: (_) => setState(() => category = item),
                selectedColor: maroon,
                backgroundColor: isDark ? const Color(0xFF28151F) : const Color(0xFFFFE0EB),
                labelStyle: TextStyle(color: selected ? Colors.white : Theme.of(context).colorScheme.onSurface, fontSize: 11, fontWeight: FontWeight.w600),
                side: BorderSide.none,
                showCheckmark: false,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
              );
            },
          )),
          const SizedBox(height: 18),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Buku pilihan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            Text('${visibleBooks.length} buku', style: TextStyle(color: Theme.of(context).hintColor, fontSize: 12)),
          ]),
          const SizedBox(height: 12),
          if (visibleBooks.isEmpty)
            const Padding(padding: EdgeInsets.all(32), child: Center(child: Text('Buku tidak ditemukan.')))
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: visibleBooks.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 14, childAspectRatio: .57,
              ),
              itemBuilder: (context, index) => _BookCard(book: visibleBooks[index]),
            ),
          const SizedBox(height: 12),
          Center(child: Text('Dibuat dengan cinta untuk para pembaca ♡', style: TextStyle(color: Theme.of(context).hintColor, fontSize: 11))),
        ],
      ),
    );
  }
}

class _BookCard extends StatelessWidget {
  final Book book;
  const _BookCard({required this.book});

  @override
  Widget build(BuildContext context) {
    final count = context.watch<CartProvider>().quantityFor(book.id);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(book.coverColor),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(.08), blurRadius: 8, offset: const Offset(0, 4))],
              ),
              child: Stack(children: [
                Positioned(top: 10, left: 10, right: 10, child: Container(height: 1, color: Colors.white.withOpacity(.5))),
                Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.auto_stories_rounded, color: Colors.white.withOpacity(.85), size: 35),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(book.title.toUpperCase(), textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.1, fontWeight: FontWeight.w900, letterSpacing: .3)),
                  ),
                  const SizedBox(height: 8),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Text(book.author,
                    textAlign: TextAlign.center, maxLines: 2, style: const TextStyle(color: Color(0xFFFFE0EB), fontSize: 9))),
                ])),
                Positioned(bottom: 10, left: 10, right: 10, child: Container(height: 1, color: Colors.white.withOpacity(.5))),
              ]),
            ),
          ),
          const SizedBox(height: 10),
          Text(book.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
          const SizedBox(height: 3),
          Text(book.author, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 10, color: Theme.of(context).hintColor)),
          const SizedBox(height: 7),
          Row(children: [
            const Icon(Icons.star_rounded, color: Color(0xFFFFB703), size: 14),
            const SizedBox(width: 3),
            Text(book.rating.toString(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
          ]),
          const SizedBox(height: 5),
          Text(rupiah(book.price), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: rosePink)),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {
                context.read<CartProvider>().addItem(book);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('${book.title} ditambahkan ke keranjang'),
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 1),
                ));
              },
              icon: Icon(count > 0 ? Icons.add_rounded : Icons.shopping_bag_outlined, size: 15),
              label: Text(count > 0 ? 'Tambah ($count)' : 'Tambah', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              style: FilledButton.styleFrom(backgroundColor: maroon, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 11), minimumSize: const Size(0, 38)),
            ),
          ),
        ]),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../providers/cart_provider.dart';
import 'catalog_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Keranjang Belanja', style: TextStyle(fontWeight: FontWeight.w800)),
          Text('Bacaan pilihanmu menanti.', style: TextStyle(fontSize: 11, fontWeight: FontWeight.normal)),
        ]),
      ),
      body: cart.items.isEmpty
          ? _EmptyCart(onBrowse: () => Navigator.pop(context))
          : ListView(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('${cart.items.length} judul buku', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                  TextButton.icon(
                    onPressed: () => _confirmClear(context),
                    icon: const Icon(Icons.delete_outline_rounded, size: 17),
                    label: const Text('Kosongkan'),
                  ),
                ]),
                const SizedBox(height: 8),
                ...cart.items.map((entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Container(
                          width: 78, height: 112,
                          decoration: BoxDecoration(color: Color(entry.book.coverColor), borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(7),
                            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                              const Icon(Icons.auto_stories_rounded, color: Colors.white, size: 24),
                              const SizedBox(height: 7),
                              Text(entry.book.title.toUpperCase(), textAlign: TextAlign.center, maxLines: 4,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 9, height: 1.1)),
                            ]),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(entry.book.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 3),
                          Text(entry.book.author, style: TextStyle(fontSize: 11, color: Theme.of(context).hintColor)),
                          const SizedBox(height: 8),
                          Text(rupiah(entry.book.price), style: const TextStyle(fontWeight: FontWeight.w800, color: rosePink, fontSize: 13)),
                          const SizedBox(height: 10),
                          Row(children: [
                            _QuantityButton(icon: Icons.remove_rounded, onTap: () => context.read<CartProvider>().removeItem(entry.book.id)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 13),
                              child: Text('${entry.quantity}', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                            ),
                            _QuantityButton(icon: Icons.add_rounded, filled: true, onTap: () => context.read<CartProvider>().addItem(entry.book)),
                            const Spacer(),
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              tooltip: 'Hapus buku',
                              onPressed: () => context.read<CartProvider>().removeBook(entry.book.id),
                              icon: const Icon(Icons.delete_outline_rounded, color: rosePink, size: 20),
                            ),
                          ]),
                        ])),
                      ]),
                    ),
                  ),
                )),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('Ringkasan pesanan', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 16),
                      _SummaryRow(label: 'Total Item', value: '${cart.totalItems} buku'),
                      const SizedBox(height: 10),
                      _SummaryRow(label: 'Total Harga Buku', value: rupiah(cart.totalPrice)),
                      const Padding(padding: EdgeInsets.symmetric(vertical: 14), child: Divider()),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        const Text('Total Pembayaran', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                        Text(rupiah(cart.totalPrice), style: const TextStyle(fontSize: 19, color: rosePink, fontWeight: FontWeight.w900)),
                      ]),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: cart.totalItems == 0 ? null : () => _checkout(context),
                          icon: const Icon(Icons.lock_outline_rounded, size: 18),
                          label: const Text('Checkout / Bayar Sekarang'),
                          style: FilledButton.styleFrom(backgroundColor: maroon, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16)),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(child: Text('Pembayaran aman • Terima kasih sudah membaca', textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 10, color: Theme.of(context).hintColor))),
                    ]),
                  ),
                ),
              ],
            ),
    );
  }

  void _checkout(BuildContext context) {
    final cart = context.read<CartProvider>();
    if (cart.totalItems == 0) return;
    cart.clearCart();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Row(children: [
        Icon(Icons.check_circle_rounded, color: Color(0xFFB9F6CA)),
        SizedBox(width: 10),
        Expanded(child: Text('Pembayaran berhasil! Terima kasih sudah berbelanja.')),
      ]),
      backgroundColor: Color(0xFF286342),
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 4),
    ));
    Navigator.pop(context);
  }

  void _confirmClear(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Kosongkan keranjang?'),
        content: const Text('Semua buku akan dihapus dari keranjang.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Batal')),
          FilledButton(
            onPressed: () {
              context.read<CartProvider>().clearCart();
              Navigator.pop(dialogContext);
            },
            child: const Text('Kosongkan'),
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;
  const _QuantityButton({required this.icon, required this.onTap, this.filled = false});

  @override
  Widget build(BuildContext context) => Material(
    color: filled ? maroon : const Color(0xFFFFE0EB),
    borderRadius: BorderRadius.circular(9),
    child: InkWell(
      borderRadius: BorderRadius.circular(9),
      onTap: onTap,
      child: SizedBox(
        width: 30, height: 30,
        child: Icon(icon, size: 17, color: filled ? Colors.white : maroon),
      ),
    ),
  );
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryRow({required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
    Text(label, style: TextStyle(color: Theme.of(context).hintColor, fontSize: 13)),
    Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
  ]);
}

class _EmptyCart extends StatelessWidget {
  final VoidCallback onBrowse;
  const _EmptyCart({required this.onBrowse});
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(30),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          width: 130, height: 130,
          decoration: const BoxDecoration(color: Color(0xFFFFE0EB), shape: BoxShape.circle),
          child: const Icon(Icons.shopping_bag_outlined, color: maroon, size: 62),
        ),
        const SizedBox(height: 24),
        const Text('Keranjangmu masih kosong', textAlign: TextAlign.center,
          style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        Text('Yuk temukan buku yang cocok untuk menemani ceritamu.',
          textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).hintColor, height: 1.5)),
        const SizedBox(height: 22),
        FilledButton.icon(
          onPressed: onBrowse,
          icon: const Icon(Icons.auto_stories_rounded),
          label: const Text('Jelajahi Buku'),
          style: FilledButton.styleFrom(backgroundColor: maroon, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14)),
        ),
      ]),
    ),
  );
}

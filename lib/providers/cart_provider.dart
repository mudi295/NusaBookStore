import 'package:flutter/foundation.dart';
import '../models/book.dart';

class CartEntry {
  final Book book;
  int quantity;
  CartEntry({required this.book, this.quantity = 1});
  int get subtotal => book.price * quantity;
}

class CartProvider extends ChangeNotifier {
  final List<CartEntry> _items = [];

  List<CartEntry> get items => List.unmodifiable(_items);
  int get totalItems => _items.fold(0, (sum, item) => sum + item.quantity);
  int get totalPrice => _items.fold(0, (sum, item) => sum + item.subtotal);
  int quantityFor(String bookId) {
    for (final item in _items) {
      if (item.book.id == bookId) return item.quantity;
    }
    return 0;
  }

  void addItem(Book book) {
    final index = _items.indexWhere((item) => item.book.id == book.id);
    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartEntry(book: book));
    }
    notifyListeners();
  }

  void removeItem(String bookId) {
    final index = _items.indexWhere((item) => item.book.id == bookId);
    if (index == -1) return;
    if (_items[index].quantity > 1) {
      _items[index].quantity--;
    } else {
      _items.removeAt(index);
    }
    notifyListeners();
  }

  void removeBook(String bookId) {
    _items.removeWhere((item) => item.book.id == bookId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}

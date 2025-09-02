import 'package:flutter/foundation.dart';
import 'product.dart';

class CartItem {
  final Product p;
  int qty;
  CartItem(this.p, this.qty);
}

class CartModel extends ChangeNotifier {
  final Map<String, CartItem> _items = {}; // key = product.id

  Map<String, CartItem> get items => _items;
  int get totalCount => _items.values.fold(0, (a, e) => a + e.qty);
  double get subtotal => _items.values.fold(0.0, (a, e) => a + e.p.price * e.qty);

  void add(Product p, {int qty = 1}) {
    final curr = _items[p.id];
    if (curr == null) {
      _items[p.id] = CartItem(p, qty);
    } else {
      curr.qty += qty;
    }
    notifyListeners();
  }

  void removeOne(Product p) {
    final curr = _items[p.id];
    if (curr == null) return;
    if (curr.qty > 1) {
      curr.qty--;
    } else {
      _items.remove(p.id);
    }
    notifyListeners();
  }

  void setQty(Product p, int qty) {
    if (qty <= 0) {
      _items.remove(p.id);
    } else {
      final curr = _items[p.id];
      if (curr == null) {
        _items[p.id] = CartItem(p, qty);
      } else {
        curr.qty = qty;
      }
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  List<CartItem> get cartItemList => _items.values.toList();

  int get itemCount => _items.values.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal =>
      _items.values.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get shippingFee => (subtotal > 50.0 || subtotal == 0) ? 0.0 : 4.99;

  double get total => subtotal + shippingFee;

  bool isInCart(String productId) => _items.containsKey(productId);

  int getQuantity(String productId) {
    if (_items.containsKey(productId)) {
      return _items[productId]!.quantity;
    }
    return 0;
  }

  void addToCart(Product product, [int quantity = 1]) {
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (existing) => existing.copyWith(
          quantity: existing.quantity + quantity,
        ),
      );
    } else {
      _items.putIfAbsent(
        product.id,
        () => CartItem(product: product, quantity: quantity),
      );
    }
    notifyListeners();
  }

  void updateQuantity(String productId, int newQuantity) {
    if (!_items.containsKey(productId)) return;

    if (newQuantity <= 0) {
      _items.remove(productId);
    } else {
      _items.update(
        productId,
        (existing) => existing.copyWith(quantity: newQuantity),
      );
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}

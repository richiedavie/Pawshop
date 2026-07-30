import 'package:flutter/foundation.dart';
import '../models/order.dart';
import '../models/cart_item.dart';
import '../data/product_data.dart';

class OrderProvider with ChangeNotifier {
  final List<Order> _orders = [
    Order(
      orderNumber: '#PS-1084',
      items: [
        CartItem(product: ProductData.sampleProducts[0], quantity: 1),
        CartItem(product: ProductData.sampleProducts[2], quantity: 2),
      ],
      total: 60.97,
      placedAt: DateTime.now().subtract(const Duration(days: 3)),
      estimatedDelivery: 'Delivered',
      status: 'Delivered',
    ),
  ];

  List<Order> get orders => List.unmodifiable(_orders);

  void addOrder(Order order) {
    _orders.insert(0, order);
    notifyListeners();
  }
}

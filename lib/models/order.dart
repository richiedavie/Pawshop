import 'cart_item.dart';

class Order {
  final String orderNumber;
  final List<CartItem> items;
  final double total;
  final DateTime placedAt;
  final String estimatedDelivery;
  final String status; // "Processing", "In Transit", "Delivered"

  const Order({
    required this.orderNumber,
    required this.items,
    required this.total,
    required this.placedAt,
    required this.estimatedDelivery,
    this.status = 'Processing',
  });

  int get totalItemCount => items.fold(0, (sum, item) => sum + item.quantity);
}

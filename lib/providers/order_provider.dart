import 'package:flutter/foundation.dart';
import '../models/order.dart';

class OrderProvider with ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders => List.unmodifiable(_orders);

  void addOrder(Order order) {
    _orders.insert(0, order);
    notifyListeners();
  }

  void fetchUserOrders(String userId) {
    // TODO: Fetch user specific orders from Database/Firestore
    // e.g., _orders = await firebaseService.getOrders(userId);
    notifyListeners();
  }

  void clearOrders() {
    _orders.clear();
    notifyListeners();
  }
}

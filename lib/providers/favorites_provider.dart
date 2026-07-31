import 'package:flutter/foundation.dart';
import '../models/product.dart';

class FavoritesProvider with ChangeNotifier {
  final List<Product> _favoriteProducts = [];

  List<Product> get favoriteProducts => List.unmodifiable(_favoriteProducts);

  bool isFavorite(Product product) {
    return _favoriteProducts.any((p) => p.id == product.id);
  }

  void toggleFavorite(Product product) {
    if (isFavorite(product)) {
      _favoriteProducts.removeWhere((p) => p.id == product.id);
    } else {
      _favoriteProducts.add(product);
    }
    notifyListeners();
  }

  void clearFavorites() {
    _favoriteProducts.clear();
    notifyListeners();
  }
}

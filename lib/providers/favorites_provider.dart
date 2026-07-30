import 'package:flutter/foundation.dart';
import '../models/product.dart';

class FavoritesProvider with ChangeNotifier {
  final Set<String> _favoriteIds = {'d1', 'c1'}; // Pre-populate 2 favorites for demo feel

  Set<String> get favoriteIds => {..._favoriteIds};

  bool isFavorite(String productId) => _favoriteIds.contains(productId);

  void toggleFavorite(String productId) {
    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
    } else {
      _favoriteIds.add(productId);
    }
    notifyListeners();
  }

  List<Product> getFavoriteProducts(List<Product> allProducts) {
    return allProducts.where((p) => _favoriteIds.contains(p.id)).toList();
  }
}

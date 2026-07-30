import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/product_data.dart';
import '../providers/favorites_provider.dart';
import '../widgets/empty_state.dart';
import '../widgets/product_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites ❤️'),
      ),
      body: Consumer<FavoritesProvider>(
        builder: (context, favProvider, child) {
          final favoriteProducts =
              favProvider.getFavoriteProducts(ProductData.sampleProducts);

          if (favoriteProducts.isEmpty) {
            return EmptyState(
              icon: '❤️',
              title: 'No Favorites Yet',
              message:
                  'Tap the heart icon on any product to save your favorite pet items for easy access later!',
              buttonText: 'Explore Catalog',
              onButtonPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.68,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: favoriteProducts.length,
            itemBuilder: (context, index) {
              return ProductCard(product: favoriteProducts[index]);
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';
import '../widgets/cart_item_tile.dart';
import '../widgets/empty_state.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart (${cart.itemCount})'),
        actions: [
          if (cart.cartItemList.isNotEmpty)
            TextButton.icon(
              onPressed: () => cart.clearCart(),
              icon: const Icon(Icons.delete_outline, size: 18, color: AppTheme.error),
              label: const Text(
                'Clear',
                style: TextStyle(color: AppTheme.error, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),

      body: cart.cartItemList.isEmpty
          ? EmptyState(
              icon: '🛒',
              title: 'Your Cart is Empty',
              message:
                  'Looks like you haven’t added any delicious treats or fun toys for your pet yet!',
              buttonText: 'Start Shopping',
              onButtonPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
            )
          : Column(
              children: [
                // Free Shipping Progress Indicator
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  color: AppTheme.primaryLight,
                  child: Row(
                    children: [
                      const Text('🚚', style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          cart.subtotal >= 50.0
                              ? 'You unlocked FREE Shipping! 🎉'
                              : 'Add \$${(50.0 - cart.subtotal).toStringAsFixed(2)} more for FREE Shipping!',
                          style: const TextStyle(
                            color: AppTheme.primaryDark,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Cart Item List
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    itemCount: cart.cartItemList.length,
                    itemBuilder: (context, index) {
                      final item = cart.cartItemList[index];
                      return CartItemTile(item: item);
                    },
                  ),
                ),

                // Sticky Bottom Order Summary & Checkout Action
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    boxShadow: AppTheme.cardShadow,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    border: const Border(
                      top: BorderSide(color: AppTheme.border, width: 0.8),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Subtotal',
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '\$${cart.subtotal.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Estimated Delivery',
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            cart.shippingFee == 0
                                ? 'FREE'
                                : '\$${cart.shippingFee.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: cart.shippingFee == 0
                                  ? AppTheme.primary
                                  : AppTheme.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Divider(color: AppTheme.border),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          Text(
                            '\$${cart.total.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: cart.cartItemList.isEmpty
                              ? null
                              : () {
                                  Navigator.pushNamed(context, AppRoutes.checkout);
                                },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('Proceed to Checkout'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

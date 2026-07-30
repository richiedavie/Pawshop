import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../models/order.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../providers/pet_profile_provider.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';
import '../widgets/guest_promo_sheet.dart';

enum PaymentMethod { card, eWallet, cashOnDelivery }

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  PaymentMethod _selectedPayment = PaymentMethod.card;

  final TextEditingController _cardNumberController =
      TextEditingController(text: '4532 •••• •••• 8892');
  final TextEditingController _expiryController =
      TextEditingController(text: '09/28');
  final TextEditingController _cvvController =
      TextEditingController(text: '342');
  final TextEditingController _addressController =
      TextEditingController(text: '123 Pet Lovers Lane, Suite 4B');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.isGuest) {
        GuestPromoSheet.show(
          context,
          title: 'Fast-track Checkout 🛒',
          message: 'Sign in to save your pet\'s profile and fast-track checkout!',
        );
      }
    });
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _placeOrder() {
    final cart = Provider.of<CartProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    if (cart.cartItemList.isEmpty) return;

    final randomId = '#PS-${1000 + Random().nextInt(8999)}';
    final orderTotal = cart.total;
    final itemCount = cart.itemCount;
    final itemsCopy = List.from(cart.cartItemList);

    final newOrder = Order(
      orderNumber: randomId,
      items: itemsCopy.cast(),
      total: orderTotal,
      placedAt: DateTime.now(),
      estimatedDelivery: '2–3 Days',
      status: 'Processing',
    );

    orderProvider.addOrder(newOrder);
    cart.clearCart();

    Navigator.pushReplacementNamed(
      context,
      AppRoutes.orderSuccess,
      arguments: {
        'orderNumber': randomId,
        'itemCount': itemCount,
        'total': orderTotal,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final petProvider = Provider.of<PetProfileProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Delivery Address Section
            Text(
              'Delivery Address 📍',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                border: Border.all(color: AppTheme.border),
                boxShadow: AppTheme.subtleShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: AppTheme.primary, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        petProvider.hasProfile
                            ? '${petProvider.petName}’s Home'
                            : 'Primary Residence',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      labelText: 'Street Address',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Payment Methods Section
            Text(
              'Pay With 💳',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),

            _buildPaymentMethodTile(
              method: PaymentMethod.card,
              icon: Icons.credit_card,
              title: 'Credit / Debit Card',
              subtitle: 'Visa, Mastercard, Amex',
            ),
            const SizedBox(height: 10),
            _buildPaymentMethodTile(
              method: PaymentMethod.eWallet,
              icon: Icons.account_balance_wallet_outlined,
              title: 'E-Wallet (Dummy)',
              subtitle: 'Apple Pay, Google Pay, PayPal',
            ),
            const SizedBox(height: 10),
            _buildPaymentMethodTile(
              method: PaymentMethod.cashOnDelivery,
              icon: Icons.payments_outlined,
              title: 'Cash on Delivery',
              subtitle: 'Pay when your package arrives',
            ),
            const SizedBox(height: 16),

            // Card Input Form (Only visible if Card selected)
            if (_selectedPayment == PaymentMethod.card)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  border: Border.all(color: AppTheme.border),
                  boxShadow: AppTheme.subtleShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Card Details',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _cardNumberController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Card Number',
                        prefixIcon: Icon(Icons.payment),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _expiryController,
                            decoration: const InputDecoration(
                              labelText: 'MM/YY',
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _cvvController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'CVV',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 24),

            // Order Summary Card
            Text(
              'Order Summary 🧾',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                border: Border.all(color: AppTheme.border),
                boxShadow: AppTheme.subtleShadow,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Items (${cart.itemCount})',
                        style: const TextStyle(color: AppTheme.textSecondary),
                      ),
                      Text(
                        '\$${cart.subtotal.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
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
                        style: TextStyle(color: AppTheme.textSecondary),
                      ),
                      const Text(
                        '2–3 Days',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Shipping Fee',
                        style: TextStyle(color: AppTheme.textSecondary),
                      ),
                      Text(
                        cart.shippingFee == 0
                            ? 'FREE'
                            : '\$${cart.shippingFee.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
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
                        'Order Total',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Text(
                        '\$${cart.total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),

      // Sticky Bottom Place Order Button
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          boxShadow: AppTheme.cardShadow,
          border: const Border(top: BorderSide(color: AppTheme.border, width: 0.8)),
        ),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _placeOrder,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: Text('Place Order • \$${cart.total.toStringAsFixed(2)}'),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodTile({
    required PaymentMethod method,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final isSelected = _selectedPayment == method;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPayment = method;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryLight : AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.border,
            width: isSelected ? 1.8 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
              size: 24,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: isSelected ? AppTheme.primaryDark : AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
                  width: 2,
                ),
                color: isSelected ? AppTheme.primary : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

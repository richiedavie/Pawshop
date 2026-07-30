import 'package:flutter/material.dart';
import '../models/product.dart';
import '../screens/auth_wrapper.dart';
import '../screens/welcome_screen.dart';
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/home_screen.dart';
import '../screens/category_screen.dart';
import '../screens/product_detail_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/checkout_screen.dart';
import '../screens/order_success_screen.dart';
import '../screens/favorites_screen.dart';
import '../screens/pet_profile_screen.dart';
import '../screens/order_history_screen.dart';

class AppRoutes {
  static const String authWrapper = '/auth-wrapper';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String signup = '/signup';

  static const String home = '/';
  static const String category = '/category';
  static const String productDetail = '/product-detail';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String orderSuccess = '/order-success';
  static const String favorites = '/favorites';
  static const String petProfile = '/pet-profile';
  static const String orderHistory = '/order-history';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case authWrapper:
        return MaterialPageRoute(builder: (_) => const AuthWrapper());

      case welcome:
        return PageRouteBuilder(
          pageBuilder: (_, animation, secondaryAnimation) => const WelcomeScreen(),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 300),
        );

      case login:
        return PageRouteBuilder(
          pageBuilder: (_, animation, secondaryAnimation) => const LoginScreen(),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeOutCubic;
            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return SlideTransition(position: animation.drive(tween), child: child);
          },
          transitionDuration: const Duration(milliseconds: 300),
        );

      case signup:
        return PageRouteBuilder(
          pageBuilder: (_, animation, secondaryAnimation) => const SignupScreen(),
          transitionsBuilder: (_, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeOutCubic;
            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return SlideTransition(position: animation.drive(tween), child: child);
          },
          transitionDuration: const Duration(milliseconds: 300),
        );

      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case category:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => CategoryScreen(
            initialCategory: args?['category'] as ProductCategory?,
            initialSpecies: args?['species'] as PetSpecies?,
          ),
        );

      case productDetail:
        final product = settings.arguments as Product;
        return MaterialPageRoute(
          builder: (_) => ProductDetailScreen(product: product),
        );

      case cart:
        return MaterialPageRoute(builder: (_) => const CartScreen());

      case checkout:
        return MaterialPageRoute(builder: (_) => const CheckoutScreen());

      case orderSuccess:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => OrderSuccessScreen(
            orderNumber: args?['orderNumber'] ?? '#PS-2847',
            itemCount: args?['itemCount'] ?? 1,
            total: args?['total'] ?? 0.0,
          ),
        );

      case favorites:
        return MaterialPageRoute(builder: (_) => const FavoritesScreen());

      case petProfile:
        return MaterialPageRoute(builder: (_) => const PetProfileScreen());

      case orderHistory:
        return MaterialPageRoute(builder: (_) => const OrderHistoryScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/product_data.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../routes/app_routes.dart';
import '../theme/app_theme.dart';
import '../widgets/category_chip.dart';
import '../widgets/empty_state.dart';
import '../widgets/pet_banner_widget.dart';
import '../widgets/product_card.dart';
import '../widgets/section_header.dart';
import '../widgets/species_toggle.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PetSpecies _selectedSpecies = PetSpecies.dog;
  ProductCategory? _selectedCategory;
  String _searchQuery = '';
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  int _currentNavIndex = 0;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Product> get _filteredProducts {
    return ProductData.sampleProducts.where((product) {
      final matchesSpecies = product.species == _selectedSpecies;
      final matchesCategory = _selectedCategory == null ||
          product.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesSpecies && matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search PawShop...',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  fillColor: Colors.transparent,
                ),
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
              )
            : Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text('🐾', style: TextStyle(fontSize: 18)),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'PawShop',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryDark,
                          letterSpacing: -0.5,
                        ),
                  ),
                ],
              ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search_rounded),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _isSearching = false;
                  _searchQuery = '';
                  _searchController.clear();
                } else {
                  _isSearching = true;
                }
              });
            },
          ),
          Consumer<CartProvider>(
            builder: (context, cart, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_bag_outlined),
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
                  ),
                  if (cart.itemCount > 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppTheme.accent,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${cart.itemCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: CustomScrollView(
        slivers: [
          // Personalized Pet Banner
          const SliverToBoxAdapter(
            child: PetBannerWidget(),
          ),

          // Species Toggle (Dogs / Cats)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SpeciesToggle(
                selectedSpecies: _selectedSpecies,
                onSpeciesChanged: (species) {
                  setState(() {
                    _selectedSpecies = species;
                  });
                },
              ),
            ),
          ),

          // Horizontal Category Chips
          SliverToBoxAdapter(
            child: SizedBox(
              height: 54,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                children: [
                  CategoryChip(
                    label: 'All Items',
                    icon: '✨',
                    isSelected: _selectedCategory == null,
                    onTap: () {
                      setState(() {
                        _selectedCategory = null;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  ...ProductCategory.values.map(
                    (cat) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: CategoryChip(
                        label: cat.displayName,
                        icon: cat.icon,
                        isSelected: _selectedCategory == cat,
                        onTap: () {
                          setState(() {
                            _selectedCategory =
                                _selectedCategory == cat ? null : cat;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Section Header
          SliverToBoxAdapter(
            child: SectionHeader(
              title: _selectedCategory != null
                  ? '${_selectedCategory!.displayName} for ${_selectedSpecies == PetSpecies.dog ? "Dogs" : "Cats"}'
                  : 'Popular ${_selectedSpecies == PetSpecies.dog ? "Dog" : "Cat"} Essentials',
              actionLabel: _selectedCategory != null ? 'Clear Filter' : null,
              onActionTap: () {
                setState(() {
                  _selectedCategory = null;
                });
              },
            ),
          ),

          // Product Grid or Empty State
          if (_filteredProducts.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: EmptyState(
                icon: '🔎',
                title: 'No Products Found',
                message:
                    'We couldn’t find any ${_selectedCategory?.displayName ?? ""} products for ${_selectedSpecies == PetSpecies.dog ? "dogs" : "cats"}.',
                buttonText: 'Reset Filters',
                onButtonPressed: () {
                  setState(() {
                    _selectedCategory = null;
                    _searchQuery = '';
                    _searchController.clear();
                  });
                },
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.68,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = _filteredProducts[index];
                    return ProductCard(product: product);
                  },
                  childCount: _filteredProducts.length,
                ),
              ),
            ),
        ],
      ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.surface,
          border: Border(top: BorderSide(color: AppTheme.border, width: 0.8)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentNavIndex,
          onTap: (index) {
            setState(() {
              _currentNavIndex = index;
            });
            if (index == 1) {
              Navigator.pushNamed(context, AppRoutes.category);
            } else if (index == 2) {
              Navigator.pushNamed(context, AppRoutes.favorites);
            } else if (index == 3) {
              Navigator.pushNamed(context, AppRoutes.petProfile);
            } else if (index == 4) {
              Navigator.pushNamed(context, AppRoutes.orderHistory);
            }
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppTheme.primary,
          unselectedItemColor: AppTheme.textSecondary,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_outlined),
              activeIcon: Icon(Icons.grid_view),
              label: 'Browse',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline),
              activeIcon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.pets_outlined),
              activeIcon: Icon(Icons.pets),
              label: 'Pet Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_shipping_outlined),
              activeIcon: Icon(Icons.local_shipping),
              label: 'Orders',
            ),
          ],
        ),
      ),
    );
  }
}

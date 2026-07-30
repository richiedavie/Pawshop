import 'package:flutter/material.dart';
import '../data/product_data.dart';
import '../models/product.dart';
import '../widgets/category_chip.dart';
import '../widgets/empty_state.dart';
import '../widgets/product_card.dart';
import '../widgets/species_toggle.dart';

class CategoryScreen extends StatefulWidget {
  final ProductCategory? initialCategory;
  final PetSpecies? initialSpecies;

  const CategoryScreen({
    super.key,
    this.initialCategory,
    this.initialSpecies,
  });

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late PetSpecies _selectedSpecies;
  ProductCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedSpecies = widget.initialSpecies ?? PetSpecies.dog;
    _selectedCategory = widget.initialCategory;
  }

  List<Product> get _filteredProducts {
    return ProductData.sampleProducts.where((p) {
      final matchSpecies = p.species == _selectedSpecies;
      final matchCategory =
          _selectedCategory == null || p.category == _selectedCategory;
      return matchSpecies && matchCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedCategory != null
              ? '${_selectedCategory!.displayName} Catalog'
              : 'Browse Categories',
        ),
      ),
      body: Column(
        children: [
          // Species Selector
          Padding(
            padding: const EdgeInsets.all(16),
            child: SpeciesToggle(
              selectedSpecies: _selectedSpecies,
              onSpeciesChanged: (species) {
                setState(() {
                  _selectedSpecies = species;
                });
              },
            ),
          ),

          // Horizontal Category List
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
          const SizedBox(height: 12),

          // Grid View or Empty State
          Expanded(
            child: _filteredProducts.isEmpty
                ? EmptyState(
                    icon: '🐾',
                    title: 'No Matching Items',
                    message:
                        'No products found in this category for ${_selectedSpecies.displayName}.',
                    buttonText: 'Show All Items',
                    onButtonPressed: () {
                      setState(() {
                        _selectedCategory = null;
                      });
                    },
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.68,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      return ProductCard(product: _filteredProducts[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

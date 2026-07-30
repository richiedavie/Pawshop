enum PetSpecies { dog, cat }

enum ProductCategory { food, toys, accessories, grooming, health }

enum DogSize { small, medium, large }

extension PetSpeciesExtension on PetSpecies {
  String get displayName {
    switch (this) {
      case PetSpecies.dog:
        return 'Dog 🐶';
      case PetSpecies.cat:
        return 'Cat 🐱';
    }
  }
}

extension ProductCategoryExtension on ProductCategory {
  String get displayName {
    switch (this) {
      case ProductCategory.food:
        return 'Food';
      case ProductCategory.toys:
        return 'Toys';
      case ProductCategory.accessories:
        return 'Accessories';
      case ProductCategory.grooming:
        return 'Grooming';
      case ProductCategory.health:
        return 'Health';
    }
  }

  String get icon {
    switch (this) {
      case ProductCategory.food:
        return '🍖';
      case ProductCategory.toys:
        return '🦴';
      case ProductCategory.accessories:
        return '🧸';
      case ProductCategory.grooming:
        return '🧼';
      case ProductCategory.health:
        return '💊';
    }
  }
}

class Product {
  final String id;
  final String name;
  final double price;
  final double? originalPrice;
  final PetSpecies species;
  final ProductCategory category;
  final String imagePath;
  final String description;
  final bool isOnSale;
  final bool isNew;
  final DogSize? dogSize;
  final double rating;
  final int reviewsCount;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    this.originalPrice,
    required this.species,
    required this.category,
    required this.imagePath,
    required this.description,
    this.isOnSale = false,
    this.isNew = false,
    this.dogSize,
    this.rating = 4.8,
    this.reviewsCount = 42,
  });

  String get dogSizeLabel {
    if (dogSize == null) return '';
    switch (dogSize!) {
      case DogSize.small:
        return 'Small Breed';
      case DogSize.medium:
        return 'Medium Breed';
      case DogSize.large:
        return 'Large Breed';
    }
  }
}

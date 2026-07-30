import 'product.dart';

class PetProfile {
  final String name;
  final PetSpecies species;
  final String? photoPath;

  const PetProfile({
    required this.name,
    required this.species,
    this.photoPath,
  });

  PetProfile copyWith({
    String? name,
    PetSpecies? species,
    String? photoPath,
  }) {
    return PetProfile(
      name: name ?? this.name,
      species: species ?? this.species,
      photoPath: photoPath ?? this.photoPath,
    );
  }
}

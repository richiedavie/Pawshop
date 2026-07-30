import 'package:flutter/foundation.dart';
import '../models/pet_profile.dart';
import '../models/product.dart';

class PetProfileProvider with ChangeNotifier {
  PetProfile? _activeProfile = const PetProfile(
    name: 'Bella',
    species: PetSpecies.dog,
    photoPath: 'assets/images/pets/pet_dog_avatar.png',
  );

  PetProfile? get activeProfile => _activeProfile;

  bool get hasProfile => _activeProfile != null;

  String get petName => _activeProfile?.name ?? '';

  PetSpecies get selectedSpecies => _activeProfile?.species ?? PetSpecies.dog;

  String get greetingText {
    if (_activeProfile != null && _activeProfile!.name.isNotEmpty) {
      return 'Picked for ${_activeProfile!.name} 🐾';
    }
    return 'Picked for your pet 🐾';
  }

  void setProfile(PetProfile profile) {
    _activeProfile = profile;
    notifyListeners();
  }

  void clearProfile() {
    _activeProfile = null;
    notifyListeners();
  }
}

import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../models/pet_profile.dart';
import '../models/product.dart';
import '../providers/pet_profile_provider.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isGuest => _currentUser?.isGuest ?? false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    await Future.delayed(const Duration(milliseconds: 1500));

    final nameParts = email.split('@');
    String name = 'Pet Lover';
    if (nameParts.isNotEmpty && nameParts[0].isNotEmpty) {
      final rawName = nameParts[0].replaceAll(RegExp(r'[._]'), ' ');
      name = rawName
          .split(' ')
          .map((str) => str.isEmpty ? '' : '${str[0].toUpperCase()}${str.substring(1)}')
          .join(' ');
    }

    _currentUser = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      displayName: name.isNotEmpty ? name : 'Pet Lover',
      isGuest: false,
    );

    _setLoading(false);
    return true;
  }

  Future<bool> signUp(
    String displayName,
    String email,
    String password,
    String? avatarUrl,
    String petName,
    PetSpecies petSpecies,
    String? petPhotoPath,
    PetProfileProvider petProfileProvider,
  ) async {
    _setLoading(true);
    await Future.delayed(const Duration(milliseconds: 1500));

    _currentUser = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      displayName: displayName.trim().isEmpty ? 'Pet Parent' : displayName.trim(),
      avatarUrl: avatarUrl,
      isGuest: false,
    );

    petProfileProvider.setProfile(
      PetProfile(
        name: petName.trim().isEmpty ? 'My Pet' : petName.trim(),
        species: petSpecies,
        photoPath: petPhotoPath,
      ),
    );

    _setLoading(false);
    return true;
  }

  void loginAsGuest() {
    _currentUser = UserModel.guest();
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}

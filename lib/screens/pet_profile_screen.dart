import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/pet_profile.dart';
import '../models/product.dart';
import '../providers/auth_provider.dart';
import '../providers/pet_profile_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/guest_promo_sheet.dart';
import '../widgets/species_toggle.dart';

class PetProfileScreen extends StatefulWidget {
  const PetProfileScreen({super.key});

  @override
  State<PetProfileScreen> createState() => _PetProfileScreenState();
}

class _PetProfileScreenState extends State<PetProfileScreen> {
  late TextEditingController _nameController;
  late PetSpecies _selectedSpecies;
  String? _selectedAvatar;

  final List<String> _avatars = [
    'assets/images/pets/pet_dog_avatar.png',
    'assets/images/pets/pet_cat_avatar.png',
    'assets/images/pets/pet_dog_avatar2.png',
    'assets/images/pets/pet_cat_avatar2.png',
  ];

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<PetProfileProvider>(context, listen: false);
    final profile = provider.activeProfile;

    _nameController = TextEditingController(text: profile?.name ?? 'Bella');
    _selectedSpecies = profile?.species ?? PetSpecies.dog;
    _selectedAvatar = profile?.photoPath ?? _avatars[0];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.isGuest) {
        GuestPromoSheet.show(
          context,
          title: 'Save Your Pet\'s Profile 🐾',
          message: 'Sign in to save your pet\'s profile and fast-track checkout!',
        );
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your pet’s name'),
          backgroundColor: AppTheme.error,
        ),
      );
      return;
    }

    final provider = Provider.of<PetProfileProvider>(context, listen: false);
    provider.setProfile(
      PetProfile(
        name: name,
        species: _selectedSpecies,
        photoPath: _selectedAvatar,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Profile for $name updated! 🐾'),
        backgroundColor: AppTheme.primaryDark,
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.pop(context);
  }

  void _handleLogout() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.logout();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logged out successfully'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Pet Profile 🐾'),
            actions: [
              Consumer<PetProfileProvider>(
                builder: (context, provider, child) {
                  if (!provider.hasProfile) return const SizedBox.shrink();
                  return TextButton(
                    onPressed: () {
                      provider.clearProfile();
                      setState(() {
                        _nameController.clear();
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Pet profile cleared'),
                        ),
                      );
                    },
                    child: const Text(
                      'Remove',
                      style: TextStyle(color: AppTheme.error, fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
              if (authProvider.isAuthenticated)
                IconButton(
                  tooltip: 'Log Out',
                  icon: const Icon(Icons.logout_rounded, color: AppTheme.error),
                  onPressed: _handleLogout,
                ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Description with User Info
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLight,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  ),
                  child: Row(
                    children: [
                      const Text('🐶🐱', style: TextStyle(fontSize: 28)),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          authProvider.isGuest
                              ? 'Tell us about your pet so PawShop can personalize recommendations and greetings!'
                              : 'Hello ${authProvider.currentUser?.displayName}! Manage your pet profile for personalized picks.',
                          style: const TextStyle(
                            color: AppTheme.primaryDark,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Select Avatar
                const Text(
                  'Choose Avatar',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: _avatars.map((path) {
                    final isSelected = _selectedAvatar == path;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedAvatar = path),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? AppTheme.primary : Colors.transparent,
                            width: 3,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 34,
                          backgroundColor: AppTheme.background,
                          backgroundImage: AssetImage(path),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 28),

                // Pet Name Field
                const Text(
                  'Pet Name',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Bella, Milo, Charlie',
                    prefixIcon: Icon(Icons.pets, color: AppTheme.primary),
                  ),
                ),
                const SizedBox(height: 24),

                // Species Segmented Toggle
                const Text(
                  'Species',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                SpeciesToggle(
                  selectedSpecies: _selectedSpecies,
                  onSpeciesChanged: (species) {
                    setState(() {
                      _selectedSpecies = species;
                    });
                  },
                ),
                const SizedBox(height: 36),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Save Pet Profile'),
                  ),
                ),
                const SizedBox(height: 16),

                // Optional Log Out Button at Bottom
                if (authProvider.isAuthenticated)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _handleLogout,
                      icon: const Icon(Icons.logout_rounded, color: AppTheme.error, size: 18),
                      label: const Text(
                        'Log Out',
                        style: TextStyle(color: AppTheme.error),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppTheme.error, width: 1.2),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

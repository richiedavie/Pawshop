import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/pet_profile_provider.dart';
import '../theme/app_theme.dart';
import '../routes/app_routes.dart';

class PetBannerWidget extends StatelessWidget {
  const PetBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<PetProfileProvider, AuthProvider>(
      builder: (context, petProvider, authProvider, child) {
        final profile = petProvider.activeProfile;
        final photoPath = profile?.photoPath;

        String greetingText;
        String subtitleText;

        if (petProvider.hasProfile && profile != null) {
          greetingText = 'Picked for ${profile.name} 🐾';
          subtitleText = 'Top rated products curated for ${profile.name}’s health & happiness';
        } else if (authProvider.isAuthenticated && !authProvider.isGuest) {
          final userName = authProvider.currentUser?.displayName ?? 'User';
          greetingText = 'Welcome back, $userName! 👋';
          subtitleText = 'Set up your pet’s profile to get custom product recommendations!';
        } else {
          greetingText = 'Welcome to PawShop! 👋';
          subtitleText = 'Tap to set up your pet’s profile for custom picks!';
        }

        return GestureDetector(
          onTap: () => Navigator.pushNamed(context, AppRoutes.petProfile),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.primary, AppTheme.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
              boxShadow: AppTheme.subtleShadow,
            ),
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: ClipOval(
                    child: photoPath != null
                        ? Image.asset(
                            photoPath,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, err, st) => const Center(
                              child: Text('🐾', style: TextStyle(fontSize: 26)),
                            ),
                          )
                        : const Center(
                            child: Text('🐾', style: TextStyle(fontSize: 26)),
                          ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.accent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'PERSONALIZED',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        greetingText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitleText,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';

class SpeciesToggle extends StatelessWidget {
  final PetSpecies selectedSpecies;
  final ValueChanged<PetSpecies> onSpeciesChanged;

  const SpeciesToggle({
    super.key,
    required this.selectedSpecies,
    required this.onSpeciesChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusCircular),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildSegment(
              context: context,
              species: PetSpecies.dog,
              label: 'Dogs 🐶',
            ),
          ),
          Expanded(
            child: _buildSegment(
              context: context,
              species: PetSpecies.cat,
              label: 'Cats 🐱',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegment({
    required BuildContext context,
    required PetSpecies species,
    required String label,
  }) {
    final isSelected = selectedSpecies == species;

    return GestureDetector(
      onTap: () => onSpeciesChanged(species),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.radiusCircular),
          boxShadow: isSelected ? AppTheme.subtleShadow : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppTheme.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

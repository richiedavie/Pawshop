import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SocialLoginButton extends StatelessWidget {
  final String label;
  final Widget iconWidget;
  final VoidCallback onPressed;

  const SocialLoginButton({
    super.key,
    required this.label,
    required this.iconWidget,
    required this.onPressed,
  });

  factory SocialLoginButton.google({required VoidCallback onPressed}) {
    return SocialLoginButton(
      label: 'Google',
      iconWidget: Image.network(
        'https://upload.wikimedia.org/wikipedia/commons/5/53/Google_%22G%22_Logo.svg',
        width: 20,
        height: 20,
        errorBuilder: (ctx, err, st) => const Icon(
          Icons.g_mobiledata_rounded,
          color: Color(0xFF4285F4),
          size: 26,
        ),
      ),
      onPressed: onPressed,
    );
  }

  factory SocialLoginButton.apple({required VoidCallback onPressed}) {
    return SocialLoginButton(
      label: 'Apple',
      iconWidget: Icon(
        Icons.apple,
        color: AppTheme.textPrimary,
        size: 22,
      ),
      onPressed: onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: AppTheme.surface,
          foregroundColor: AppTheme.textPrimary,
          side: BorderSide(color: AppTheme.border, width: 1.0),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconWidget,
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

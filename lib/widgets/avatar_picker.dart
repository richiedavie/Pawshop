import 'package:flutter/material.dart';

class AvatarPicker extends StatelessWidget {
  final List<String> avatars;
  final String selectedAvatar;
  final ValueChanged<String> onAvatarSelected;

  const AvatarPicker({
    super.key,
    required this.avatars,
    required this.selectedAvatar,
    required this.onAvatarSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: avatars.length,
        itemBuilder: (context, index) {
          final avatar = avatars[index];
          final isSelected = avatar == selectedAvatar;
          return GestureDetector(
            onTap: () => onAvatarSelected(avatar),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
                  width: 3.0,
                ),
              ),
              child: CircleAvatar(
                radius: 32,
                backgroundImage: AssetImage(avatar),
              ),
            ),
          );
        },
      ),
    );
  }
}

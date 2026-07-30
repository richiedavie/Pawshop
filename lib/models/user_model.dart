class UserModel {
  final String id;
  final String email;
  final String displayName;
  final String? avatarUrl;
  final bool isGuest;

  const UserModel({
    required this.id,
    required this.email,
    required this.displayName,
    this.avatarUrl,
    this.isGuest = false,
  });

  factory UserModel.guest() {
    return const UserModel(
      id: 'guest',
      email: 'guest@pawshop.com',
      displayName: 'Pet Parent',
      isGuest: true,
    );
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? avatarUrl,
    bool? isGuest,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isGuest: isGuest ?? this.isGuest,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'avatarUrl': avatarUrl,
      'isGuest': isGuest,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? '',
      avatarUrl: map['avatarUrl'],
      isGuest: map['isGuest'] ?? false,
    );
  }
}

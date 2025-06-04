class UserPreferences {
  final String activeMode;
  
  const UserPreferences({
    required this.activeMode,
  });
  
  UserPreferences copyWith({
    String? activeMode,
  }) {
    return UserPreferences(
      activeMode: activeMode ?? this.activeMode,
    );
  }
}
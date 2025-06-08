class UserPreferences {
  final String activeModeId;
  
  const UserPreferences({
    required this.activeModeId,
  });
  
  UserPreferences copyWith({
    String? activeModeId,
  }) {
    return UserPreferences(
      activeModeId: activeModeId ?? this.activeModeId,
    );
  }
}
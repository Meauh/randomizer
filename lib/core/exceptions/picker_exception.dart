// === DOMAIN EXCEPTIONS ===
class PickerException implements Exception {
  final String message;
  const PickerException(this.message);

  @override
  String toString() => 'PickerException: $message';
}
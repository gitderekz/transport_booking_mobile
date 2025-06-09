// utils/parsers.dart
double safeParseDouble(dynamic value) {
  try {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) {
      final trimmed = value.trim();
      return double.tryParse(trimmed) ?? 0.0;
    }
  } catch (e) {
    print('BASE PRICE PARSE ERROR: $value');
  }
  return 0.0;
}
int safeParseInt(dynamic value) {
  try {
    return int.parse(value.toString());
  } catch (e) {
    print('Failed to parse int from value: $value');
    return 0;
  }
}

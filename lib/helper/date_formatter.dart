import 'package:intl/intl.dart';

/// Mengonversi string tanggal dari server (yang biasanya dalam format UTC)
/// ke [DateTime] waktu lokal perangkat pengguna (misal WIB UTC+7).
DateTime? parseUtcToLocal(String? dateStr) {
  if (dateStr == null || dateStr.trim().isEmpty) return null;
  final trimmed = dateStr.trim();
  try {
    if (trimmed.endsWith('Z') || trimmed.contains('+')) {
      return DateTime.parse(trimmed).toLocal();
    }
    if (trimmed.contains(' ') || trimmed.contains('T')) {
      final iso = trimmed.contains('T')
          ? trimmed
          : trimmed.replaceFirst(' ', 'T');
      return DateTime.parse('${iso}Z').toLocal();
    }
    return DateTime.parse(trimmed).toLocal();
  } catch (_) {
    try {
      return DateTime.parse(trimmed).toLocal();
    } catch (_) {
      return null;
    }
  }
}

/// Memformat string tanggal UTC ke string tanggal lokal (misal: "30 September 2026")
String formatLocalDate(
  String? dateStr, {
  String pattern = 'dd MMMM yyyy',
  String locale = 'id_ID',
}) {
  final dt = parseUtcToLocal(dateStr);
  if (dt == null) return '-';
  try {
    return DateFormat(pattern, locale).format(dt);
  } catch (_) {
    return DateFormat(pattern).format(dt);
  }
}

/// Memformat string waktu UTC ke string jam lokal (misal: "10:18:53")
String formatLocalTime(String? dateStr, {String pattern = 'HH:mm:ss'}) {
  final dt = parseUtcToLocal(dateStr);
  if (dt == null) return '-';
  return DateFormat(pattern).format(dt);
}

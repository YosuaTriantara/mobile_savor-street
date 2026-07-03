/// Kumpulan validator untuk dipakai di BaseTextField / TextFormField.
/// Semua method mengembalikan `String?` — null berarti valid,
/// sesuai signature `validator` bawaan Flutter form.
class Validator {
  Validator._();

  static String? required(String? value, {String field = 'Field ini'}) {
    if (value == null || value.trim().isEmpty) {
      return '$field wajib diisi';
    }
    return null;
  }

  static String? minLength(String? value, int min, {String field = 'Field ini'}) {
    if (value == null || value.trim().length < min) {
      return '$field minimal $min karakter';
    }
    return null;
  }

  static String? maxLength(String? value, int max, {String field = 'Field ini'}) {
    if (value != null && value.trim().length > max) {
      return '$field maksimal $max karakter';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email wajib diisi';
    final regex = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,}$');
    if (!regex.hasMatch(value.trim())) return 'Format email tidak valid';
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) return 'Nomor HP wajib diisi';
    final regex = RegExp(r'^(\+62|62|0)8[1-9][0-9]{6,10}$');
    if (!regex.hasMatch(value.trim())) return 'Nomor HP tidak valid';
    return null;
  }

  /// Untuk field Table Number di form Order — harus angka positif.
  static String? tableNumber(String? value) {
    if (value == null || value.trim().isEmpty) return 'Nomor meja wajib diisi';
    final n = int.tryParse(value.trim());
    if (n == null || n <= 0) return 'Nomor meja tidak valid';
    return null;
  }

  /// Gabungkan beberapa validator, berhenti di error pertama.
  static String? Function(String?) combine(
    List<String? Function(String?)> validators,
  ) {
    return (value) {
      for (final v in validators) {
        final result = v(value);
        if (result != null) return result;
      }
      return null;
    };
  }
}
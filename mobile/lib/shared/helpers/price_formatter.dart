class PriceFormatter {
  PriceFormatter._();

  static String format(int value) {
    final digits = value.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      final posFromEnd = digits.length - i;
      buffer.write(digits[i]);
      if (posFromEnd > 1 && posFromEnd % 3 == 1) buffer.write('.');
    }
    return buffer.toString();
  }

  static String formatWithPrefix(int value) => 'Rp ${format(value)}';
}

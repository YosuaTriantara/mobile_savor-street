/// Kumpulan path & name route yang dipakai GoRouter di seluruh aplikasi.
/// Setiap fitur baru WAJIB menambahkan constant di sini, jangan hardcode
/// string path di dalam widget/provider.
class AppRoutes {
  AppRoutes._();

  // QR / entry point
  static const String qrScan = '/';
  static const String qrScanName = 'qrScan';

  // Menu
  static const String menu = '/menu';
  static const String menuName = 'menu';

  static const String menuDetail = '/menu/:idMenu';
  static const String menuDetailName = 'menuDetail';

  // Customization
  static const String customization = '/menu/:idMenu/customize';
  static const String customizationName = 'customization';

  // Cart
  static const String cart = '/cart';
  static const String cartName = 'cart';

  // Order
  static const String orderSuccess = '/order/success';
  static const String orderSuccessName = 'orderSuccess';

  // Invoice
  static const String invoice = '/invoice/:idInvoice';
  static const String invoiceName = 'invoice';

  /// Helper untuk build path yang butuh parameter dinamis.
  static String menuDetailPath(int idMenu) => '/menu/$idMenu';
  static String customizationPath(int idMenu) => '/menu/$idMenu/customize';
  static String invoicePath(int idInvoice) => '/invoice/$idInvoice';
}
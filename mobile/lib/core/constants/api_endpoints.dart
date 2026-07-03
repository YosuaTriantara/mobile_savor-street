/// Path endpoint backend (relatif terhadap EnvConfig.baseUrl).
/// Dipakai oleh datasource/repository di masing-masing fitur agar
/// tidak ada string endpoint yang hardcode di luar sini.
class ApiEndpoints {
  ApiEndpoints._();

  static const String tables = '/tables';
  static String tableValidate(String token) => '/tables/validate?token=$token';

  static const String menus = '/menus';
  static String menuDetail(int idMenu) => '/menus/$idMenu';

  static const String orders = '/orders';
  static String orderDetail(int idOrder) => '/orders/$idOrder';
  static String requestBill(int idOrder) => '/orders/$idOrder/request-bill';

  static String invoiceDetail(int idInvoice) => '/invoices/$idInvoice';
}
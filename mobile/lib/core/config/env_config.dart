enum AppEnvironment { development, staging, production }

class EnvConfig {
  EnvConfig._();

  static const String _envString =
      String.fromEnvironment('APP_ENV', defaultValue: 'development');

  static const AppEnvironment environment = _envString == 'production'
      ? AppEnvironment.production
      : _envString == 'staging'
          ? AppEnvironment.staging
          : AppEnvironment.development;

  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://mobile-savor-street.vercel.app/api/v1',
  );

  static const String imageKitUrlEndpoint = String.fromEnvironment(
    'IMAGEKIT_URL',
    defaultValue: 'https://ik.imagekit.io/szggpdpq5/',
  );

  static bool get isProduction => environment == AppEnvironment.production;
  static bool get isStaging => environment == AppEnvironment.staging;
  static bool get isDevelopment => environment == AppEnvironment.development;
}
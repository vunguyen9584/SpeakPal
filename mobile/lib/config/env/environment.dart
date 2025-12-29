/// App Environment Configuration
enum Environment {
  development,
  staging,
  production,
}

class AppEnvironment {
  static Environment _environment = Environment.development;

  /// Set current environment
  static void setEnvironment(Environment env) {
    _environment = env;
  }

  /// Get current environment
  static Environment get environment => _environment;

  /// Check if development
  static bool get isDevelopment => _environment == Environment.development;

  /// Check if staging
  static bool get isStaging => _environment == Environment.staging;

  /// Check if production
  static bool get isProduction => _environment == Environment.production;

  /// Get environment name
  static String get environmentName {
    switch (_environment) {
      case Environment.development:
        return 'Development';
      case Environment.staging:
        return 'Staging';
      case Environment.production:
        return 'Production';
    }
  }
}

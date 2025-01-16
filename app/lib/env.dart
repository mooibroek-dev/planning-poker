enum Env {
  dev,
  prod,
  local;

  String get pocketBaseUrl => switch (this) {
        Env.dev => '',
        Env.prod => '',
        Env.local => 'http://localhost:8091',
      };

  static Env fromEnvironment() {
    const env = String.fromEnvironment('ENV', defaultValue: 'prod');

    return switch (env) {
      'dev' => Env.dev,
      'prod' => Env.prod,
      'local' => Env.local,
      _ => throw Exception('Unknown environment: $env'),
    };
  }
}

enum Env {
  dev,
  prod,
  local;

  String get baseUrl => switch (this) {
        Env.dev => '',
        Env.prod => '',
        Env.local => '',
      };

  String get apiBase => '$baseUrl/api/v1';

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

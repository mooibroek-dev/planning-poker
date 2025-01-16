import 'package:app/domain/entities/entity.dart';

class AppState extends Entity {
  const AppState({
    required this.isLoggedIn,
  });

  final bool isLoggedIn;

  @override
  List<Object?> get props => [isLoggedIn];

  AppState copyWith({
    bool? isLoggedIn,
  }) {
    return AppState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }
}

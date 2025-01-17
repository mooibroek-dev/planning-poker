import 'package:app/core/exceptions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final globalLoadingProvider = StateProvider.autoDispose<bool>((ref) => false);
final globalErrorProvider = StateProvider.autoDispose<DomainException?>((ref) => null);

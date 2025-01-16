import 'dart:async';

import 'package:app/core/exceptions.dart';
import 'package:app/core/functional.dart';
import 'package:app/core/logger.dart';
import 'package:app/domain/providers/global.provider.dart';
import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Used to enable verbose logging of actions, this is useful for debugging and
/// testing. This is disabled by default.
@visibleForTesting
var verboseActionLogging = false;

/// We want to be able to track if an action is triggered or not (e.g. in tests)
/// therefor we create a stream that we can listen to and get the latest action.
/// We can use this to assert actions where triggered and in what order.
@visibleForTesting
final actionTracker = StreamController<IAction<dynamic>>.broadcast();

@visibleForTesting
Stream<IAction<dynamic>> get actionStream => actionTracker.stream;

abstract class IAction<Result> {
  const IAction();

  /// Makes this class callable Event(ref)() or Event(ref).call()
  /// or Event(ref).call() will call the logic contained in this action
  /// This way we can use events directly in onTap / onPressed
  @mustCallSuper
  FutureOr<Result> call() {
    if (verboseActionLogging) {
      debugPrint('Action called: $runtimeType');
    }
    actionTracker.add(this);
    return execute();
  }

  @protected
  FutureOr<Result> execute();

  @mustCallSuper
  void dispose() {
    // So we can cleanup when needed, automatically called when using useEvent
    if (verboseActionLogging) {
      debugPrint('Action disposed: $runtimeType');
    }
  }
}

@immutable
abstract class RefAction<Result> extends IAction<Result> {
  const RefAction(this.ref);

  /// Used to access providers and modify all app state
  @protected
  final WidgetRef ref;

  bool get mounted => ref.context.mounted;

  /// Used to enable and disable loading. With a global default
  AutoDisposeStateProvider<bool> get loadingProvider => globalLoadingProvider;

  AutoDisposeStateProvider<DomainException?> get errorProvider => globalErrorProvider;

  // Provides a helper method to run a callback while loading. If there is
  // an error in the callback, the isLoading will also be set to false.
  Future<T?> withLoading<T>(final Future<T> Function() callback, {final void Function(dynamic)? onError}) async {
    setLoading(true);
    final result = await callback().onError((final error, final stackTrace) {
      Log.w('Error in withLoading', error, stackTrace);
      setLoading(false);
      onError?.call(error);
      return Future.value();
    });
    setLoading(false);
    return result;
  }

  /// Easily set loading via the loadingProvider and if that is
  /// overridden via the child it will call that one via the getter
  @protected
  void setLoading(final bool loading) => update(loadingProvider, loading);

  /// Broadcast the error to the error provider
  @protected
  void setError(final DomainException exceptionMessage) => update(errorProvider, exceptionMessage);

  @protected
  void clearError() => update(errorProvider, null);

  T? handleError<T>(final Maybe<T> value) {
    return value.fold(
      (final error) {
        setError(error);
        return null;
      },
      (final data) {
        clearError();
        return data;
      },
    );
  }

  @protected
  // An update method that will update a StateProvider<Object?> or a AutoDisposeStateProvider<Object?>
  // depending on the type of the provider.
  void update<T>(final ProviderBase<T?> provider, final T? value) {
    if (!mounted) return;

    if (provider is StateProvider<T?>) {
      ref.read(provider.notifier).state = value;
    } else if (provider is AutoDisposeStateProvider<T?>) {
      ref.read(provider.notifier).state = value;
    } else {
      throw Exception('Provider is not a StateProvider or AutoDisposeStateProvider');
    }
  }

  @protected
  T? change<T>(final ProviderBase<T> provider, final T Function(T previous) cb) {
    T? updated;

    if (!ref.context.mounted) return null;

    T updater(final T old) {
      updated = cb(old);
      return updated as T;
    }

    if (provider is StateProvider<T>) {
      ref.read(provider.notifier).update(updater);
    } else if (provider is AutoDisposeStateProvider<T>) {
      ref.read(provider.notifier).update(updater);
    }

    return updated!;
  }

  @protected
  T? read<T>(final ProviderListenable<T> provider) {
    if (!ref.context.mounted) return null;
    return ref.read(provider);
  }
}

class CancelToken {
  bool _isCancelled = false;

  void cancel() => _isCancelled = true;

  bool get isCancelled => _isCancelled;
}

abstract class CancellableAction<T extends Object> extends RefAction<T> {
  CancellableAction(super.ref);

  final _cancelToken = CancelToken();

  void cancel() => _cancelToken.cancel();

  bool get isCancelled => _cancelToken.isCancelled;
}

abstract class DelayedAction<T extends Object> extends CancellableAction<T> {
  DelayedAction(super.ref);

  void delayed([final Duration? duration]) {
    Future.delayed(duration ?? 200.milliseconds, () {
      if (!isCancelled) {
        call();
      }
    });
  }
}

import 'dart:async';

import 'package:app/domain/entities/app_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract class Guard {
  FutureOr<Result> redirect(BuildContext context, GoRouterState router, AppState state);
}

class Result {
  factory Result.next() => Result._(null, GuardResult.next);
  factory Result.redirect(String path) => Result._(path, GuardResult.redirect);
  factory Result.stay() => Result._(null, GuardResult.redirect);

  Result._(this.redirect, this.result);

  final String? redirect;
  final GuardResult result;

  @override
  String toString() {
    return '$result => path: $redirect';
  }
}

enum GuardResult {
  // Ignore this guard, but execute all others
  next,
  // Redirect with given redirect path from guard
  //(null can be given to indicate, stop and dont redirect)
  redirect,
}

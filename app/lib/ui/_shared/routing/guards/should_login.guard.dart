// import 'package:app/domain/entities/app_state.dart';
// import 'package:app/ui/_shared/routing/guards/guard.dart';
// import 'package:app/ui/auth/login.page.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// class ShouldLoginGuard extends Guard {
//   @override
//   Result redirect(BuildContext context, GoRouterState router, AppState state) {
//     final loginPagePath = LoginPage.route.path;
//     final inAuth = router.matchedLocation.startsWith('/auth');

//     if (!state.isLoggedIn && !inAuth) {
//       return Result.redirect(loginPagePath);
//     }

//     return Result.next();
//   }
// }

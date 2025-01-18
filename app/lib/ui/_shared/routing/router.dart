import 'package:app/core/logger.dart';
import 'package:app/main.dart';
import 'package:app/ui/_shared/routing/guards/guard.dart';
import 'package:app/ui/_shared/routing/guards/redirect_if_room_not_ready.dart';
import 'package:app/ui/_shared/routing/guards/redirect_to_room_or_home.dart';
import 'package:app/ui/pages/room/room.page.dart';
import 'package:app/ui/pages/room/room_settings.page.dart';
import 'package:app/ui/pages/room/room_waiting.page.dart';
import 'package:app/ui/pages/welcome.page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

GoRouter createRouter() {
  final routerKey = GlobalKey<NavigatorState>(debugLabel: 'routerKey');

  final guards = <Guard>[
    RedirectToRoomOrHome(),
    RedirectIfRoomNotReady(),
  ];

  final router = GoRouter(
    navigatorKey: routerKey,
    refreshListenable: appStateNotifier,
    routes: [
      WelcomePage.route,
      RoomPage.route,
      RoomSettingsPage.route,
      RoomWaitingPage.route,
    ],
    redirect: (context, router) async {
      final state = appStateNotifier.value;

      for (var guard in guards) {
        final redirect = await guard.redirect(context, router, state);

        Log.v('Guard: ${guard.runtimeType} => ${redirect.result}');
        if (redirect.result == GuardResult.redirect) {
          Log.v('Redirecting to: ${redirect.redirect}');
          return redirect.redirect;
        }
      }

      return null;
    },
  );

  return router;
}

// ignore: non_constant_identifier_names
GoRoute CrossFadeRoute({
  required String path,
  required Widget Function(BuildContext, GoRouterState) builder,
}) {
  return GoRoute(
    path: path,
    pageBuilder: (context, state) => CustomTransitionPage<void>(
      key: state.pageKey,
      child: builder(context, state),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurveTween(curve: Curves.easeIn).animate(animation),
          child: child,
        );
      },
    ),
  );
}

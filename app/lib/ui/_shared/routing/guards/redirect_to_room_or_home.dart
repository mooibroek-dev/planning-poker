import 'dart:async';

import 'package:app/domain/entities/app_state.dart';
import 'package:app/ui/_shared/routing/guards/guard.dart';
import 'package:app/ui/pages/room/room.page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RedirectToRoomOrHome implements Guard {
  @override
  FutureOr<Result> redirect(BuildContext context, GoRouterState router, AppState state) {
    final hasRoom = state.activeRoom != null;
    final inRoom = router.matchedLocation.startsWith('/room');

    // if user is not in room but has room, redirect to room
    if (!inRoom && hasRoom) {
      return Result.redirect(RoomPage.path(state.activeRoom!.id));
    }

    // if user is in room but has no room, redirect to home
    if (inRoom && !hasRoom) {
      return Result.redirect('/');
    }

    return Result.next();
  }
}

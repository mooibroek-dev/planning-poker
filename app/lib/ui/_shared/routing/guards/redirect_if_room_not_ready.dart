import 'dart:async';

import 'package:app/domain/entities/app_state.dart';
import 'package:app/ui/_shared/routing/guards/guard.dart';
import 'package:app/ui/pages/room/room_settings.page.dart';
import 'package:app/ui/pages/room/room_waiting.page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RedirectIfRoomNotReady implements Guard {
  @override
  FutureOr<Result> redirect(BuildContext context, GoRouterState router, AppState state) {
    final hasRoom = state.activeRoom != null;
    final inRoom = router.matchedLocation.startsWith('/room');
    final alreadyWaiting = router.matchedLocation.startsWith('/room/${state.activeRoom?.id}/waiting');

    final roomReady = state.activeRoom?.isReady ?? false;
    final canEdit = state.activeRoom?.canEdit ?? false;

    // If user can edit room and room is not ready, redirect to settings
    if (hasRoom && inRoom) {
      if (!roomReady && canEdit) {
        return Result.redirect(RoomSettingsPage.path(state.activeRoom!.id));
      }

      if (!roomReady && !canEdit && !alreadyWaiting) {
        return Result.redirect(RoomWaitingPage.path(state.activeRoom!.id));
      }
    }

    return Result.next();
  }
}

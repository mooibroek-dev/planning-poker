import 'package:app/domain/entities/room.dart';
import 'package:app/ui/_shared/routing/router.dart';
import 'package:app/ui/pages/room/room_base.page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RoomSettingsPage extends HookConsumerWidget {
  const RoomSettingsPage({super.key, required this.roomId});

  final String roomId;

  static String path(String roomId) => '/room/$roomId/settings';

  static final route = CrossFadeRoute(
    path: '/room/:roomId/settings',
    builder: (_, state) {
      final roomId = state.pathParameters['roomId']!;
      return RoomSettingsPage(roomId: roomId);
    },
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final controller = useState(FRadioSelectGroupController(value: DeckType.standard)).value;
    final isLoading = useState(false);

    return BaseRoomPage(
      roomId: roomId,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Room settings',
                style: TextStyle(fontSize: 36),
              ),
              SizedBox(height: 40),
              Container(
                constraints: BoxConstraints(maxWidth: 300),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _DeckTypeSelection(
                        controller: controller,
                      ),
                      Gap(40),
                      if (isLoading.value) CircularProgressIndicator(),
                      if (!isLoading.value)
                        FButton(
                          label: Text('Save'),
                          onPress: () async {
                            if (formKey.currentState?.validate() == false) {
                              return;
                            }

                            isLoading.value = true;

                            if (!context.mounted) return;

                            context.go('/room/$roomId');

                            isLoading.value = false;
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DeckTypeSelection extends HookConsumerWidget {
  const _DeckTypeSelection({
    required this.controller,
  });

  final FSelectGroupController<DeckType> controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FSelectGroup(
      controller: controller,
      label: Text('Deck type'),
      validator: (value) {
        if (value == null) {
          return 'Deck type is required';
        }
        return null;
      },
      items: [
        FSelectGroupItem.radio(
          value: DeckType.standard,
          label: Text('Standard'),
          description: Text(DeckType.standard.cards.join(', ')),
        ),
        FSelectGroupItem.radio(
          value: DeckType.fibonacci,
          label: Text('Fibonacci'),
          description: Text(DeckType.fibonacci.cards.join(', ')),
        ),
        FSelectGroupItem.radio(
          value: DeckType.tshirt,
          label: Text('T-Shirt'),
          description: Text(DeckType.tshirt.cards.join(', ')),
        ),
        FSelectGroupItem.radio(
          value: DeckType.custom,
          label: Text('Custom'),
          description: Text('Build your own deck'),
        ),
      ],
    );
  }
}

import 'package:app/domain/actions/update_room_settings.action.dart';
import 'package:app/domain/entities/room.dart';
import 'package:app/ui/_shared/routing/router.dart';
import 'package:app/ui/pages/room/room_base.page.dart';
import 'package:app/ui/widgets/icons.dart';
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
    final selectedDeck = useState<DeckType?>(DeckType.standard);
    final customCardsController = useTextEditingController();
    final controller = useMemoized(() {
      final controller = FRadioSelectGroupController(value: DeckType.standard);

      controller.addListener(() {
        selectedDeck.value = controller.values.firstOrNull;
      });

      return controller;
    });
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
                        onDeckCopy: (deckType) {
                          customCardsController.text = deckType.cards.join(',');
                        },
                      ),
                      if (selectedDeck.value == DeckType.custom) ...[
                        Gap(20),
                        FTextField(
                          label: Text('Add card values'),
                          description: Text('Enter comma separated values'),
                          controller: customCardsController,
                          validator: (value) {
                            final cardValues = value?.split(',') ?? [];
                            if (cardValues.length < 2) {
                              return 'Card values are required, add atleast 2 cards';
                            }
                            return null;
                          },
                        ),
                      ],
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

                            final cards = selectedDeck.value == DeckType.custom //
                                ? customCardsController.text.split(',')
                                : selectedDeck.value!.cards;

                            await UpdateRoomSettingsAction(ref, cards).call();

                            isLoading.value = false;

                            if (!context.mounted) return;
                            context.go('/room/$roomId');
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
    required this.onDeckCopy,
  });

  final FSelectGroupController<DeckType> controller;
  final ValueSetter<DeckType> onDeckCopy;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useListenable(controller);

    final isCustom = controller.values.firstOrNull == DeckType.custom;

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
          label: Row(
            children: [
              Expanded(child: Text('Standard')),
              if (isCustom) ...[
                Gap(4),
                PPIcon(
                  icon: FAssets.icons.copy,
                  size: 14,
                  onTap: () => onDeckCopy(DeckType.standard),
                ),
              ],
            ],
          ),
          description: Text(DeckType.standard.cards.join(', ')),
        ),
        FSelectGroupItem.radio(
          value: DeckType.fibonacci,
          label: Row(
            children: [
              Expanded(child: Text('Fibonacci')),
              if (isCustom) ...[
                Gap(4),
                PPIcon(
                  icon: FAssets.icons.copy,
                  size: 14,
                  onTap: () => onDeckCopy(DeckType.fibonacci),
                ),
              ],
            ],
          ),
          description: Text(DeckType.fibonacci.cards.join(', ')),
        ),
        FSelectGroupItem.radio(
          value: DeckType.tshirt,
          label: Row(
            children: [
              Expanded(child: Text('T-shirt')),
              if (isCustom) ...[
                Gap(4),
                PPIcon(
                  icon: FAssets.icons.copy,
                  size: 14,
                  onTap: () => onDeckCopy(DeckType.tshirt),
                ),
              ],
            ],
          ),
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

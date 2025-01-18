import 'package:app/data/services/prefs.service.dart';
import 'package:app/domain/actions/create_or_join_room.action.dart';
import 'package:app/domain/entities/app_state.dart';
import 'package:app/main.dart';
import 'package:app/ui/_shared/hooks/use_prefs.dart';
import 'package:app/ui/_shared/routing/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WelcomePage extends HookConsumerWidget {
  const WelcomePage({super.key});

  static final route = CrossFadeRoute(
    path: '/',
    builder: (_, __) => WelcomePage(),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedUsername = usePrefs(kUsername);
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final isLoading = useState(false);

    final usernameController = useTextEditingController(text: savedUsername.value);
    final roomIdController = useTextEditingController();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Poker that planning!',
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
                    _GeneralInfoSection(
                      usernameController: usernameController,
                      roomIdController: roomIdController,
                    ),
                    Gap(40),
                    if (isLoading.value) CircularProgressIndicator(),
                    if (!isLoading.value)
                      FButton(
                        label: Text('Create'),
                        onPress: () async {
                          if (formKey.currentState?.validate() == false) {
                            return;
                          }

                          isLoading.value = true;
                          savedUsername.value = usernameController.text;

                          final room = await CreateOrJoinRoomAction(ref, roomIdController.text).call();

                          appStateNotifier.value = AppState(activeRoom: room);

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
    );
  }
}

class _GeneralInfoSection extends HookConsumerWidget {
  const _GeneralInfoSection({
    required this.usernameController,
    required this.roomIdController,
  });

  final TextEditingController usernameController;
  final TextEditingController roomIdController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FLabel(
      axis: Axis.vertical,
      label: Text('General'),
      description: Text('Join an existing room or create a new one.'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FTextField(
            hint: 'Your name',
            controller: usernameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Name is required';
              }
              return null;
            },
          ),
          Gap(20),
          FTextField(
            hint: 'Room name',
            controller: roomIdController,
          ),
        ],
      ),
    );
  }
}

import 'package:app/ui/_shared/hooks/use_prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WelcomePage extends HookConsumerWidget {
  const WelcomePage({super.key});

  static final route = GoRoute(path: '/', builder: (_, __) => WelcomePage());

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedUsername = usePrefs('username');
    final usernameController = useTextEditingController(text: savedUsername.value);
    final roomIdController = useTextEditingController();
    final formKey = GlobalKey<FormState>();

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
                      hint: 'Room id',
                      description: Text('Join an existing room or create a new one.'),
                      controller: roomIdController,
                    ),
                    Gap(40),
                    FButton(
                      label: Text('Submit'),
                      onPress: () {
                        if (formKey.currentState?.validate() == false) {
                          return;
                        }

                        savedUsername.value = usernameController.text;
                        final roomId = roomIdController.text.isEmpty ? 'new-room' : roomIdController.text;
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
    );
  }
}

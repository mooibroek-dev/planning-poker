import 'package:app/core/exceptions.dart';
import 'package:app/core/extensions.dart';
import 'package:app/core/l10n.dart';
import 'package:app/data/services/prefs.service.dart';
import 'package:app/domain/providers/global.provider.dart';
import 'package:app/ui/_shared/hooks/use_prefs.dart';
import 'package:app/ui/_shared/routing/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:forui/forui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class App extends HookConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = useRef(createRouter()).value;
    final isDarkModeEnabled = usePrefs(kDarkmodeEnabled, watchStream: true).value.isTrue;

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,

      // * Title
      onGenerateTitle: (context) {
        L10n.init(context);
        return L10n.translate.appName;
      },

      // * Theme
      theme: ThemeData(
        brightness: isDarkModeEnabled ? Brightness.dark : Brightness.light,
      ),

      // * i18n configuration
      localizationsDelegates: [
        ...AppLocalizations.localizationsDelegates,
        ...FLocalizations.localizationsDelegates,
      ],
      supportedLocales: [
        ...AppLocalizations.supportedLocales,
        ...FLocalizations.supportedLocales,
      ],

      // * Router
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,

      builder: (context, child) {
        final baseTheme = isDarkModeEnabled ? FThemes.zinc.dark : FThemes.zinc.light;

        return FTheme(
          data: baseTheme.copyWith(
            accordionStyle: baseTheme.accordionStyle.copyWith(
              titlePadding: EdgeInsets.symmetric(vertical: 8),
            ),
          ),
          child: _ServiceListener(child: child!),
        );
      },
    );
  }
}

class _ServiceListener extends HookConsumerWidget {
  const _ServiceListener({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to global errors and show a snackbar when needed
    ref.listen(globalErrorProvider, (final previous, final DomainException? next) {
      final error = next;
      if (error == null) return;
      if (error == previous) return;

      if (error.type == MessageType.snackBar) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message ?? L10n.translate.unknownError),
          ),
        );
      }
    });

    return child;
  }
}

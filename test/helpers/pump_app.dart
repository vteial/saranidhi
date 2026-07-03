import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saranidhi/l10n/generated/app_localizations.dart';

extension PumpApp on WidgetTester {
  /// Pumps the widget inside a [ProviderScope] and [MaterialApp] with localizations.
  Future<void> pumpApp(Widget widget) {
    return pumpWidget(
      ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: widget),
        ),
      ),
    );
  }
}

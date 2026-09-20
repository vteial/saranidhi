import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:saranidhi/features/cloud_backup/data/pocketbase_sync_transport.dart';
import 'package:saranidhi/features/cloud_backup/providers/practice_sync_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

String _createMockJwt() {
  final header = base64Url
      .encode(utf8.encode(jsonEncode({'alg': 'HS256', 'typ': 'JWT'})))
      .replaceAll('=', '');
  final payload = base64Url
      .encode(utf8.encode(jsonEncode({'exp': 2500000000, 'id': 'u1'})))
      .replaceAll('=', '');
  return '$header.$payload.mock_signature';
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('PracticeSyncProviders — Provider Identity & Auth Tests', () {
    test(
      'practiceSyncTransportProvider returns the SAME instance when userEmail or scopes change',
      () async {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final initialTransport = container.read(practiceSyncTransportProvider);

        // Mutate userEmail
        await container
            .read(practiceSyncConfigProvider.notifier)
            .setUserEmail('testuser@example.com');

        final transportAfterEmail = container.read(practiceSyncTransportProvider);
        expect(
          identical(initialTransport, transportAfterEmail),
          isTrue,
          reason: 'Transport instance must not rebuild on userEmail change',
        );

        // Mutate scope sessions
        await container
            .read(practiceSyncConfigProvider.notifier)
            .setScopeSessions(enabled: false);

        final transportAfterScope = container.read(practiceSyncTransportProvider);
        expect(
          identical(initialTransport, transportAfterScope),
          isTrue,
          reason: 'Transport instance must not rebuild on scope change',
        );
      },
    );

    test(
      'changing serverUrl rebuilds transport but preserves hoisted authStore credentials',
      () async {
        final mockJwt = _createMockJwt();
        final sharedAuthStore = AuthStore()
          ..save(mockJwt, RecordModel({'id': 'u1'}));

        final container = ProviderContainer(
          overrides: [
            practiceSyncAuthStoreProvider.overrideWithValue(sharedAuthStore),
          ],
        );
        addTearDown(container.dispose);

        final initialTransport = container.read(practiceSyncTransportProvider);
        expect(initialTransport.isAuthenticated, isTrue);

        // Change serverUrl
        await container
            .read(practiceSyncConfigProvider.notifier)
            .setServerUrl('https://new-pb.example.com');

        final updatedTransport = container.read(practiceSyncTransportProvider);
        expect(identical(initialTransport, updatedTransport), isFalse);
        expect(
          updatedTransport.isAuthenticated,
          isTrue,
          reason:
              'New transport must retain authenticated state via hoisted authStore',
        );
      },
    );

    test(
      'PracticeSyncNotifier signIn sets state.isAuthenticated true, and signOut sets it false',
      () async {
        final mockJwt = _createMockJwt();
        final mockClient = MockClient((request) async {
          if (request.url.path.contains(
            '/api/collections/users/auth-with-password',
          )) {
            return http.Response(
              jsonEncode({
                'token': mockJwt,
                'record': {
                  'id': 'user-record-id-1',
                  'email': 'usera@gmail.com',
                },
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          }
          return http.Response('Not Found', 404);
        });

        final fakeTransport = PocketBaseSyncTransport(
          baseUrl: 'http://localhost:8090',
          httpClient: mockClient,
        );

        final container = ProviderContainer(
          overrides: [
            practiceSyncTransportProvider.overrideWithValue(fakeTransport),
          ],
        );
        addTearDown(container.dispose);

        final notifier = container.read(practiceSyncNotifierProvider.notifier);

        // 1. Initial state: not authenticated
        expect(
          container.read(practiceSyncNotifierProvider).isAuthenticated,
          isFalse,
        );

        // 2. Sign In
        final success = await notifier.signIn(
          email: 'usera@gmail.com',
          passphrase: 'secretPassphrase',
        );
        expect(success, isTrue);

        final stateAfterSignIn = container.read(practiceSyncNotifierProvider);
        expect(stateAfterSignIn.isAuthenticated, isTrue);
        expect(stateAfterSignIn.isSigningIn, isFalse);
        expect(stateAfterSignIn.errorMessage, isNull);

        // Config email updated
        expect(
          container.read(practiceSyncConfigProvider).userEmail,
          equals('usera@gmail.com'),
        );

        // 3. Sign Out
        await notifier.signOut();

        final stateAfterSignOut = container.read(practiceSyncNotifierProvider);
        expect(stateAfterSignOut.isAuthenticated, isFalse);
        expect(
          container.read(practiceSyncConfigProvider).userEmail,
          isNull,
        );
      },
    );
  });
}

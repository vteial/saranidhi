import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:saranidhi/features/cloud_backup/data/pocketbase_sync_transport.dart';
import 'package:saranidhi/features/cloud_backup/domain/sync_transport.dart';
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
  group('PocketBaseSyncTransport — Web-Safe Transport Tests', () {
    test('isConfigured reports false for empty URL, true for valid URL', () {
      final tEmpty = PocketBaseSyncTransport(baseUrl: '');
      expect(tEmpty.isConfigured, isFalse);

      final tValid = PocketBaseSyncTransport(baseUrl: 'http://localhost:8090');
      expect(tValid.isConfigured, isTrue);
    });

    test(
      'signIn authenticates via mock HTTP client and updates auth status',
      () async {
        final mockJwt = _createMockJwt();
        final mockClient = MockClient((request) async {
          if (request.url.path.contains(
            '/api/collections/users/auth-with-password',
          )) {
            final body = jsonDecode(request.body) as Map<String, dynamic>;
            expect(body['identity'], equals('user@saranidhi.local'));
            expect(body['password'], equals('secretPassphrase'));

            return http.Response(
              jsonEncode({
                'token': mockJwt,
                'record': {
                  'id': 'user-record-id-1',
                  'email': 'user@saranidhi.local',
                },
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          }
          return http.Response('Not Found', 404);
        });

        final transport = PocketBaseSyncTransport(
          baseUrl: 'http://localhost:8090',
          httpClient: mockClient,
        );

        expect(transport.isAuthenticated, isFalse);

        await transport.signIn(
          email: 'user@saranidhi.local',
          passphrase: 'secretPassphrase',
        );

        expect(transport.isAuthenticated, isTrue);

        await transport.signOut();
        expect(transport.isAuthenticated, isFalse);
      },
    );

    test(
      'pull maps remote records into normalized row maps with uuid as cross-device key',
      () async {
        final mockClient = MockClient((request) async {
          if (request.url.path.contains('/api/collections/sessions/records')) {
            return http.Response(
              jsonEncode({
                'page': 1,
                'perPage': 500,
                'totalItems': 1,
                'totalPages': 1,
                'items': [
                  {
                    'id': 'pb_internal_id_101',
                    'uuid': 'drift-session-uuid-1',
                    'ownerId': 'owner-practice-uuid',
                    'timestamp': 1710000000000,
                    'totalDurationMs': 120000,
                    'nostril': 'right',
                    'inhaleLengthMs': 4000,
                    'holdAfterInhaleMs': 16000,
                    'exhaleLengthMs': 8000,
                    'holdAfterExhaleMs': 0,
                    'completedCycles': 4,
                    'notes': 'Great morning breath',
                  },
                ],
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          }

          if (request.url.path.contains('/api/collections/journal/records')) {
            return http.Response(
              jsonEncode({
                'page': 1,
                'perPage': 500,
                'totalItems': 1,
                'totalPages': 1,
                'items': [
                  {
                    'id': 'pb_internal_id_202',
                    'uuid': 'drift-journal-uuid-1',
                    'ownerId': 'owner-practice-uuid',
                    'timestamp': 1710000005000,
                    'expectedFlow': 'left',
                    'actualFlow': 'left',
                    'isAligned': true,
                    'nostril': 'left',
                    'holdDurationMs': 12000,
                  },
                ],
              }),
              200,
              headers: {'content-type': 'application/json'},
            );
          }

          return http.Response('Not Found', 404);
        });

        // Pre-seed authenticated store
        final authStore = AuthStore()
          ..save(_createMockJwt(), RecordModel({'id': 'u1'}));

        final transport = PocketBaseSyncTransport(
          baseUrl: 'http://localhost:8090',
          httpClient: mockClient,
          authStore: authStore,
        );

        final remote = await transport.pull(
          ownerId: 'owner-practice-uuid',
          scopes: {SyncScope.sessions, SyncScope.journal},
        );

        expect(remote.sessions.length, equals(1));
        expect(remote.sessions.first['id'], equals('drift-session-uuid-1'));
        expect(remote.sessions.first['uuid'], equals('drift-session-uuid-1'));
        expect(remote.sessions.first['ownerId'], equals('owner-practice-uuid'));
        expect(remote.sessions.first['totalDurationMs'], equals(120000));
        expect(remote.sessions.first['notes'], equals('Great morning breath'));

        expect(remote.journal.length, equals(1));
        expect(remote.journal.first['id'], equals('drift-journal-uuid-1'));
        expect(remote.journal.first['uuid'], equals('drift-journal-uuid-1'));
        expect(remote.journal.first['isAligned'], isTrue);
        expect(remote.journal.first['holdDurationMs'], equals(12000));
      },
    );

    test('push creates new remote records when not already present', () async {
      final createdBodies = <Map<String, dynamic>>[];

      final mockClient = MockClient((request) async {
        // Querying existing records
        if (request.method == 'GET' &&
            request.url.path.contains('/api/collections/sessions/records')) {
          return http.Response(
            jsonEncode({
              'page': 1,
              'perPage': 500,
              'totalItems': 0,
              'totalPages': 0,
              'items': [],
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }

        // Creating record
        if (request.method == 'POST' &&
            request.url.path.contains('/api/collections/sessions/records')) {
          final body = jsonDecode(request.body) as Map<String, dynamic>;
          createdBodies.add(body);
          return http.Response(
            jsonEncode({'id': 'newly_created_pb_id', ...body}),
            200,
            headers: {'content-type': 'application/json'},
          );
        }

        return http.Response('Not Found', 404);
      });

      final authStore = AuthStore()
        ..save(_createMockJwt(), RecordModel({'id': 'u1'}));

      final transport = PocketBaseSyncTransport(
        baseUrl: 'http://localhost:8090',
        httpClient: mockClient,
        authStore: authStore,
      );

      final localData = RemoteSyncData(
        sessions: [
          {
            'id': 'local-sess-uuid-42',
            'timestamp': 1710000000000,
            'totalDurationMs': 60000,
            'nostril': 'right',
            'inhaleLengthMs': 4000,
            'holdAfterInhaleMs': 8000,
            'exhaleLengthMs': 4000,
            'holdAfterExhaleMs': 0,
            'completedCycles': 2,
          },
        ],
      );

      await transport.push(
        ownerId: 'practice-owner-42',
        local: localData,
        scopes: {SyncScope.sessions},
      );

      expect(createdBodies.length, equals(1));
      expect(createdBodies.first['uuid'], equals('local-sess-uuid-42'));
      expect(createdBodies.first['ownerId'], equals('practice-owner-42'));
    });

    test('SharedPreferencesAuthStore rehydrates saved credentials', () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      final mockJwt = _createMockJwt();
      final savedData = jsonEncode({
        'token': mockJwt,
        'model': {'id': 'u1', 'email': 'user@example.com'},
      });
      SharedPreferences.setMockInitialValues({'pb_auth': savedData});
      final prefs = await SharedPreferences.getInstance();

      final store = SharedPreferencesAuthStore(prefs: prefs);
      final transport = PocketBaseSyncTransport(
        baseUrl: 'http://localhost:8090',
        authStore: store,
      );

      expect(transport.isAuthenticated, isTrue);
      expect(transport.authStore.token, equals(mockJwt));
    });

    test('rehydrateAuth restores authentication when loaded lazily', () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      final mockJwt = _createMockJwt();
      final savedData = jsonEncode({
        'token': mockJwt,
        'model': {'id': 'u1', 'email': 'user@example.com'},
      });
      SharedPreferences.setMockInitialValues({'pb_auth': savedData});

      final store = SharedPreferencesAuthStore(initial: '');
      final transport = PocketBaseSyncTransport(
        baseUrl: 'http://localhost:8090',
        authStore: store,
      );

      expect(transport.isAuthenticated, isFalse);
      final rehydrated = await transport.rehydrateAuth();
      expect(rehydrated, isTrue);
      expect(transport.isAuthenticated, isTrue);
    });
  });
}

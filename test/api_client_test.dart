import 'dart:convert';

import 'package:cv_flutter_amini_tu_ben/api_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('login envoie les identifiants à l’endpoint de comptes', () async {
    late http.Request request;
    final api = HttpCvApi(
      baseUri: Uri.parse('http://localhost/api-test/public/'),
      client: MockClient((value) async {
        request = value;
        return http.Response(
          jsonEncode({
            'success': true,
            'data': {'id': 7, 'email': 'regis@example.com'},
          }),
          200,
        );
      }),
    );

    final account = await api.login('regis@example.com', 'secret123');

    expect(request.method, 'POST');
    expect(request.url.path, '/api-test/public/accounts/login');
    expect(jsonDecode(request.body), {
      'email': 'regis@example.com',
      'password': 'secret123',
    });
    expect(account.id, 7);
    expect(account.email, 'regis@example.com');
  });

  test('inscription crée le compte via l’endpoint dédié', () async {
    late http.Request request;
    final api = HttpCvApi(
      baseUri: Uri.parse('http://localhost/api-test/public'),
      client: MockClient((value) async {
        request = value;
        return http.Response(
          '{"success":true,"data":{"id":"8","email":"nouveau@example.com"}}',
          201,
        );
      }),
    );

    final account = await api.register('nouveau@example.com', 'secret123');

    expect(request.method, 'POST');
    expect(request.url.path, '/api-test/public/accounts/register');
    expect(jsonDecode(request.body), {
      'email': 'nouveau@example.com',
      'password': 'secret123',
    });
    expect(account.id, 8);
  });

  test(
    'les membres utilisent les endpoints CRUD et les champs attendus',
    () async {
      final requests = <http.Request>[];
      final api = HttpCvApi(
        baseUri: Uri.parse('http://localhost/api-test/public'),
        client: MockClient((request) async {
          requests.add(request);
          if (request.method == 'GET') {
            return http.Response(
              jsonEncode({
                'success': true,
                'data': [
                  {
                    'id': 3,
                    'nom': 'MUNYAKATUNZI',
                    'postnom': 'K.',
                    'prenom': 'Alain',
                    'lieu_naissance': 'Goma',
                    'date_naissance': '1970-05-12',
                    'parente': 'Père',
                    'image_url': null,
                  },
                ],
              }),
              200,
            );
          }
          if (request.method == 'DELETE') {
            return http.Response(
              '{"success":true,"message":"Membre supprimé"}',
              200,
            );
          }
          return http.Response(
            jsonEncode({
              'success': true,
              'data': {
                'id': 3,
                ...jsonDecode(request.body) as Map<String, dynamic>,
                'image_url': null,
              },
            }),
            request.method == 'POST' ? 201 : 200,
          );
        }),
      );
      final values = {
        'nom': 'MUNYAKATUNZI',
        'postnom': 'K.',
        'prenom': 'Alain',
        'lieu_naissance': 'Goma',
        'date_naissance': '1970-05-12',
        'parente': 'Père',
      };

      final members = await api.listFamilyMembers();
      expect(members.single.fullName, 'Alain MUNYAKATUNZI K.');
      await api.createFamilyMember(values);
      await api.updateFamilyMember(3, values);
      await api.deleteFamilyMember(3);

      expect(
        requests.map((request) => '${request.method} ${request.url.path}'),
        [
          'GET /api-test/public/famille-membres',
          'POST /api-test/public/famille-membres',
          'PUT /api-test/public/famille-membres/3',
          'DELETE /api-test/public/famille-membres/3',
        ],
      );
      expect(jsonDecode(requests[2].body), values);
    },
  );

  test('les réponses HTTP d’erreur sont exposées comme ApiException', () async {
    final api = HttpCvApi(
      baseUri: Uri.parse('http://localhost/api-test/public'),
      client: MockClient(
        (_) async => http.Response(
          '{"success":false,"message":"Email ou mot de passe incorrect"}',
          401,
        ),
      ),
    );

    await expectLater(
      api.login('regis@example.com', 'incorrect'),
      throwsA(
        isA<ApiException>()
            .having((error) => error.statusCode, 'statusCode', 401)
            .having(
              (error) => error.message,
              'message',
              'Email ou mot de passe incorrect',
            ),
      ),
    );
  });
}

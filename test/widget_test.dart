import 'package:cv_flutter_amini_tu_ben/api_client.dart';
import 'package:cv_flutter_amini_tu_ben/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeCvApi implements CvApi {
  String? registeredEmail;

  final members = <FamilyMember>[
    const FamilyMember(
      id: 1,
      nom: 'MUNYAKATUNZI',
      postnom: '',
      prenom: 'Alain',
      lieuNaissance: 'Goma',
      dateNaissance: '1970-05-12',
      parente: 'Père',
    ),
    const FamilyMember(
      id: 2,
      nom: 'MUNYAKATUNZI',
      postnom: '',
      prenom: 'Grace',
      lieuNaissance: 'Bukavu',
      dateNaissance: '1975-02-14',
      parente: 'Mère',
    ),
  ];

  @override
  Future<ApiAccount> login(String email, String password) async {
    if (email != 'regis@example.com' || password != 'secret123') {
      throw const ApiException(
        'Email ou mot de passe incorrect',
        statusCode: 401,
      );
    }
    return const ApiAccount(id: 1, email: 'regis@example.com');
  }

  @override
  Future<ApiAccount> register(String email, String password) async {
    registeredEmail = email;
    return ApiAccount(id: 2, email: email);
  }

  @override
  Future<List<FamilyMember>> listFamilyMembers() async => List.of(members);

  @override
  Future<FamilyMember> createFamilyMember(Map<String, String> values) async {
    final member = FamilyMember(
      id: members.length + 1,
      nom: values['nom']!,
      postnom: values['postnom']!,
      prenom: values['prenom']!,
      lieuNaissance: values['lieu_naissance']!,
      dateNaissance: values['date_naissance']!,
      parente: values['parente']!,
    );
    members.add(member);
    return member;
  }

  @override
  Future<FamilyMember> updateFamilyMember(
    int id,
    Map<String, String> values,
  ) async {
    final index = members.indexWhere((member) => member.id == id);
    final member = FamilyMember(
      id: id,
      nom: values['nom']!,
      postnom: values['postnom']!,
      prenom: values['prenom']!,
      lieuNaissance: values['lieu_naissance']!,
      dateNaissance: values['date_naissance']!,
      parente: values['parente']!,
    );
    members[index] = member;
    return member;
  }

  @override
  Future<void> deleteFamilyMember(int id) async {
    members.removeWhere((member) => member.id == id);
  }
}

void main() {
  testWidgets('connexion API requise avant la navigation', (
    WidgetTester tester,
  ) async {
    final api = _FakeCvApi();
    await tester.pumpWidget(CvApp(api: api));

    expect(find.text('Bienvenue'), findsOneWidget);
    expect(find.text('Se connecter'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(
      tester
          .widget<TextField>(
            find.descendant(
              of: find.byType(TextFormField).last,
              matching: find.byType(TextField),
            ),
          )
          .obscureText,
      isTrue,
    );

    await tester.enterText(
      find.byType(TextFormField).first,
      'wrong@example.com',
    );
    await tester.enterText(find.byType(TextFormField).last, 'incorrect');
    await _tapWhenVisible(tester, find.text('Se connecter'));
    expect(find.text('Email ou mot de passe incorrect'), findsOneWidget);
    expect(find.text('Mon CV'), findsNothing);

    await tester.enterText(
      find.byType(TextFormField).first,
      'regis@example.com',
    );
    await tester.enterText(find.byType(TextFormField).last, 'secret123');
    await _tapWhenVisible(tester, find.text('Se connecter'));

    expect(find.text('Mon CV'), findsWidgets);
    expect(find.text('Regis MUNYAKATUNZI'), findsOneWidget);

    await _tapWhenVisible(tester, find.text('Ma famille').last);
    expect(find.text('Les personnes qui comptent'), findsOneWidget);
    expect(find.text('Alain MUNYAKATUNZI'), findsOneWidget);
    expect(find.text('Grace MUNYAKATUNZI'), findsOneWidget);
    expect(find.byType(Image), findsNothing);
  });

  testWidgets('inscription passe par l’API avant d’ouvrir le CV', (
    WidgetTester tester,
  ) async {
    final api = _FakeCvApi();
    await tester.pumpWidget(CvApp(api: api));

    await _tapWhenVisible(tester, find.text('Créer un compte'));
    await tester.enterText(
      find.byType(TextFormField).first,
      'nouveau@example.com',
    );
    await tester.enterText(find.byType(TextFormField).last, 'secret123');
    await _tapWhenVisible(tester, find.text('Créer mon compte'));

    expect(find.text('Mon CV'), findsWidgets);
    expect(api.registeredEmail, 'nouveau@example.com');
  });
}

Future<void> _tapWhenVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

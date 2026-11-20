import 'package:cv_flutter_amini_tu_ben/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('connexion puis navigation entre les rubriques', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CvApp());

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

    await tester.enterText(find.byType(TextFormField).first, 'amini');
    await tester.enterText(find.byType(TextFormField).last, 'ben2026');
    await tester.tap(find.text('Se connecter'));
    await tester.pumpAndSettle();

    expect(find.text('Mon CV'), findsWidgets);
    expect(find.text('Regis MUNYAKATUNZI'), findsOneWidget);

    await tester.tap(find.text('Ma famille').last);
    await tester.pumpAndSettle();
    expect(find.text('Les personnes qui comptent'), findsOneWidget);
    expect(find.text('Alain MUNYAKATUNZI'), findsOneWidget);
    expect(find.text('Grace MUNYAKATUNZI'), findsOneWidget);
    expect(find.byType(Image), findsNothing);

    await tester.tap(find.text('Contact').last);
    await tester.pumpAndSettle();
    expect(find.text('Restons en contact'), findsOneWidget);
    expect(find.text('regis.munyakatunzi@example.com'), findsOneWidget);
  });
}

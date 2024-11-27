import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_project_q1/main.dart';
import 'package:flutter_project_q1/repositories/auth_repository.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Créez un AuthRepository factice.
    final mockAuthRepository = AuthRepository();

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      RepositoryProvider<AuthRepository>.value(
        value: mockAuthRepository,
        child: MyApp(authRepository: mockAuthRepository),
      ),
    );

    // Vérifiez que le compteur commence à 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Appuyez sur l'icône "+" et déclenchez une nouvelle image.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Vérifiez que le compteur a été incrémenté.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}

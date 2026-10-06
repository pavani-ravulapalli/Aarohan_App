import 'package:aarohan_app/screens/countdown_screen.dart';
import 'package:aarohan_app/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Splash should navigate to countdown before dashboard', (tester) async {
    tester.view.physicalSize = const Size(411, 914);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const MaterialApp(home: Splash()));
    await tester.pump(const Duration(seconds: 2));
    await tester.pump();

    expect(find.byType(CountdownScreen), findsOneWidget);
  });
}

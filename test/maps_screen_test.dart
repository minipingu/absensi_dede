import 'package:absensi_kopdes/absensi/riverpod/map_refresh.dart';
import 'package:absensi_kopdes/absensi/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';

void main() {
  testWidgets(
    'BottomNavBar contains all 5 icons including map and alarm icons',
    (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Center(child: Text('Test')),
              bottomNavigationBar: BottomNavBar(),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.byIcon(FLucideIcons.home), findsOneWidget);
      expect(find.byIcon(FLucideIcons.map), findsOneWidget);
      expect(find.byIcon(FLucideIcons.alarmClock), findsOneWidget);
      expect(find.byIcon(FLucideIcons.clockCheck), findsOneWidget);
      expect(find.byIcon(FLucideIcons.user2), findsOneWidget);
    },
  );

  test('mapRefreshTriggerProvider increments on trigger()', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(mapRefreshTriggerProvider), 0);

    container.read(mapRefreshTriggerProvider.notifier).trigger();
    expect(container.read(mapRefreshTriggerProvider), 1);

    container.read(mapRefreshTriggerProvider.notifier).trigger();
    expect(container.read(mapRefreshTriggerProvider), 2);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildBanner(String name) {
    return MaterialApp(
      home: Scaffold(
        body: ListView(
          children: [
            ClipRRect(
              key: const ValueKey('banner_clip_rrect'),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                key: const ValueKey('banner_container'),
                width: double.infinity,
                constraints: const BoxConstraints(minHeight: 220),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        key: const ValueKey('banner_bg'),
                        color: Colors.blue,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Halo Selamat Malam,',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            name,
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              height: 1.15,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Container(
                            key: const ValueKey('clock_box'),
                            width: 120,
                            height: 30,
                            color: Colors.green,
                          ),
                          const Text(
                            '02 Oktober 2026',
                            key: ValueKey('date_text'),
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  testWidgets('Home banner expands when name has multiple lines', (
    tester,
  ) async {
    // 1. Single line name
    await tester.pumpWidget(buildBanner('Gibrun'));
    await tester.pumpAndSettle();

    final singleLineBox = tester.renderObject<RenderBox>(
      find.byKey(const ValueKey('banner_container')),
    );
    final singleLineHeight = singleLineBox.size.height;
    expect(singleLineHeight, greaterThanOrEqualTo(220.0));

    // 2. Multi-line name
    await tester.pumpWidget(
      buildBanner('Gibrun jaya jaya\nuhuyyy ululululu\nbejir'),
    );
    await tester.pumpAndSettle();

    final multiLineBox = tester.renderObject<RenderBox>(
      find.byKey(const ValueKey('banner_container')),
    );
    final multiLineHeight = multiLineBox.size.height;

    // Multi-line banner must expand and be strictly taller than single line banner
    expect(multiLineHeight, greaterThan(singleLineHeight));

    // Verify clock and date are inside the banner bounds
    final bannerRect =
        multiLineBox.localToGlobal(Offset.zero) & multiLineBox.size;
    final clockBox = tester.renderObject<RenderBox>(
      find.byKey(const ValueKey('clock_box')),
    );
    final clockRect = clockBox.localToGlobal(Offset.zero) & clockBox.size;
    final dateBox = tester.renderObject<RenderBox>(
      find.byKey(const ValueKey('date_text')),
    );
    final dateRect = dateBox.localToGlobal(Offset.zero) & dateBox.size;

    expect(bannerRect.contains(clockRect.topLeft), isTrue);
    expect(bannerRect.contains(clockRect.bottomRight), isTrue);
    expect(bannerRect.contains(dateRect.topLeft), isTrue);
    expect(bannerRect.contains(dateRect.bottomRight), isTrue);
  });
}

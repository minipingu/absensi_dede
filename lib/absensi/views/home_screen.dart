import 'package:absensi_dede/absensi/riverpod/theme.dart';
import 'package:absensi_dede/absensi/riverpod/user_riverpod.dart';
import 'package:absensi_dede/absensi/widgets/bottom_nav_bar.dart';
import 'package:absensi_dede/absensi/widgets/check_in_button.dart';
import 'package:absensi_dede/absensi/widgets/check_out_button.dart';
import 'package:absensi_dede/absensi/widgets/sheet_attend.dart';
import 'package:absensi_dede/absensi/widgets/theme_toggle_switch.dart';
import 'package:absensi_dede/absensi/controllers/history_absen.dart';
import 'package:absensi_dede/extension.dart';
import 'package:absensi_dede/helper/greetings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:intl/intl.dart';
import 'package:one_clock/one_clock.dart';

class HomeScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final typography = context.theme.typography;
    final themeState = ref.watch(themeProvider).value ?? false;
    final userName = ref.watch(userNameRiverpod);

    final salam = DateTime.now().greetingMessage;

    final historyState = ref.watch(historyAbsenProvider);

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              themeState
                  ? 'assets/images/kopdes_gunung_malam.png'
                  : 'assets/images/kopdes_gunung.png',
              fit: .cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: [
                Column(
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadiusGeometry.circular(20),
                          child: Image.asset(
                            themeState
                                ? 'assets/images/banner_kopdes_malam.png'
                                : 'assets/images/banner_kopdes.png',
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsGeometry.all(20),
                          child: Column(
                            crossAxisAlignment: .start,
                            children: [
                              Text(
                                'Halo $salam,',
                                style: typography.body.lg.copyWith(
                                  fontWeight: .w600,
                                  fontSize: 20,
                                ),
                              ),
                              Transform.translate(
                                offset: const Offset(0, -10),
                                child: userName.when(
                                  loading: () => const SizedBox(
                                    width: 14,
                                    height: 14,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  error: (err, stack) =>
                                      Text('Guest', style: typography.body.lg),
                                  data: (name) => Text(
                                    name?.capitalize() ?? 'Guest',
                                    textAlign: .start,
                                    style: typography.body.lg.copyWith(
                                      fontWeight: .w700,
                                      fontSize: 30,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black,
                                          blurRadius: 4,
                                          offset: (Offset(1, 1)),
                                        ),
                                      ],
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 60),
                              Container(
                                decoration: BoxDecoration(),
                                width: 120,
                                height: 30,
                                child: FittedBox(
                                  fit: .contain,
                                  child: DigitalClock(
                                    textScaleFactor: 0.6,
                                    format: "HH:mm:ss",
                                    textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black,
                                          blurRadius: 10,
                                        ),
                                      ],
                                    ),
                                    showSeconds: false,
                                    isLive: true,
                                  ),
                                ),
                              ),
                              Text(
                                DateFormat(
                                  'dd MMMM yyyy',
                                  'id_ID',
                                ).format(DateTime.now()),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(color: Colors.black, blurRadius: 10),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: ThemeToggleButton(),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                FCard(
                  style: .delta(
                    decoration: .boxDelta(
                      color: context.theme.colors.background.withValues(
                        alpha: 0.6,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsetsGeometry.all(20),
                    child: Column(
                      spacing: 10,
                      children: [
                        Text(
                          'Kehadiran ${userName.value}',
                          style: typography.body.lg.copyWith(
                            fontWeight: .w700,
                            fontSize: 24,
                          ),
                        ),
                        historyState.when(
                          data: (history) {
                            final items = history?.data;
                            if (items == null || items.isEmpty) {
                              return Center(
                                child: Text(
                                  'Belum ada riwayat kehadiran!',
                                  style: typography.body.lg.copyWith(
                                    fontWeight: .w500,
                                    fontSize: 16,
                                    fontStyle: .italic,
                                  ),
                                ),
                              );
                            }
                            return ListView.separated(
                              shrinkWrap: true,
                              itemCount: items.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                final item = items[index];

                                final date = DateTime.parse(
                                  item.checkIn?.split(' ')[0] ?? "",
                                );
                                final formatted = DateFormat(
                                  'dd MMMM yyyy',
                                  'id_ID',
                                ).format(date);

                                return FTile(
                                  onPress: () {
                                    showFSheet(
                                      context: context,
                                      side: .btt,
                                      builder: (context) =>
                                          SheetAttend(side: .btt),
                                    );
                                  },
                                  title: Text(
                                    '${item.status?.capitalize()} $formatted',
                                  ),
                                  subtitle: Text(
                                    'Jam: ${item.checkIn?.split(' ')[1] ?? '-'}',
                                    style: typography.body.lg.copyWith(
                                      fontWeight: .w500,
                                      fontSize: 16,
                                    ),
                                  ),
                                  suffix: Icon(FLucideIcons.chevronRight),
                                );
                              },
                            );
                          },
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (err, stack) => Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  err.toString(),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton(
                                  onPressed: () => ref
                                      .read(historyAbsenProvider.notifier)
                                      .refresh(),
                                  child: const Text('Coba Lagi'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        CheckInButton(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}

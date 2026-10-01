import 'package:absensi_dede/absensi/riverpod/bottom_nav.dart';
import 'package:absensi_dede/absensi/riverpod/theme.dart';
import 'package:absensi_dede/absensi/riverpod/user_riverpod.dart';
import 'package:absensi_dede/absensi/models/absen/history_absen_response_model.dart';
import 'package:absensi_dede/absensi/services/app_permission_service.dart';
import 'package:absensi_dede/absensi/widgets/bottom_nav_bar.dart';
import 'package:absensi_dede/absensi/widgets/check_in_button.dart';
import 'package:absensi_dede/absensi/widgets/checkout_alarm_widget.dart';
import 'package:absensi_dede/absensi/widgets/home_map_widget.dart';
import 'package:absensi_dede/absensi/widgets/izin_button.dart';
import 'package:absensi_dede/absensi/riverpod/selected_attendance.dart';
import 'package:absensi_dede/absensi/router/routes.dart';
import 'package:absensi_dede/absensi/widgets/theme_toggle_switch.dart';
import 'package:absensi_dede/absensi/controllers/history_absen.dart';
import 'package:absensi_dede/extension.dart';
import 'package:absensi_dede/helper/date_formatter.dart';
import 'package:absensi_dede/helper/greetings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:intl/intl.dart';
import 'package:one_clock/one_clock.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(userNameRiverpod);
      ref.invalidate(historyAbsenProvider);
      _checkPermissions();
    });
  }

  /// Request semua permission saat home screen pertama kali dibuka.
  Future<void> _checkPermissions() async {
    final report = await AppPermissionService.checkAndRequestAll();

    if (!mounted) return;

    // Jika permission utama ditolak permanen, tampilkan dialog
    if (!report.allPermissionsGranted) {
      await AppPermissionService.showPermissionDeniedDialog(context);
    }
    // Jika battery optimization masih aktif, tampilkan dialog penjelasan
    else if (!report.batteryOptimizationDisabled) {
      await AppPermissionService.showBatteryOptimizationDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<int>(bottomNavProvider, (previous, next) {
      if (next == 0) {
        ref.invalidate(userNameRiverpod);
        ref.invalidate(historyAbsenProvider);
      }
    });

    final typography = context.theme.typography;
    final themeState = ref.watch(themeProvider).value ?? false;
    final userName = ref.watch(userNameRiverpod);

    final salam = DateTime.now().greetingMessage;

    final historyState = ref.watch(historyAbsenProvider);

    final now = DateTime.now();
    Data? todayAttendance;
    final historyItems = historyState.value?.data;
    if (historyItems != null) {
      for (final item in historyItems) {
        final itemDate = item.checkIn != null
            ? parseUtcToLocal(item.checkIn)
            : item.createdAt?.toLocal();
        if (itemDate != null &&
            itemDate.year == now.year &&
            itemDate.month == now.month &&
            itemDate.day == now.day) {
          todayAttendance = item;
          break;
        }
      }
    }

    final hasIzinToday =
        todayAttendance != null &&
        (todayAttendance.status == 'izin' ||
            (todayAttendance.alasanIzin != null &&
                todayAttendance.alasanIzin.toString().trim().isNotEmpty));

    final hasCheckInToday =
        todayAttendance != null &&
        todayAttendance.checkIn != null &&
        todayAttendance.checkIn!.isNotEmpty &&
        !hasIzinToday;

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

                                final formattedDate = formatLocalDate(
                                  item.checkIn,
                                );
                                final formattedTime = formatLocalTime(
                                  item.checkIn,
                                );

                                return FTile(
                                  onPress: () {
                                    ref
                                        .read(
                                          selectedAttendanceIdProvider.notifier,
                                        )
                                        .select(item.id);
                                    ref
                                        .read(bottomNavProvider.notifier)
                                        .setIndex(2);
                                    AttendanceListRoute().go(context);
                                  },
                                  title: Text(formattedDate),
                                  subtitle: Text(
                                    '${item.status?.capitalize()} Jam: $formattedTime',
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
                        CheckInButton(
                          isReadOnly: hasIzinToday,
                          readOnlyText: 'Check In (Sudah Izin)',
                        ),
                        Row(
                          children: [
                            const Expanded(
                              child: FDivider(
                                style: .delta(padding: .value(.zero)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: Text(
                                'atau',
                                style: typography.body.sm.copyWith(
                                  color: context.theme.colors.mutedForeground,
                                ),
                              ),
                            ),
                            const Expanded(
                              child: FDivider(
                                style: .delta(padding: .value(.zero)),
                              ),
                            ),
                          ],
                        ),
                        IzinButton(
                          isReadOnly: hasCheckInToday || hasIzinToday,
                          readOnlyText: hasIzinToday
                              ? 'Sudah Mengajukan Izin'
                              : (hasCheckInToday
                                    ? 'Buat Ijin (Sudah Check In)'
                                    : null),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const CheckoutAlarmWidget(),
                const SizedBox(height: 20),
                const HomeMapWidget(),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}

import 'package:absensi_dede/absensi/controllers/history_absen.dart';
import 'package:absensi_dede/absensi/models/absen/history_absen_response_model.dart';
import 'package:absensi_dede/absensi/riverpod/selected_attendance.dart';
import 'package:absensi_dede/absensi/riverpod/theme.dart';
import 'package:absensi_dede/absensi/services/maps_service.dart';
import 'package:absensi_dede/absensi/widgets/bottom_nav_bar.dart';
import 'package:absensi_dede/absensi/widgets/check_out_button.dart';
import 'package:absensi_dede/absensi/widgets/delete_presensi_button.dart';
import 'package:absensi_dede/extension.dart';
import 'package:absensi_dede/helper/date_formatter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AttendanceListScreen extends ConsumerWidget {
  const AttendanceListScreen({super.key});

  double? _parseDouble(dynamic val) {
    if (val == null) return null;
    if (val is num) return val.toDouble();
    if (val is String) return double.tryParse(val.trim());
    return null;
  }

  LatLng? _getCheckInLatLng(Data item) {
    if (item.checkInLat != null && item.checkInLng != null) {
      return LatLng(item.checkInLat!, item.checkInLng!);
    }
    if (item.checkInLocation != null && item.checkInLocation!.contains(',')) {
      final parts = item.checkInLocation!.split(',');
      if (parts.length >= 2) {
        final lat = double.tryParse(parts[0].trim());
        final lng = double.tryParse(parts[1].trim());
        if (lat != null && lng != null) {
          return LatLng(lat, lng);
        }
      }
    }
    return null;
  }

  LatLng? _getCheckOutLatLng(Data item) {
    final lat = _parseDouble(item.checkOutLat);
    final lng = _parseDouble(item.checkOutLng);
    if (lat != null && lng != null) {
      return LatLng(lat, lng);
    }
    if (item.checkOutLocation != null &&
        item.checkOutLocation.toString().contains(',')) {
      final parts = item.checkOutLocation.toString().split(',');
      if (parts.length >= 2) {
        final pLat = double.tryParse(parts[0].trim());
        final pLng = double.tryParse(parts[1].trim());
        if (pLat != null && pLng != null) {
          return LatLng(pLat, pLng);
        }
      }
    }
    return null;
  }

  bool _hasCheckOut(Data item) {
    return (item.checkOut != null && item.checkOut.toString().isNotEmpty) ||
        (item.checkOutAddress != null &&
            item.checkOutAddress.toString().isNotEmpty) ||
        (item.checkOutLocation != null &&
            item.checkOutLocation.toString().isNotEmpty);
  }

  Widget _buildMapSection({
    required BuildContext context,
    required String markerTitle,
    required LatLng? latLng,
    required String address,
    String? timeText,
  }) {
    final typography = context.theme.typography;
    final colors = context.theme.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (timeText != null && timeText.isNotEmpty) ...[
          Row(
            children: [
              Icon(FLucideIcons.clock, size: 14, color: colors.mutedForeground),
              const SizedBox(width: 6),
              Text(
                timeText,
                style: typography.body.sm.copyWith(
                  color: colors.mutedForeground,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(FLucideIcons.mapPin, size: 16, color: Colors.red),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                address.isNotEmpty ? address : 'Tidak ada alamat tercatat',
                style: typography.body.md,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (latLng != null) ...[
          Container(
            height: 190,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.border),
            ),
            clipBehavior: Clip.antiAlias,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(target: latLng, zoom: 15.0),
              markers: {
                Marker(
                  markerId: MarkerId(markerTitle),
                  position: latLng,
                  infoWindow: InfoWindow(title: markerTitle, snippet: address),
                ),
              },
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer(),
                ),
              },
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: true,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Lat: ${latLng.latitude.toStringAsFixed(5)}, Lng: ${latLng.longitude.toStringAsFixed(5)}',
                style: typography.body.xs.copyWith(
                  color: colors.mutedForeground,
                ),
              ),
              GestureDetector(
                onTap: () {
                  final url = MapsService().getGoogleMapsUrl(
                    latLng.latitude,
                    latLng.longitude,
                  );
                  showFToast(
                    context: context,
                    title: const Text('Tautan Google Maps'),
                    description: Text(url.toString()),
                    icon: const Icon(Icons.map_outlined),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Tautan Maps',
                      style: typography.body.xs.copyWith(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.open_in_new,
                      size: 12,
                      color: Colors.blueAccent,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ] else ...[
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colors.muted.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.border),
            ),
            child: Row(
              children: [
                Icon(
                  FLucideIcons.mapPinOff,
                  size: 20,
                  color: colors.mutedForeground,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Koordinat peta tidak tersedia.',
                    style: typography.body.sm.copyWith(
                      color: colors.mutedForeground,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildIzinSection({
    required BuildContext context,
    required Data activeItem,
  }) {
    final typography = context.theme.typography;
    final colors = context.theme.colors;
    final hasIzin =
        activeItem.alasanIzin != null &&
        activeItem.alasanIzin.toString().trim().isNotEmpty;

    if (hasIzin) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                FLucideIcons.fileText,
                size: 16,
                color: colors.mutedForeground,
              ),
              const SizedBox(width: 8),
              Text(
                'Keterangan Izin:',
                style: typography.body.sm.copyWith(
                  color: colors.mutedForeground,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.muted.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: colors.border),
            ),
            child: Text(
              activeItem.alasanIzin.toString(),
              style: typography.body.md.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tidak ada keterangan izin',
          style: typography.body.sm.copyWith(
            color: colors.mutedForeground,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final typography = context.theme.typography;
    final themeState = ref.watch(themeProvider).value ?? false;
    final historyState = ref.watch(historyAbsenProvider);
    final selectedId = ref.watch(selectedAttendanceIdProvider);

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              themeState
                  ? 'assets/images/kopdes_gunung_malam.png'
                  : 'assets/images/kopdes_gunung.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: historyState.when(
              data: (history) {
                final items = history?.data ?? [];
                if (items.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: FCard(
                        style: .delta(
                          decoration: .boxDelta(
                            color: context.theme.colors.background.withValues(
                              alpha: 0.85,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsetsGeometry.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                FLucideIcons.calendarX,
                                size: 48,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Belum Ada Riwayat Presensi',
                                style: typography.body.lg.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Silakan lakukan check-in terlebih dahulu di halaman beranda.',
                                textAlign: TextAlign.center,
                                style: typography.body.sm.copyWith(
                                  color: context.theme.colors.mutedForeground,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }

                // Tentukan item presensi yang aktif ditampilkan
                final activeItem = items.firstWhere(
                  (item) => item.id == selectedId,
                  orElse: () => items.first,
                );

                final formattedDate = formatLocalDate(activeItem.checkIn);
                final formattedTime = formatLocalTime(activeItem.checkIn);
                final checkInLatLng = _getCheckInLatLng(activeItem);
                final checkOutLatLng = _getCheckOutLatLng(activeItem);
                final hasCheckedOut = _hasCheckOut(activeItem);

                return ListView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                  children: [
                    // Header Screen
                    Row(
                      children: [
                        Text(
                          'Detail Presensi',
                          style: typography.body.lg.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Selector Tanggal Presensi (jika ada lebih dari 1 data)
                    if (items.length > 1) ...[
                      SizedBox(
                        height: 40,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: items.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final itm = items[index];
                            final isSelected = itm.id == activeItem.id;
                            final dateLabel = formatLocalDate(
                              itm.checkIn,
                              pattern: 'dd MMM',
                            );
                            return GestureDetector(
                              onTap: () {
                                ref
                                    .read(selectedAttendanceIdProvider.notifier)
                                    .select(itm.id);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.red
                                      : context.theme.colors.background
                                            .withValues(alpha: 0.8),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.red
                                        : context.theme.colors.border,
                                  ),
                                ),
                                child: Text(
                                  dateLabel,
                                  style: typography.body.sm.copyWith(
                                    color: isSelected
                                        ? Colors.white
                                        : context.theme.colors.foreground,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Card Utama Konten Detail Presensi (Pindahan dari SheetAttend)
                    FCard(
                      style: .delta(
                        decoration: .boxDelta(
                          color: context.theme.colors.background.withValues(
                            alpha: 0.85,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsetsGeometry.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        formattedDate,
                                        style: typography.body.sm,
                                      ),
                                      const SizedBox(height: 2),
                                      Row(
                                        children: [
                                          Text(
                                            '${activeItem.status == 'masuk' ? "Presensi" : (activeItem.status == 'izin' ? "Izin" : activeItem.status?.capitalize() ?? "")} jam ',
                                            style: typography.body.lg,
                                          ),
                                          Text(
                                            formattedTime,
                                            style: typography.body.lg.copyWith(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                DeletePresensiButton(id: activeItem.id),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const FDivider(
                              style: .delta(padding: .value(.zero)),
                            ),
                            const SizedBox(height: 12),

                            // Accordion Lokasi Check In, Check Out, & Izin
                            FAccordion(
                              children: [
                                FAccordionItem(
                                  initiallyExpanded: true,
                                  title: const Text('Lokasi Check In'),
                                  child: _buildMapSection(
                                    context: context,
                                    markerTitle: 'Lokasi Check In',
                                    latLng: checkInLatLng,
                                    address:
                                        activeItem.checkInAddress ??
                                        'Tidak ada alamat tercatat',
                                    timeText: activeItem.checkIn != null
                                        ? 'Waktu Masuk: ${formatLocalTime(activeItem.checkIn)}'
                                        : null,
                                  ),
                                ),
                                FAccordionItem(
                                  initiallyExpanded: hasCheckedOut,
                                  title: const Text('Lokasi Check Out'),
                                  child: hasCheckedOut
                                      ? _buildMapSection(
                                          context: context,
                                          markerTitle: 'Lokasi Check Out',
                                          latLng: checkOutLatLng,
                                          address:
                                              activeItem.checkOutAddress
                                                  ?.toString() ??
                                              'Alamat Checkout tidak tercatat',
                                          timeText: activeItem.checkOut != null
                                              ? 'Waktu Pulang: ${formatLocalTime(activeItem.checkOut.toString())}'
                                              : null,
                                        )
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Anda Belum Checkout',
                                              style: typography.body.md
                                                  .copyWith(
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                            ),
                                            const SizedBox(height: 12),
                                            const CheckOutButton(),
                                          ],
                                        ),
                                ),
                                FAccordionItem(
                                  initiallyExpanded: true,
                                  title: const Text('Izin'),
                                  child: _buildIzinSection(
                                    context: context,
                                    activeItem: activeItem,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
              loading: () => const Center(child: FCircularProgress()),
              error: (err, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Gagal memuat presensi: $err',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 12),
                      FButton(
                        size: .sm,
                        variant: .outline,
                        onPress: () =>
                            ref.read(historyAbsenProvider.notifier).refresh(),
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}

import 'package:absensi_dede/absensi/models/absen/history_absen_response_model.dart';
import 'package:absensi_dede/absensi/services/maps_service.dart';
import 'package:absensi_dede/absensi/widgets/check_out_button.dart';
import 'package:absensi_dede/absensi/widgets/delete_presensi_button.dart';
import 'package:absensi_dede/helper/date_formatter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SheetAttend extends StatelessWidget {
  final FLayout side;
  final Data history;
  const SheetAttend({required this.side, required this.history, super.key});

  double? _parseDouble(dynamic val) {
    if (val == null) return null;
    if (val is num) return val.toDouble();
    if (val is String) return double.tryParse(val.trim());
    return null;
  }

  LatLng? _getCheckInLatLng() {
    if (history.checkInLat != null && history.checkInLng != null) {
      return LatLng(history.checkInLat!, history.checkInLng!);
    }
    if (history.checkInLocation != null &&
        history.checkInLocation!.contains(',')) {
      final parts = history.checkInLocation!.split(',');
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

  LatLng? _getCheckOutLatLng() {
    final lat = _parseDouble(history.checkOutLat);
    final lng = _parseDouble(history.checkOutLng);
    if (lat != null && lng != null) {
      return LatLng(lat, lng);
    }
    if (history.checkOutLocation != null &&
        history.checkOutLocation.toString().contains(',')) {
      final parts = history.checkOutLocation.toString().split(',');
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

  bool get _hasCheckOut {
    return (history.checkOut != null &&
            history.checkOut.toString().isNotEmpty) ||
        (history.checkOutAddress != null &&
            history.checkOutAddress.toString().isNotEmpty) ||
        (history.checkOutLocation != null &&
            history.checkOutLocation.toString().isNotEmpty);
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

  @override
  Widget build(BuildContext context) {
    final typography = context.theme.typography;

    final formattedDate = formatLocalDate(history.checkIn);
    final formattedTime = formatLocalTime(history.checkIn);

    final checkInLatLng = _getCheckInLatLng();
    final checkOutLatLng = _getCheckOutLatLng();
    final hasCheckOut = _hasCheckOut;

    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.85,
      child: Container(
        decoration: BoxDecoration(color: context.theme.colors.background),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                      bottom: 10,
                      left: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(formattedDate, style: typography.body.sm),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Text(
                              'Presensi ${history.status ?? 'Hadir'} jam ',
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
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: DeletePresensiButton(id: history.id),
                ),
              ],
            ),
            FDivider(style: .delta(padding: .value(.zero))),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                children: [
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
                              history.checkInAddress ??
                              'Tidak ada alamat tercatat',
                          timeText: history.checkIn != null
                              ? 'Waktu Masuk: ${formatLocalTime(history.checkIn)}'
                              : null,
                        ),
                      ),
                      FAccordionItem(
                        initiallyExpanded: hasCheckOut,
                        title: const Text('Lokasi Check Out'),
                        child: hasCheckOut
                            ? _buildMapSection(
                                context: context,
                                markerTitle: 'Lokasi Check Out',
                                latLng: checkOutLatLng,
                                address:
                                    history.checkOutAddress?.toString() ??
                                    'Alamat Checkout tidak tercatat',
                                timeText: history.checkOut != null
                                    ? 'Waktu Pulang: ${formatLocalTime(history.checkOut.toString())}'
                                    : null,
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Anda Belum Checkout',
                                    style: typography.body.md.copyWith(
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  const CheckOutButton(),
                                ],
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

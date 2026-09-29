import 'package:absensi_dede/absensi/controllers/check_in_user.dart';
import 'package:absensi_dede/absensi/controllers/history_absen.dart';
import 'package:absensi_dede/absensi/models/absen/check_in_request_model.dart';
import 'package:absensi_dede/absensi/services/maps_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:forui/forui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CheckInButton extends HookConsumerWidget {
  const CheckInButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loading = useState(false);
    print(loading.value);

    ref.listen(checkInUserProvider, (previous, next) {
      next.whenOrNull(
        data: (response) {
          loading.value = false;
          if (response == null) return;
          ref.invalidate(historyAbsenProvider);
          showFToast(
            context: context,
            duration: const Duration(seconds: 4),
            title: const Text('Check in Berhasil!'),
            description: Text(
              response.message ?? 'Jangan lupa nanti checkout ya!',
            ),
            icon: const Icon(Icons.check_circle_outline, color: Colors.green),
          );
        },
        error: (error, _) {
          loading.value = false;
          showFToast(
            context: context,
            duration: const Duration(seconds: 4),
            title: const Text('Checkin Gagal'),
            description: Text(error.toString()),
            icon: const Icon(Icons.error_outline, color: Colors.red),
          );
        },
      );
    });

    Future<void> checkIn() async {
      // 1. Loading AKTIF sebelum mengambil position/koordinat
      loading.value = true;

      try {
        final Position coordinate = await MapsService().getCurrentLocation();
        final String address = await MapsService().getAddressFromCoordinates(
          coordinate.latitude,
          coordinate.longitude,
        );

        final checkInRequest = CheckInRequestModel(
          checkInLat: '${coordinate.latitude}',
          checkInLng: '${coordinate.longitude}',
          status: 'masuk',
          checkInAddress: address,
        );

        await ref.read(checkInUserProvider.notifier).checkIn(checkInRequest);
      } catch (e) {
        loading.value = false;
        if (!context.mounted) return;
        showFToast(
          context: context,
          duration: const Duration(seconds: 4),
          title: const Text('Gagal Mendapatkan Lokasi'),
          description: Text(e.toString()),
          icon: const Icon(Icons.error_outline, color: Colors.red),
        );
      }
    }

    return SizedBox(
      width: double.infinity,
      child: FButton(
        prefix: loading.value ? const FCircularProgress() : null,
        variant: .primary,
        onPress: loading.value ? null : checkIn,
        child: const Text('Check In Sekarang'),
      ),
    );
  }
}

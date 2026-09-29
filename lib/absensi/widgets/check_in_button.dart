import 'package:absensi_dede/absensi/controllers/check_in_user.dart';
import 'package:absensi_dede/absensi/models/absen/check_in_request_model.dart';
import 'package:absensi_dede/absensi/services/maps_service.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CheckInButton extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(checkInUserProvider, (previous, next) {
      next.whenOrNull(
        data: (response) async {
          if (response == null) return;
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

    final isLoading = ref.watch(checkInUserProvider);

    void checkIn() async {
      print(isLoading.isLoading);
      final Position coordinate = await MapsService().getCurrentLocation();
      final String address = await MapsService().getAddressFromCoordinates(
        coordinate.latitude,
        coordinate.latitude,
      );

      final checkInRequest = CheckInRequestModel(
        checkInLat: '${coordinate.latitude}',
        checkInLng: '${coordinate.longitude}',
        status: 'masuk',
        checkInAddress: address,
      );

      ref.read(checkInUserProvider.notifier).checkIn(checkInRequest);
      print(isLoading.isLoading);
    }

    return SizedBox(
      width: .infinity,
      child: FButton(
        prefix: isLoading.isLoading ? FCircularProgress() : null,
        variant: .primary,
        onPress: () async {
          isLoading.isLoading ? null : checkIn();
        },
        child: Text('Check In Sekarang'),
      ),
    );
  }
}

import 'package:absensi_kopdes/absensi/controllers/check_out_user.dart';
import 'package:absensi_kopdes/absensi/controllers/history_absen.dart';
import 'package:absensi_kopdes/absensi/models/absen/check_out_request_model.dart';
import 'package:absensi_kopdes/absensi/services/maps_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:forui/forui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CheckOutButton extends HookConsumerWidget {
  const CheckOutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loading = useState(false);

    ref.listen(checkOutUserProvider, (previous, next) {
      next.whenOrNull(
        data: (response) {
          loading.value = false;
          if (response == null) return;
          ref.invalidate(historyAbsenProvider);
          if (context.mounted) {
            Navigator.of(context).maybePop();
          }
          showFToast(
            context: context,
            duration: const Duration(seconds: 4),
            title: const Text('Check Out Berhasil!'),
            description: Text(
              response.message ?? 'Presensi check out berhasil dicatat!',
            ),
            icon: const Icon(Icons.check_circle_outline, color: Colors.green),
          );
        },
        error: (error, _) {
          loading.value = false;
          showFToast(
            context: context,
            duration: const Duration(seconds: 4),
            title: const Text('Check Out Gagal'),
            description: Text(error.toString()),
            icon: const Icon(Icons.error_outline, color: Colors.red),
          );
        },
      );
    });

    Future<void> checkOut() async {
      loading.value = true;

      try {
        final Position coordinate = await MapsService().getCurrentLocation();
        final String address = await MapsService().getAddressFromCoordinates(
          coordinate.latitude,
          coordinate.longitude,
        );

        final checkOutRequest = CheckOutRequestModel(
          checkOutLocation: '${coordinate.latitude}, ${coordinate.longitude}',
          checkOutAddress: address,
          checkOutLat: '${coordinate.latitude}',
          checkOutLng: '${coordinate.longitude}',
        );

        await ref.read(checkOutUserProvider.notifier).checkOut(checkOutRequest);
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
        variant: .secondary,
        onPress: loading.value ? null : checkOut,
        child: const Text('Check Out Sekarang'),
      ),
    );
  }
}

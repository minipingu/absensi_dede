import 'package:absensi_dede/absensi/controllers/history_absen.dart';
import 'package:absensi_dede/absensi/controllers/izin_user.dart';
import 'package:absensi_dede/absensi/models/absen/izin_request_model.dart';
import 'package:absensi_dede/absensi/services/maps_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:forui/forui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class IzinButton extends HookConsumerWidget {
  final bool isReadOnly;
  final String? readOnlyText;

  const IzinButton({super.key, this.isReadOnly = false, this.readOnlyText});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loading = useState(false);
    final izinState = ref.watch(izinUserProvider);
    final isSubmitting = loading.value || izinState.isLoading;

    ref.listen(izinUserProvider, (previous, next) {
      next.whenOrNull(
        data: (response) {
          loading.value = false;
          if (response == null) return;
          ref.invalidate(historyAbsenProvider);
          showFToast(
            context: context,
            duration: const Duration(seconds: 4),
            title: const Text('Izin Berhasil Disimpan!'),
            description: Text(
              response.message ?? 'Keterangan izin berhasil disimpan.',
            ),
            icon: const Icon(Icons.check_circle_outline, color: Colors.green),
          );
        },
        error: (error, _) {
          loading.value = false;
          showFToast(
            context: context,
            duration: const Duration(seconds: 4),
            title: const Text('Gagal Menyimpan Izin'),
            description: Text(error.toString()),
            icon: const Icon(Icons.error_outline, color: Colors.red),
          );
        },
      );
    });

    Future<void> submitIzinWithReason(String alasan) async {
      loading.value = true;

      try {
        Position? coordinate;
        String address = 'Lokasi Izin';

        try {
          coordinate = await MapsService().getCurrentLocation();
          address = await MapsService().getAddressFromCoordinates(
            coordinate.latitude,
            coordinate.longitude,
          );
        } catch (_) {
          address = 'Lokasi Izin';
        }

        final latStr = coordinate != null ? '${coordinate.latitude}' : '0.0';
        final lngStr = coordinate != null ? '${coordinate.longitude}' : '0.0';
        final addrStr = address;

        final request = IzinRequestModel(
          checkInLat: latStr,
          checkInLng: lngStr,
          checkInAddress: addrStr,
          status: 'izin',
          alasanIzin: alasan,
        );

        final response = await ref
            .read(izinUserProvider.notifier)
            .submitIzin(request);

        if (response != null) {
          ref.invalidate(historyAbsenProvider);
        }
      } catch (e) {
        loading.value = false;
        if (!context.mounted) return;
        showFToast(
          context: context,
          duration: const Duration(seconds: 4),
          title: const Text('Terjadi Kesalahan'),
          description: Text(e.toString()),
          icon: const Icon(Icons.error_outline, color: Colors.red),
        );
      } finally {
        loading.value = false;
      }
    }

    Future<void> openDialogIzin() async {
      final textController = TextEditingController();

      final result = await showFDialog<String>(
        context: context,
        builder: (dialogContext, style, animation) => FDialog(
          animation: animation,
          builder: (dialogContext, style) => Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Keterangan Izin', style: style.titleTextStyle),
                  const SizedBox(height: 8),
                  Text(
                    'Silakan masukkan alasan atau keterangan izin Anda.',
                    style: style.bodyTextStyle,
                  ),
                  const SizedBox(height: 16),
                  FTextField(
                    control: FTextFieldControl.managed(
                      controller: textController,
                    ),
                    label: const Text('Alasan Izin'),
                    hint: 'Contoh: Sakit, urusan keluarga, dll.',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FButton(
                        variant: .secondary,
                        onPress: () => Navigator.of(dialogContext).pop(),
                        child: const Text('Batal'),
                      ),
                      const SizedBox(width: 8),
                      FButton(
                        onPress: () {
                          final text = textController.text.trim();
                          if (text.isEmpty) {
                            showFToast(
                              context: dialogContext,
                              duration: const Duration(seconds: 3),
                              title: const Text('Peringatan'),
                              description: const Text(
                                'Keterangan izin harus diisi!',
                              ),
                              icon: const Icon(
                                Icons.warning_amber_rounded,
                                color: Colors.orange,
                              ),
                            );
                            return;
                          }
                          Navigator.of(dialogContext).pop(text);
                        },
                        child: const Text('Simpan'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      if (result != null && result.trim().isNotEmpty) {
        await submitIzinWithReason(result.trim());
      }
    }

    return SizedBox(
      width: double.infinity,
      child: FButton(
        prefix: isSubmitting ? const FCircularProgress() : null,
        variant: .outline,
        onPress: (isSubmitting || isReadOnly) ? null : openDialogIzin,
        child: Text(
          isReadOnly
              ? (readOnlyText ?? 'Buat Ijin (Sudah Check In)')
              : 'Buat Ijin',
        ),
      ),
    );
  }
}

import 'package:absensi_kopdes/absensi/controllers/delete_presensi.dart';
import 'package:absensi_kopdes/absensi/controllers/history_absen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:forui/forui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DeletePresensiButton extends HookConsumerWidget {
  final int? id;
  const DeletePresensiButton({this.id, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loading = useState(false);

    ref.listen(deletePresensiProvider, (previous, next) {
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
            title: const Text('Berhasil Dihapus!'),
            description: Text(
              response.message ?? 'Data presensi berhasil dihapus.',
            ),
            icon: const Icon(Icons.check_circle_outline, color: Colors.green),
          );
        },
        error: (error, _) {
          loading.value = false;
          showFToast(
            context: context,
            duration: const Duration(seconds: 4),
            title: const Text('Gagal Menghapus Presensi'),
            description: Text(error.toString()),
            icon: const Icon(Icons.error_outline, color: Colors.red),
          );
        },
      );
    });

    Future<void> confirmAndDelete() async {
      final confirmed = await showFDialog<bool>(
        context: context,
        builder: (dialogContext, style, animation) => FDialog(
          animation: animation,
          builder: (dialogContext, style) => Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hapus Presensi', style: style.titleTextStyle),
                const SizedBox(height: 8),
                Text(
                  'Apakah Anda yakin ingin menghapus data presensi ini?',
                  style: style.bodyTextStyle,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FButton(
                      variant: .secondary,
                      onPress: () => Navigator.of(dialogContext).pop(false),
                      child: const Text('Batal'),
                    ),
                    const SizedBox(width: 8),
                    FButton(
                      variant: .destructive,
                      onPress: () => Navigator.of(dialogContext).pop(true),
                      child: const Text('Hapus'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      if (confirmed == true) {
        loading.value = true;
        await ref.read(deletePresensiProvider.notifier).deletePresensi(id: id);
      }
    }

    return FButton(
      variant: .destructive,
      onPress: loading.value ? null : confirmAndDelete,
      size: .sm,
      child: loading.value
          ? const FCircularProgress()
          : const Icon(FLucideIcons.trash, size: 20),
    );
  }
}

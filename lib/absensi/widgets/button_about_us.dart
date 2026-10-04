import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:url_launcher/url_launcher.dart';

class ButtonAboutUs extends StatelessWidget {
  const ButtonAboutUs({super.key});

  Future<void> _launchWhatsApp(BuildContext context) async {
    final Uri waUri = Uri.parse('https://wa.me/6285169444143');
    try {
      final launched = await launchUrl(
        waUri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        final fallback = await launchUrl(waUri);
        if (!fallback && context.mounted) {
          showFToast(
            context: context,
            title: const Text('Gagal Membuka WhatsApp'),
            description: const Text(
              'Tidak dapat membuka aplikasi WhatsApp di perangkat ini.',
            ),
            icon: const Icon(Icons.error_outline, color: Colors.red),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        showFToast(
          context: context,
          title: const Text('Gagal Membuka WhatsApp'),
          description: Text(e.toString()),
          icon: const Icon(Icons.error_outline, color: Colors.red),
        );
      }
    }
  }

  void _showAboutUsSheet(BuildContext context) {
    final typography = context.theme.typography;
    final colors = context.theme.colors;

    showFSheet(
      context: context,
      side: FLayout.btt,
      mainAxisMaxRatio: null,
      builder: (sheetContext) {
        return Container(
          decoration: BoxDecoration(
            color: colors.background,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            border: Border(top: BorderSide(color: colors.border, width: 1)),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: colors.mutedForeground.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(
                          FLucideIcons.info,
                          size: 22,
                          color: colors.primary,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Tentang Aplikasi',
                          style: typography.display.xs.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const FDivider(),
                    const SizedBox(height: 16),

                    // 1. Dibuat oleh
                    _buildInfoItem(
                      label: 'Aplikasi ini dibuat oleh :',
                      value: 'Dede Nurhidayat',
                      typography: typography,
                      colors: colors,
                    ),

                    const SizedBox(height: 16),

                    // 2. Kolaborasi
                    _buildInfoItem(
                      label: 'Kolaborasi dengan :',
                      value: 'PPKD Jakarta Utara',
                      typography: typography,
                      colors: colors,
                    ),

                    const SizedBox(height: 16),

                    // 3. Mentor
                    _buildInfoItem(
                      label: 'Mentor :',
                      value: 'Hardi, Ferry Hernando, Andrea Surya Habibie',
                      typography: typography,
                      colors: colors,
                    ),

                    const SizedBox(height: 24),

                    // 4. Tombol WhatsApp
                    SizedBox(
                      width: double.infinity,
                      child: FButton(
                        variant: .primary,
                        prefix: const Icon(
                          FLucideIcons.messageCircle,
                          size: 18,
                        ),
                        onPress: () => _launchWhatsApp(sheetContext),
                        child: const Text(
                          'Hubungi via WhatsApp (+62851-6944-4143)',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoItem({
    required String label,
    required String value,
    required FTypography typography,
    required FColors colors,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: typography.body.sm.copyWith(
            color: colors.mutedForeground,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: typography.body.md.copyWith(
            fontWeight: FontWeight.w600,
            color: colors.foreground,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FButton(
        variant: .outline,
        prefix: const Icon(FLucideIcons.info, size: 18),
        onPress: () => _showAboutUsSheet(context),
        child: const Text('About Us'),
      ),
    );
  }
}

import 'package:absensi_dede/absensi/controllers/edit_profile.dart';
import 'package:absensi_dede/absensi/controllers/profile_user.dart';
import 'package:absensi_dede/absensi/models/user/name_user_edit_request_model.dart';
import 'package:absensi_dede/absensi/riverpod/theme.dart';
import 'package:absensi_dede/absensi/widgets/bottom_nav_bar.dart';
import 'package:absensi_dede/absensi/widgets/logout_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:forui/forui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';

class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({super.key});

  void _showEditNameDialog(
    BuildContext context,
    WidgetRef ref,
    String currentName,
  ) {
    showFDialog(
      context: context,
      builder: (dialogContext, style, animation) => FDialog(
        animation: animation,
        builder: (dialogContext, style) =>
            _EditNameDialog(currentName: currentName),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final typography = context.theme.typography;
    final themeState = ref.watch(themeProvider).value ?? false;
    final profileAsync = ref.watch(profileUserProvider);

    // 1. Inisialisasi controller video menggunakan useMemoized agar tidak terbuat ulang terus
    final controller = useMemoized(
      () => VideoPlayerController.asset('assets/video/avatar_video.mp4'),
      [],
    );

    // State untuk memantau apakah video sudah siap di-load atau terjadi error
    final isInitialized = useState(false);
    final hasError = useState(false);

    // 2. useEffect untuk setup play, loop, dan dispose otomatis
    useEffect(() {
      var isMounted = true;
      controller
          .initialize()
          .then((_) {
            if (!isMounted) return;
            controller.setLooping(true);
            controller.setVolume(0.0);
            controller.play();
            isInitialized.value = true;
          })
          .catchError((error) {
            debugPrint('Error initializing video player: $error');
            if (isMounted) {
              hasError.value = true;
            }
          });

      // Cleanup otomatis saat widget dihancurkan
      return () {
        isMounted = false;
        controller.dispose();
      };
    }, [controller]);

    return Scaffold(
      extendBody: true,
      body: Center(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                themeState
                    ? 'assets/images/kopdes_gunung_malam.png'
                    : 'assets/images/kopdes_gunung.png',
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ListView(
                children: [
                  Center(
                    child: Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.red, width: 3.0),
                      ),
                      child: ClipOval(
                        child:
                            isInitialized.value &&
                                controller.value.isInitialized
                            ? FittedBox(
                                fit: BoxFit.cover,
                                child: SizedBox(
                                  width: controller.value.size.width > 0
                                      ? controller.value.size.width
                                      : 120,
                                  height: controller.value.size.height > 0
                                      ? controller.value.size.height
                                      : 120,
                                  child: VideoPlayer(controller),
                                ),
                              )
                            : hasError.value
                            ? const Center(
                                child: Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Colors.grey,
                                ),
                              )
                            : const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Data Properties Profile dengan FTile ForUI
                  profileAsync.when(
                    data: (response) {
                      final user = response?.data;
                      return FCard(
                        style: .delta(
                          decoration: .boxDelta(
                            color: context.theme.colors.background.withValues(
                              alpha: 0.85,
                            ),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FTile(
                              title: const Text('Nama'),
                              subtitle: Text(
                                user?.name ?? '-',
                                style: typography.body.md.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              suffix: FButton.icon(
                                size: .sm,
                                variant: .ghost,
                                onPress: () => _showEditNameDialog(
                                  context,
                                  ref,
                                  user?.name ?? '',
                                ),
                                child: const Icon(
                                  FLucideIcons.pencil,
                                  size: 18,
                                ),
                              ),
                            ),
                            const FDivider(),
                            FTile(
                              title: const Text('Email'),
                              subtitle: Text(user?.email ?? '-'),
                            ),
                            if (user?.id != null) ...[
                              const FDivider(),
                              FTile(
                                title: const Text('ID Pengguna'),
                                subtitle: Text('${user!.id}'),
                              ),
                            ],
                            const FDivider(),
                            FTile(
                              title: const Text('Dibuat Pada'),
                              subtitle: Text(
                                user?.createdAt != null
                                    ? DateFormat(
                                        'dd MMMM yyyy, HH:mm',
                                        'id_ID',
                                      ).format(user!.createdAt!)
                                    : '-',
                              ),
                            ),
                            const FDivider(),
                            FTile(
                              title: const Text('Terakhir Diperbarui'),
                              subtitle: Text(
                                user?.updatedAt != null
                                    ? DateFormat(
                                        'dd MMMM yyyy, HH:mm',
                                        'id_ID',
                                      ).format(user!.updatedAt!)
                                    : '-',
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: FCircularProgress(),
                      ),
                    ),
                    error: (error, _) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text(
                              'Gagal memuat profil: $error',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red),
                            ),
                            const SizedBox(height: 8),
                            FButton(
                              size: .sm,
                              variant: .outline,
                              onPress: () => ref
                                  .read(profileUserProvider.notifier)
                                  .refresh(),
                              child: const Text('Coba Lagi'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  const LogoutButton(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}

class _EditNameDialog extends ConsumerStatefulWidget {
  final String currentName;

  const _EditNameDialog({required this.currentName});

  @override
  ConsumerState<_EditNameDialog> createState() => _EditNameDialogState();
}

class _EditNameDialogState extends ConsumerState<_EditNameDialog> {
  final _formKey = GlobalKey<FormBuilderState>();
  late final TextEditingController _nameController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      setState(() => _isLoading = true);
      final newName = _nameController.text.trim();
      final request = NameUserEditRequestModel(name: newName);

      final response = await ref
          .read(editProfileProvider.notifier)
          .editProfile(request);

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (response != null) {
        Navigator.of(context).pop();
        showFToast(
          context: context,
          duration: const Duration(seconds: 4),
          title: const Text('Berhasil Menyimpan!'),
          description: Text(
            response.message ?? 'Nama profil berhasil diperbarui.',
          ),
          icon: const Icon(Icons.check_circle_outline, color: Colors.green),
        );
      } else {
        final editState = ref.read(editProfileProvider);
        final errorMsg = editState.hasError
            ? editState.error.toString()
            : 'Gagal memperbarui profil';

        showFToast(
          context: context,
          duration: const Duration(seconds: 4),
          title: const Text('Gagal Menyimpan'),
          description: Text(errorMsg),
          icon: const Icon(Icons.error_outline, color: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = context.theme.dialogStyle;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: FormBuilder(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Edit Nama', style: style.titleTextStyle),
            const SizedBox(height: 16),
            FormBuilderField<String>(
              key: const ValueKey('field_edit_nama'),
              name: 'nama',
              initialValue: _nameController.text,
              valueTransformer: (text) =>
                  text?.trim().replaceAll(RegExp(r'\s+'), ' '),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: 'Nama wajib diisi'),
                FormBuilderValidators.minLength(
                  3,
                  errorText: 'Minimal 3 karakter',
                ),
                FormBuilderValidators.alphabetical(
                  regex: RegExp(r'^[a-zA-Z ]+$'),
                  errorText: 'Hanya boleh huruf alfabet',
                ),
              ]),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              builder: (FormFieldState<String> field) {
                return FTextFormField(
                  label: const Text('Nama'),
                  hint: 'Masukkan nama baru',
                  control: FTextFieldControl.managed(
                    controller: _nameController,
                    onChange: (value) => field.didChange(value.text),
                  ),
                  forceErrorText: field.errorText,
                );
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FButton(
                  variant: .secondary,
                  onPress: _isLoading
                      ? null
                      : () => Navigator.of(context).pop(),
                  child: const Text('Batal'),
                ),
                const SizedBox(width: 8),
                FButton(
                  prefix: _isLoading ? const FCircularProgress() : null,
                  variant: .primary,
                  onPress: _isLoading ? null : _handleSave,
                  child: const Text('Simpan'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

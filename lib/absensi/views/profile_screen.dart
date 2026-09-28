import 'package:absensi_dede/absensi/riverpod/theme.dart';
import 'package:absensi_dede/absensi/widgets/bottom_nav_bar.dart';
import 'package:absensi_dede/absensi/widgets/logout_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:video_player/video_player.dart';

class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider).value ?? false;

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
                  const LogoutButton(),
                  const SizedBox(height: 20),
                  const Text(
                    'data profile, dibuat dan diupdate, edit profil, logout',
                  ),
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

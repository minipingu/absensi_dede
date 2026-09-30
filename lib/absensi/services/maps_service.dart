import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

export 'package:geolocator/geolocator.dart' show Position;

/// Exception yang dilempar saat GPS atau layanan lokasi di perangkat dinonaktifkan.
class LocationServiceDisabledException implements Exception {
  final String message;
  const LocationServiceDisabledException([
    this.message =
        'Layanan lokasi dinonaktifkan. Silakan aktifkan GPS perangkat Anda.',
  ]);

  @override
  String toString() => message;
}

/// Exception yang dilempar saat pengguna menolak izin lokasi.
class LocationPermissionDeniedException implements Exception {
  final String message;
  const LocationPermissionDeniedException([
    this.message = 'Izin lokasi ditolak. Aplikasi membutuhkan izin lokasi untuk menampilkan peta.',
  ]);

  @override
  String toString() => message;
}

/// Exception yang dilempar saat pengguna menolak izin lokasi secara permanen.
class LocationPermissionPermanentlyDeniedException implements Exception {
  final String message;
  const LocationPermissionPermanentlyDeniedException([
    this.message = 'Izin lokasi ditolak secara permanen. Silakan berikan izin melalui Pengaturan aplikasi.',
  ]);

  @override
  String toString() => message;
}

/// Service yang menangani operasi lokasi, izin GPS, dan reverse geocoding untuk Maps.
class MapsService {
  final Geocoding _geocoding;

  MapsService({Geocoding? geocoding}) : _geocoding = geocoding ?? Geocoding();

  /// Memeriksa status izin lokasi dan mengaktifkan permintaan izin jika diperlukan.
  ///
  /// Mengembalikan [Position] saat ini jika berhasil, atau melempar exception:
  /// - [LocationServiceDisabledException] jika GPS mati.
  /// - [LocationPermissionDeniedException] jika izin ditolak.
  /// - [LocationPermissionPermanentlyDeniedException] jika izin ditolak permanen.
  Future<Position> getCurrentLocation() async {
    // 1. Cek apakah layanan GPS aktif di perangkat
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationServiceDisabledException();
    }

    // 2. Cek status izin lokasi
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw const LocationPermissionDeniedException();
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw const LocationPermissionPermanentlyDeniedException();
    }

    // 3. Ambil posisi saat ini
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }

  /// Mengonversi koordinat [latitude] dan [longitude] menjadi alamat teks (Reverse Geocoding).
  Future<String> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      final List<Placemark> placemarks = await _geocoding
          .placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks.first;
        final List<String> addressParts =
            [
                  place.street,
                  place.subLocality,
                  place.locality,
                  place.postalCode,
                  place.country,
                ]
                .whereType<String>()
                .map((s) => s.trim())
                .where((s) => s.isNotEmpty)
                .toList();

        if (addressParts.isNotEmpty) {
          return addressParts.join(', ');
        }
      }
      return 'Alamat tidak ditemukan.';
    } catch (e) {
      return 'Gagal memuat alamat: $e';
    }
  }

  /// Membuat [Uri] Google Maps untuk koordinat yang diberikan.
  Uri getGoogleMapsUrl(double latitude, double longitude) {
    return Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
    );
  }

  /// Membuka tautan Google Maps langsung menggunakan [url_launcher].
  Future<bool> openGoogleMaps(double latitude, double longitude) async {
    final uri = getGoogleMapsUrl(latitude, longitude);
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (launched) return true;
      return await launchUrl(uri);
    } catch (_) {
      try {
        return await launchUrl(uri);
      } catch (_) {
        return false;
      }
    }
  }
}

/// Alias untuk MapsService
typedef LocationService = MapsService;

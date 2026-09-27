import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// import 'package:url_launcher/url_launcher.dart';

/// Screen utama untuk menampilkan Google Maps dan lokasi pengguna (Day 34)
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Instance untuk melakukan reverse geocoding (koordinat -> nama alamat)
  final Geocoding geocoding = Geocoding();

  // Controller untuk mengontrol tampilan kamera dan gesture pada Google Maps
  GoogleMapController? _mapController;

  // Menyimpan posisi geografis (latitude & longitude) perangkat saat ini
  Position? _currentPosition;

  // Menyimpan teks alamat lengkap hasil konversi dari koordinat
  String _currentAddress = "Mencari Lokasi...";

  // Set marker yang akan ditampilkan di atas peta Google Maps
  final Set<Marker> _markers = {};

  // Lokasi default (misal: Indramayu/Jakarta) jika lokasi perangkat belum didapatkan
  final LatLng _defaultLocation = LatLng(-6.2000, 108.8166666);

  @override
  void initState() {
    super.initState();
    // Memeriksa izin akses lokasi dan mengambil posisi saat screen pertama kali dimuat
    _checkPermissionsAndGetLocation();
  }

  /// Memeriksa status GPS/Layanan Lokasi serta meminta izin akses lokasi ke pengguna
  Future<void> _checkPermissionsAndGetLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 1. Cek apakah layanan GPS pada perangkat dalam kondisi aktif
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _currentAddress = "Layanan lokasi dinonaktifkan.";
      });
      return;
    }

    // 2. Cek status izin akses lokasi aplikasi
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Minta izin ke pengguna jika belum diizinkan
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _currentAddress = "Izin lokasi ditolak.";
        });
        return;
      }
    }

    // 3. Jika izin ditolak secara permanen oleh pengguna
    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _currentAddress = "Izin lokasi ditolak permanen.";
      });
      return;
    }

    // 4. Jika semua izin terpenuhi, ambil posisi lokasi saat ini
    await _getCurrentLocation();
  }

  /// Mengambil titik koordinat (Latitude & Longitude) terbaru dari GPS perangkat
  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high, // Tingkat akurasi tinggi
      );

      setState(() {
        _currentPosition = position;
      });

      log(_currentPosition.toString());

      // Perbarui posisi marker dan gerakkan kamera peta ke lokasi pengguna
      _updateMarkerAndCamera(position);

      // Konversi koordinat menjadi nama alamat jalan
      await _getAddressFromLatLng(position);
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  /// Memperbarui pin marker di peta dan menganimasikan gerak kamera ke koordinat terkini
  void _updateMarkerAndCamera(Position position) {
    LatLng currentLatLng = LatLng(position.latitude, position.longitude);

    setState(() {
      _markers.clear();
      // Tambahkan marker baru pada lokasi pengguna
      _markers.add(
        Marker(
          markerId: const MarkerId("currentLocation"),
          position: currentLatLng,

          infoWindow: const InfoWindow(title: "Lokasi Anda"),
        ),
      );
    });

    // Geser kamera peta dengan animasi menuju koordinat pengguna (level zoom 15)
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: currentLatLng, zoom: 15),
      ),
    );
  }

  /// Melakukan Reverse Geocoding (mengubah latitude & longitude menjadi alamat lengkap)
  Future<void> _getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks = await geocoding.placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        log(place.toString());
        log(placemarks.toString());

        // Susun teks alamat dari komponen street, subLocality, locality, dsb.
        setState(() {
          _currentAddress =
              "${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}";
        });
      }
    } catch (e) {
      print("Error getting address: $e");
    }
  }

  /// Membuka lokasi pengguna saat ini di aplikasi Google Maps eksternal
  Future<void> _openInGoogleMaps() async {
    if (_currentPosition == null) return;

    final double lat = _currentPosition!.latitude;
    final double lng = _currentPosition!.longitude;

    // Skema URL universal untuk mencari koordinat di Google Maps
    final Uri googleMapsUrl = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=$lat,$lng",
    );

    // Kode alternatif jika mengaktifkan package url_launcher:
    // try {
    //   if (await canLaunchUrl(googleMapsUrl)) {
    //     await launchUrl(
    //       googleMapsUrl,
    //       mode: LaunchMode.externalApplication,
    //     );
    //   } else {
    //     throw 'Tidak dapat membuka Google Maps URL';
    //   }
    // } catch (e) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text("Gagal membuka peta eksternal: $e")),
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Widget utama Google Maps
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentPosition != null
                  ? LatLng(
                      _currentPosition!.latitude,
                      _currentPosition!.longitude,
                    )
                  : _defaultLocation,
              zoom: 13.0,
            ),
            markers: _markers,
            myLocationEnabled: true, // Menampilkan titik lokasi bawaan
            myLocationButtonEnabled: true, // Tombol fokus lokasi dari peta
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
              // Jika lokasi sudah didapatkan sebelum peta selesai dibuat
              if (_currentPosition != null) {
                _updateMarkerAndCamera(_currentPosition!);
              }
            },
          ),

          // Card melayang di bagian bawah untuk menampilkan informasi alamat
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Alamat Anda Saat Ini:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _currentAddress,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _openInGoogleMaps,
                      icon: const Icon(Icons.navigation),
                      label: const Text("Buka di Google Maps"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // Tombol melayang di pojok kanan bawah untuk memperbarui posisi lokasi
      floatingActionButton: FloatingActionButton(
        onPressed: _checkPermissionsAndGetLocation,
        child: const Icon(Icons.my_location),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

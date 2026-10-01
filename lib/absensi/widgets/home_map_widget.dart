import 'package:absensi_dede/absensi/services/maps_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeMapWidget extends StatefulWidget {
  final MapsService? mapsService;

  const HomeMapWidget({super.key, this.mapsService});

  @override
  State<HomeMapWidget> createState() => _HomeMapWidgetState();
}

class _HomeMapWidgetState extends State<HomeMapWidget> {
  late final MapsService _mapsService;

  GoogleMapController? _mapController;
  Position? _currentPosition;
  String _currentAddress = "Mencari Lokasi...";
  bool _isLoading = false;

  final Set<Marker> _markers = {};
  final LatLng _defaultLocation = const LatLng(-6.2000, 108.8166666);

  @override
  void initState() {
    super.initState();
    _mapsService = widget.mapsService ?? MapsService();
    _fetchLocationAndAddress();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _fetchLocationAndAddress() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _currentAddress = "Mencari Lokasi...";
    });

    try {
      final position = await _mapsService.getCurrentLocation();
      final latLng = LatLng(position.latitude, position.longitude);

      if (!mounted) return;
      setState(() {
        _currentPosition = position;
      });

      _updateMarkerAndCamera(latLng);

      final address = await _mapsService.getAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (!mounted) return;
      setState(() {
        _currentAddress = address;
      });
    } on LocationServiceDisabledException catch (e) {
      if (!mounted) return;
      setState(() {
        _currentAddress = e.message;
      });
    } on LocationPermissionDeniedException catch (e) {
      if (!mounted) return;
      setState(() {
        _currentAddress = e.message;
      });
    } on LocationPermissionPermanentlyDeniedException catch (e) {
      if (!mounted) return;
      setState(() {
        _currentAddress = e.message;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _currentAddress = "Gagal memuat lokasi: $e";
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _updateMarkerAndCamera(LatLng latLng) {
    if (!mounted) return;
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: const MarkerId("currentLocation"),
          position: latLng,
          infoWindow: InfoWindow(
            title: "Lokasi Anda",
            snippet: _currentAddress,
          ),
        ),
      );
    });

    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: latLng, zoom: 15)),
    );
  }

  Future<void> _openInGoogleMaps() async {
    if (_currentPosition == null) return;

    final success = await _mapsService.openGoogleMaps(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
    );

    if (!success && mounted) {
      showFToast(
        context: context,
        title: const Text('Gagal Membuka Peta'),
        description: const Text('Tidak dapat membuka Google Maps'),
        icon: const Icon(Icons.error_outline),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final typography = context.theme.typography;
    final colors = context.theme.colors;

    return FCard(
      style: .delta(
        decoration: .boxDelta(color: colors.background.withValues(alpha: 0.8)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      FLucideIcons.mapPin,
                      size: 20,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Peta Lokasi Saat Ini',
                      style: typography.body.lg.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: _isLoading ? null : _fetchLocationAndAddress,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: colors.muted.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(FLucideIcons.refreshCw, size: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.border),
              ),
              clipBehavior: Clip.antiAlias,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _currentPosition != null
                      ? LatLng(
                          _currentPosition!.latitude,
                          _currentPosition!.longitude,
                        )
                      : _defaultLocation,
                  zoom: 15.0,
                ),
                markers: _markers,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                mapToolbarEnabled: true,
                gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                  Factory<OneSequenceGestureRecognizer>(
                    () => EagerGestureRecognizer(),
                  ),
                },
                onMapCreated: (GoogleMapController controller) {
                  _mapController = controller;
                  if (_currentPosition != null) {
                    _updateMarkerAndCamera(
                      LatLng(
                        _currentPosition!.latitude,
                        _currentPosition!.longitude,
                      ),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  FLucideIcons.map,
                  size: 16,
                  color: Colors.blueAccent,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _isLoading
                      ? Text(
                          "Memperbarui alamat...",
                          style: typography.body.sm.copyWith(
                            fontStyle: FontStyle.italic,
                            color: colors.mutedForeground,
                          ),
                        )
                      : Text(_currentAddress, style: typography.body.sm),
                ),
              ],
            ),
            if (_currentPosition != null) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_currentPosition!.latitude.toStringAsFixed(5)}, ${_currentPosition!.longitude.toStringAsFixed(5)}',
                    style: typography.body.xs.copyWith(
                      color: colors.mutedForeground,
                    ),
                  ),
                  GestureDetector(
                    onTap: _openInGoogleMaps,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Buka di Google Maps',
                          style: typography.body.xs.copyWith(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.open_in_new,
                          size: 12,
                          color: Colors.blueAccent,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

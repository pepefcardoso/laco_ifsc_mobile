import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/date_formatter.dart';
import '../../providers/location_provider.dart';
import '../../providers/group_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/weather_badge.dart';
import '../../widgets/online_indicator.dart';
import '../../widgets/hug_button.dart';
import '../../models/member_location_data.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadLocations();
    });
  }

  void _loadLocations() {
    final groupProvider = context.read<GroupProvider>();
    if (groupProvider.members.isNotEmpty) {
      context.read<LocationProvider>().loadMembersLocations(groupProvider.members);
    }
  }

  void _showMemberDetails(BuildContext context, MemberLocationData member) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildBottomSheet(context, member),
    );
  }

  Widget _buildBottomSheet(BuildContext context, MemberLocationData member) {
    final timeAgo = member.lastSeen != null 
        ? DateFormatter.formatRelative(member.lastSeen!.toDate()) 
        : 'Desconhecido';
        
    final isOnline = member.lastSeen != null && 
        DateTime.now().difference(member.lastSeen!.toDate()).inMinutes < 120;

    final currentUserId = context.read<AuthProvider>().currentUser?.uid ?? '';
    final groupId = context.read<GroupProvider>().currentGroup?.id ?? '';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.creme,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: AppColors.azulSuave.withValues(alpha: 0.2),
                backgroundImage: member.photoUrl.isNotEmpty 
                    ? CachedNetworkImageProvider(member.photoUrl) 
                    : null,
                child: member.photoUrl.isEmpty
                    ? Text(
                        member.name.isNotEmpty ? member.name[0].toUpperCase() : '?',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: AppColors.azulSuave),
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            member.name,
                            style: const TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.carvao,
                            ),
                          ),
                        ),
                        OnlineIndicator(isOnline: isOnline),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Visto por último: $timeAgo',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: AppColors.cinzaMorno,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (member.cityName != null && member.temperature != null && member.weatherIcon != null)
            WeatherBadge(
              cityName: member.cityName!,
              temperature: member.temperature!,
              weatherIcon: member.weatherIcon!,
            ),
          if (member.id != currentUserId && groupId.isNotEmpty) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: HugButton(
                targetUid: member.id,
                targetName: member.name,
                groupId: groupId,
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationProvider>(
      builder: (context, locationProvider, child) {
        final membersWithLocation = locationProvider.membersWithLocation;
        
        CameraPosition initialCameraPosition = const CameraPosition(
          target: LatLng(-15.79, -47.88), // Default Brazil center
          zoom: 4,
        );

        if (membersWithLocation.isNotEmpty) {
          double latSum = 0;
          double lngSum = 0;
          for (var m in membersWithLocation) {
            latSum += m.latitude;
            lngSum += m.longitude;
          }
          initialCameraPosition = CameraPosition(
            target: LatLng(latSum / membersWithLocation.length, lngSum / membersWithLocation.length),
            zoom: 10,
          );
        } else if (locationProvider.currentPosition != null) {
          initialCameraPosition = CameraPosition(
            target: LatLng(locationProvider.currentPosition!.latitude, locationProvider.currentPosition!.longitude),
            zoom: 14,
          );
        }

        Set<Marker> markers = membersWithLocation.map((member) {
          return Marker(
            markerId: MarkerId(member.id),
            position: LatLng(member.latitude, member.longitude),
            onTap: () => _showMemberDetails(context, member),
            infoWindow: InfoWindow(
              title: member.name,
              snippet: 'Toque para detalhes',
            ),
          );
        }).toSet();

        return Scaffold(
          body: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: initialCameraPosition,
                onMapCreated: (controller) => _mapController = controller,
                markers: markers,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                mapToolbarEnabled: false,
                zoomControlsEnabled: false,
              ),
              Positioned(
                top: 60,
                left: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, color: AppColors.coralSuave),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${membersWithLocation.length} localizaç${membersWithLocation.length == 1 ? "ão" : "ões"} ativa${membersWithLocation.length == 1 ? "" : "s"}',
                          style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                      if (locationProvider.isLoading)
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.azulSuave),
                        )
                      else
                        GestureDetector(
                          onTap: _loadLocations,
                          child: const Icon(Icons.refresh, color: AppColors.cinzaMorno, size: 20),
                        ),
                    ],
                  ),
                ),
              ),
              if (locationProvider.errorMessage != null && membersWithLocation.isEmpty)
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.coralSuave.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      locationProvider.errorMessage!,
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.brancoPuro,
            child: const Icon(Icons.my_location, color: AppColors.azulSuave),
            onPressed: () {
              if (locationProvider.currentPosition != null && _mapController != null) {
                _mapController!.animateCamera(
                  CameraUpdate.newLatLngZoom(
                    LatLng(locationProvider.currentPosition!.latitude, locationProvider.currentPosition!.longitude),
                    14,
                  ),
                );
              } else {
                final authProvider = context.read<AuthProvider>();
                if (authProvider.currentUser != null) {
                  context.read<LocationProvider>().updateLocationAndWeather(authProvider.currentUser!.uid);
                }
              }
            },
          ),
        );
      },
    );
  }
}


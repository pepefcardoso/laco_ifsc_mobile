import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/location_provider.dart';
import '../../providers/group_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/member_location_data.dart';
import '../../widgets/map_header_card.dart';
import '../../widgets/member_bottom_sheet.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadLocations());
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
      builder: (context) {
        final currentUserId = context.read<AuthProvider>().currentUser?.uid ?? '';
        final groupId = context.read<GroupProvider>().currentGroup?.id ?? '';
        return MemberBottomSheet(
          member: member,
          currentUserId: currentUserId,
          groupId: groupId,
        );
      },
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
            infoWindow: InfoWindow(title: member.name, snippet: 'Toque para detalhes'),
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
                child: MapHeaderCard(
                  locationsCount: membersWithLocation.length,
                  isLoading: locationProvider.isLoading,
                  onRefresh: _loadLocations,
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


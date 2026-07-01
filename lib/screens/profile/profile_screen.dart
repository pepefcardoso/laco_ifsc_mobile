import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';
import '../../providers/group_provider.dart';
import '../../providers/location_provider.dart';
import 'edit_profile_sheet.dart';

class ProfileScreen extends StatefulWidget {
  final String? uid;
  const ProfileScreen({super.key, this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      final groupProvider = context.read<GroupProvider>();
      final targetUid = widget.uid ?? authProvider.currentUser?.uid;
      final groupId = groupProvider.currentGroup?.id;
      
      if (targetUid != null && groupId != null) {
        context.read<ProfileProvider>().loadUserPosts(targetUid, groupId);
      }
    });
  }

  void _showEditProfile(BuildContext context, var userModel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EditProfileSheet(user: userModel),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final profileProvider = context.watch<ProfileProvider>();
    final locationProvider = context.watch<LocationProvider>();
    
    // For now, ProfileScreen only supports the current user, as there's no cross-profile navigation yet
    final userModel = authProvider.userModel;
    if (userModel == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final isCurrentUser = widget.uid == null || widget.uid == userModel.id;
    
    // Find member location data if available
    final memberLocation = locationProvider.membersWithLocation.cast<dynamic>().firstWhere(
      (m) => m.id == userModel.id,
      orElse: () => null,
    );

    String locationText = 'Localização desconhecida';
    if (memberLocation != null && memberLocation.cityName != null) {
      locationText = '${memberLocation.cityName}';
      if (memberLocation.temperature != null) {
        locationText += ' • ${memberLocation.temperature}°C ${memberLocation.weatherIcon}';
      }
    }

    return Scaffold(
      backgroundColor: AppColors.creme,
      appBar: AppBar(
        title: const Text('Perfil', style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, color: AppColors.carvao)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (isCurrentUser)
            IconButton(
              icon: const Icon(Icons.logout, color: AppColors.coralSuave),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Sair do App', style: TextStyle(fontFamily: 'Nunito')),
                    content: const Text('Tem certeza de que deseja encerrar a sessão?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          authProvider.logout();
                          Navigator.pushReplacementNamed(context, AppRoutes.login);
                        },
                        child: const Text('Sair', style: TextStyle(color: AppColors.coralSuave)),
                      ),
                    ],
                  ),
                );
              },
            )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppColors.paddingLateral),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Center(
                child: CircleAvatar(
                  radius: 48,
                  backgroundColor: AppColors.azulSuave.withValues(alpha: 0.2),
                  backgroundImage: userModel.photoUrl.isNotEmpty ? CachedNetworkImageProvider(userModel.photoUrl) : null,
                  child: userModel.photoUrl.isEmpty
                      ? Text(
                          userModel.name.isNotEmpty ? userModel.name[0].toUpperCase() : '?',
                          style: const TextStyle(fontFamily: 'Nunito', fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.azulSuave),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                userModel.name,
                style: const TextStyle(fontFamily: 'Nunito', fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.carvao),
              ),
              const SizedBox(height: 4),
              Text(
                locationText,
                style: const TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.cinzaMorno),
              ),
              if (isCurrentUser) ...[
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () => _showEditProfile(context, userModel),
                  child: const Text(
                    'Editar perfil',
                    style: TextStyle(fontFamily: 'Inter', color: AppColors.azulSuave, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ],
              const SizedBox(height: 32),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Meus Momentos', style: TextStyle(fontFamily: 'Nunito', fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 16),
              if (profileProvider.isLoading)
                const CircularProgressIndicator(color: AppColors.azulSuave)
              else if (profileProvider.userPosts.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      Icon(Icons.photo_library_outlined, size: 48, color: AppColors.cinzaMorno.withValues(alpha: 0.5)),
                      const SizedBox(height: 16),
                      const Text('Nenhum momento publicado.', style: TextStyle(color: AppColors.cinzaMorno)),
                    ],
                  ),
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: profileProvider.userPosts.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: AppColors.gapCards,
                    mainAxisSpacing: AppColors.gapCards,
                    childAspectRatio: 1.0,
                  ),
                  itemBuilder: (context, index) {
                    final post = profileProvider.userPosts[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.brancoPuro,
                        borderRadius: BorderRadius.circular(AppColors.radiusCard),
                        boxShadow: AppColors.shadowPadrao,
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(post.imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
